<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

#[Fillable([
    'registration_id',
    'rekening_id',
    'amount',
    'proof_file_path',
    'status_pembayaran',
    'finance_notes',
    'verified_by',
    'payment_date',
    'verified_at',
])]
class Payment extends Model
{
    /**
     * @var string
     */
    protected $table = 'payments';

    /**
     * @var string
     */
    protected $primaryKey = 'payment_id';

    /**
     * @var bool
     */
    public $timestamps = false;

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'amount' => 'decimal:2',
            'payment_date' => 'datetime',
            'verified_at' => 'datetime',
        ];
    }

    /**
     * @return BelongsTo<Registration, $this>
     */
    public function registration(): BelongsTo
    {
        return $this->belongsTo(Registration::class, 'registration_id', 'registration_id');
    }

    /**
     * @return BelongsTo<Rekening, $this>
     */
    public function rekening(): BelongsTo
    {
        return $this->belongsTo(Rekening::class, 'rekening_id', 'rekening_id');
    }

    /**
     * @return BelongsTo<User, $this>
     */
    public function verifier(): BelongsTo
    {
        return $this->belongsTo(User::class, 'verified_by', 'user_id');
    }
}

