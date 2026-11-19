<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;
use Throwable;

#[Fillable(['actor', 'action', 'object', 'timestamp', 'result'])]
class AuditLog extends Model
{
    /**
     * @var string
     */
    protected $table = 'audit_logs';

    /**
     * @var string
     */
    protected $primaryKey = 'audit_id';

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
            'timestamp' => 'datetime',
        ];
    }

    /**
     * Safely record an audit log entry without breaking the main user flow.
     */
    public static function record(string $actor, string $action, string $object, string $result): ?self
    {
        try {
            return self::query()->create([
                'actor' => mb_substr($actor, 0, 100),
                'action' => mb_substr($action, 0, 50),
                'object' => mb_substr($object, 0, 100),
                'timestamp' => now(),
                'result' => mb_substr($result, 0, 255),
            ]);
        } catch (Throwable) {
            return null;
        }
    }
}

