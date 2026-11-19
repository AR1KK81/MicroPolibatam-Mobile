<?php

namespace App\Http\Middleware;

use App\Enums\UserRole;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureUserHasRole
{
    /**
     * Ensure the authenticated user matches one of the permitted roles.
     *
     * @param  Closure(Request): (Response)  $next
     */
    public function handle(Request $request, Closure $next, string ...$roles): Response
    {
        $user = $request->user();

        if ($user === null) {
            return redirect()->route('login');
        }

        $userRoleValue = $user->role instanceof UserRole
            ? $user->role->value
            : (string) $user->role;

        if (! in_array($userRoleValue, $roles, true)) {
            return redirect()->route($user->dashboardRoute());
        }

        return $next($request);
    }
}

