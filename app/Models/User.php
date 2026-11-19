<?php

namespace App\Models;

use App\Enums\UserRole;
use Database\Factories\UserFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Attributes\Hidden;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

#[Fillable(['email', 'password_hash', 'role', 'is_verified'])]
#[Hidden(['password_hash'])]
class User extends Authenticatable
{
    /** @use HasFactory<UserFactory> */
    use HasFactory, Notifiable;

    /**
     * The primary key for the model.
     *
     * @var string
     */
    protected $primaryKey = 'user_id';

    /**
     * The column name of the password field used during authentication.
     *
     * @var string
     */
    protected $authPasswordName = 'password_hash';

    /**
     * Disable persistent remember_token column because users table has none.
     *
     * @var string
     */
    protected $rememberTokenName = '';

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'role' => UserRole::class,
            'is_verified' => 'boolean',
            'password_hash' => 'hashed',
        ];
    }

    /**
     * Get the registration associated with the user (for Maba).
     *
     * @return HasOne<Registration, $this>
     */
    public function registration(): HasOne
    {
        return $this->hasOne(Registration::class, 'user_id', 'user_id');
    }

    /**
     * Resolve the named dashboard route for this user's role.
     */
    public function dashboardRoute(): string
    {
        $role = $this->role instanceof UserRole
            ? $this->role
            : UserRole::from((string) $this->role);

        return $role->dashboardRoute();
    }
}
