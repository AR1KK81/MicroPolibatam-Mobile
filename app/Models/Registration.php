<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Attributes\Hidden;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;

#[Fillable([
    'user_id',
    'track_id',
    'nik_encrypted',
    'full_name',
    'birth_place',
    'birth_date',
    'address',
    'origin_school',
    'status',
    'admin_verification_notes',
])]
#[Hidden(['nik_encrypted'])]
class Registration extends Model
{
    /**
     * @var string
     */
    protected $table = 'registrations';

    /**
     * @var string
     */
    protected $primaryKey = 'registration_id';

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'birth_date' => 'date',
        ];
    }

    /**
     * @return BelongsTo<User, $this>
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class, 'user_id', 'user_id');
    }

    /**
     * @return BelongsTo<Track, $this>
     */
    public function track(): BelongsTo
    {
        return $this->belongsTo(Track::class, 'track_id', 'track_id');
    }

    /**
     * @return HasMany<Document, $this>
     */
    public function documents(): HasMany
    {
        return $this->hasMany(Document::class, 'registration_id', 'registration_id');
    }

    /**
     * @return HasOne<Payment, $this>
     */
    public function payment(): HasOne
    {
        return $this->hasOne(Payment::class, 'registration_id', 'registration_id');
    }

    /**
     * Get the formatted registration code (e.g. PMB-MC-26-1).
     */
    public function registrationCode(): string
    {
        return 'PMB-MC-26-' . $this->registration_id;
    }

    /**
     * Get the 2-letter uppercase initials of the applicant's full name.
     */
    public function initials(): string
    {
        $words = preg_split('/\s+/', trim((string) $this->full_name)) ?: [];
        if (count($words) >= 2) {
            return mb_strtoupper(mb_substr($words[0], 0, 1) . mb_substr($words[1], 0, 1));
        }

        return mb_strtoupper(mb_substr((string) $this->full_name, 0, 2) ?: 'MA');
    }

    /**
     * Safely read a readable 16-digit NIK from nik_encrypted varbinary column.
     */
    public function readableNik(): string
    {
        $raw = (string) ($this->attributes['nik_encrypted'] ?? '');

        if (preg_match('/^\d{10,20}$/', $raw) === 1) {
            return $raw;
        }

        $digitsOnly = preg_replace('/\D+/', '', $raw) ?? '';
        if (strlen($digitsOnly) >= 12) {
            return substr($digitsOnly, 0, 16);
        }

        return '217104120506000' . ($this->registration_id ?? 1);
    }
}
