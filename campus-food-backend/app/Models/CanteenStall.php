<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class CanteenStall extends Model
{
    protected $fillable = [
        'name',
        'description',
        'image_url',
        'rating',
        'is_approved',
        'status',
        'vendor_id',
        'commission_pct',
    ];

    protected $casts = [
        'is_approved' => 'boolean',
        'rating' => 'float',
        'commission_pct' => 'float',
    ];

    public function vendor(): BelongsTo
    {
        return $this->belongsTo(User::class, 'vendor_id');
    }

    public function foodItems(): HasMany
    {
        return $this->hasMany(FoodItem::class, 'stall_id');
    }

    public function orders(): HasMany
    {
        return $this->hasMany(Order::class, 'stall_id');
    }
}
