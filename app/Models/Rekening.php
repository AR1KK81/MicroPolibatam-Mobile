<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

#[Fillable(['bank_name', 'account_number', 'account_name', 'nominal_biaya', 'is_active', 'created_at'])]
class Rekening extends Model
{
    /**
     * @var string
     */
    protected $table = 'rekening';

    /**
     * @var string
     */
    protected $primaryKey = 'rekening_id';

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
            'nominal_biaya' => 'decimal:2',
            'is_active' => 'boolean',
            'created_at' => 'datetime',
        ];
    }

    /**
     * @return HasMany<Payment, $this>
     */
    public function payments(): HasMany
    {
        return $this->hasMany(Payment::class, 'rekening_id', 'rekening_id');
    }
}

