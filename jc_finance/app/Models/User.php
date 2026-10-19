<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable{

    use HasApiTokens, HasFactory, Notifiable;

    const CREATED_AT = 'date_creation';
    const UPDATED_AT = 'date_update';

    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'jc_users';

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'last_name',
        'email',
        'password',
        'age',
        'sex',
        'status',
        'admin_id',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'date_creation' => 'datetime',
        'date_update' => 'datetime',
        'password' => 'hashed',
    ];

    public function admin()
    {
        return $this->belongsTo(User::class, 'admin_id');
    }

    public function createdUsers()
    {
        return $this->hasMany(User::class, 'admin_id');
    }

    public function categories()
    {
        return $this->hasMany(Category::class, 'user_id');
    }
}
