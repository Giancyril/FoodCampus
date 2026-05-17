<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class FoodItem extends Model
{
    protected $fillable = [
        'name',
        'description',
        'image_url',
        'price',
        'category',
        'is_available',
        'stall_id',
    ];

    protected $casts = [
        'price' => 'float',
        'is_available' => 'boolean',
    ];

    public function canteenStall(): BelongsTo
    {
        return $this->belongsTo(CanteenStall::class, 'stall_id');
    }
}
