<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Category extends Model{

    const CREATED_AT = 'date_creation';
    const UPDATED_AT = 'date_update';

    //table associated with the model
    protected $table = 'jc_categories';

    //mass assignable attributes
    protected $fillable =[
        'name',
        'type',
        'color',
        'status',
        'user_id',
    ];

    //casted attributes
    protected $casts = [
        'date_creation' => 'datetime',
        'date_update' => 'datetime',
    ];

    //who created the category
    public function user(){
        return $this->belongsTo(User::class, 'user_id');
    }
}
