<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ApiController;

// Public Guest Routes
Route::post('/register', [ApiController::class, 'register']);
Route::post('/login', [ApiController::class, 'login']);
Route::get('/canteens', [ApiController::class, 'listCanteens']);
Route::get('/canteens/{id}/menu', [ApiController::class, 'getCanteenMenu']);

// Authenticated Routes (Requires Passport access token)
Route::middleware('auth:api')->group(function () {
    // Auth & profile
    Route::get('/user', [ApiController::class, 'profile']);
    Route::post('/logout', [ApiController::class, 'logout']);

    // Customer Cart & Checkout & Rating
    Route::post('/orders', [ApiController::class, 'placeOrder']);
    Route::get('/orders', [ApiController::class, 'listOrders']);
    Route::post('/orders/{id}/rate', [ApiController::class, 'submitRating']);

    // Vendor Menu & Order Fulfillments
    Route::post('/menu/add', [ApiController::class, 'addFoodItem']);
    Route::post('/menu/{id}/toggle-availability', [ApiController::class, 'toggleFoodAvailability']);
    Route::post('/orders/{id}/status', [ApiController::class, 'updateOrderStatus']);

    // Admin Panel Actions
    Route::post('/canteens/{id}/approve', [ApiController::class, 'approveStall']);
    Route::post('/canteens/{id}/reject', [ApiController::class, 'rejectStall']);
    Route::post('/canteens/{id}/toggle-status', [ApiController::class, 'toggleStallStatus']);
    Route::get('/admin/analytics', [ApiController::class, 'adminAnalytics']);
});
