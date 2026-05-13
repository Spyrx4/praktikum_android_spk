<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class wp_results extends Model
{
    protected $table="wp_results";
    protected $fillable=[
        "smartphone_id",
        "nilai_s",
        "nilai_v",
        "ranking"
    ];
}
