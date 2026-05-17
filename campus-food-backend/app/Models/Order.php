<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Order extends Model
{
    protected $fillable = [
        'customer_id',
        'stall_id',
        'total',
        'status',
        'pickup_time',
        'payment_method',
        'payment_status',
        'rating',
        'comment',
    ];

    protected $casts = [
        'total' => 'float',
        'rating' => 'float',
    ];

    public function customer(): BelongsTo
    {
        return $this->belongsTo(User::class, 'customer_id');
    }

    public function canteenStall(): BelongsTo
    {
        return $this->belongsTo(CanteenStall::class, 'stall_id');
    }

    public function orderItems(): HasMany
    {
        return $this->hasMany(OrderItem::class, 'order_id');
    }
}
