<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

#[Fillable(['department_name', 'study_program_name', 'track_name', 'is_active'])]
class Track extends Model
{
    /**
     * @var string
     */
    protected $table = 'tracks';

    /**
     * @var string
     */
    protected $primaryKey = 'track_id';

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
     * @return HasMany<Registration, $this>
     */
    public function registrations(): HasMany
    {
        return $this->hasMany(Registration::class, 'track_id', 'track_id');
    }
}

