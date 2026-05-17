<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('canteen_stalls', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('description')->nullable();
            $table->string('image_url')->nullable();
            $table->decimal('rating', 3, 2)->default(5.00);
            $table->boolean('is_approved')->default(false);
            $table->string('status')->default('active'); // active, suspended
            $table->foreignId('vendor_id')->constrained('users')->onDelete('cascade');
            $table->decimal('commission_pct', 5, 2)->default(10.00);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('canteen_stalls');
    }
};
