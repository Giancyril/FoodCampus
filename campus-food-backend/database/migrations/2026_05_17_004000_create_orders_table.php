<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('orders', function (Blueprint $table) {
            $table->id();
            $table->foreignId('customer_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('stall_id')->constrained('canteen_stalls')->onDelete('cascade');
            $table->decimal('total', 10, 2);
            $table->string('status')->default('pending'); // pending, preparing, ready, completed, cancelled
            $table->string('pickup_time');
            $table->string('payment_method');
            $table->string('payment_status')->default('pending'); // pending, paid
            $table->decimal('rating', 3, 2)->nullable();
            $table->text('comment')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('orders');
    }
};
