<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

#[Fillable(['name', 'role_label', 'phone', 'email', 'is_active', 'managed_by'])]
class ContactPerson extends Model
{
    /**
     * @var string
     */
    protected $table = 'contact_persons';

    /**
     * @var string
     */
    protected $primaryKey = 'cp_id';

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
            'is_active' => 'boolean',
        ];
    }

    /**
     * @return BelongsTo<User, $this>
     */
    public function manager(): BelongsTo
    {
        return $this->belongsTo(User::class, 'managed_by', 'user_id');
    }

    /**
     * Convert local phone number (08xx) into international WhatsApp format (628xx).
     */
    public function whatsappUrl(): string
    {
        $digits = preg_replace('/\D+/', '', (string) $this->phone) ?? '';
        if (str_starts_with($digits, '0')) {
            $digits = '62' . substr($digits, 1);
        }

        return 'https://wa.me/' . $digits;
    }
}

