<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\CanteenStall;
use App\Models\FoodItem;
use App\Models\Order;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // 1. Create Student User (matching prototype name "Jhonlord Dagasuan")
        $student = User::updateOrCreate(
            ['email' => 'student@example.com'],
            [
                'name' => 'Jhonlord Dagasuan',
                'password' => Hash::make('password'),
                'role' => 'customer',
                'campus_id' => '20221270',
            ]
        );

        // 2. Create Vendor Users
        $vendorMaria = User::updateOrCreate(
            ['email' => 'maria.stalls@campus.edu'],
            [
                'name' => 'Chef Maria',
                'password' => Hash::make('password'),
                'role' => 'vendor',
                'campus_id' => 'VND-7782',
                'stall_name' => "Maria's Homestyle Meals",
            ]
        );

        $vendorWok = User::updateOrCreate(
            ['email' => 'wok.vendor@campus.edu'],
            [
                'name' => 'Chef Ken',
                'password' => Hash::make('password'),
                'role' => 'vendor',
                'campus_id' => 'VND-8890',
                'stall_name' => 'Wok & Roll Express',
            ]
        );

        $vendorGreen = User::updateOrCreate(
            ['email' => 'green.vendor@campus.edu'],
            [
                'name' => 'Chef Sarah',
                'password' => Hash::make('password'),
                'role' => 'vendor',
                'campus_id' => 'VND-9912',
                'stall_name' => 'The Green Fork (Salads)',
            ]
        );

        // 3. Create Admin User (matching prototype)
        $admin = User::updateOrCreate(
            ['email' => 'admin@example.com'],
            [
                'name' => 'Superuser Authority',
                'password' => Hash::make('password'),
                'role' => 'admin',
                'campus_id' => 'ADM-0001',
            ]
        );

        // 4. Create Canteen Stalls matching prototype screens
        $stallMaria = CanteenStall::updateOrCreate(
            ['vendor_id' => $vendorMaria->id],
            [
                'name' => "Maria's Homestyle Meals",
                'description' => 'Delicious, nutritious home-style Filipino meals and classic snacks.',
                'image_url' => 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
                'rating' => 4.8,
                'is_approved' => true,
                'status' => 'active',
                'commission_pct' => 10.00,
            ]
        );

        $stallWok = CanteenStall::updateOrCreate(
            ['vendor_id' => $vendorWok->id],
            [
                'name' => 'Wok & Roll Express',
                'description' => 'Vibrant, stir-fried noodles and classic Asian campus eats.',
                'image_url' => 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400',
                'rating' => 4.6,
                'is_approved' => true,
                'status' => 'active',
                'commission_pct' => 10.00,
            ]
        );

        $stallGreen = CanteenStall::updateOrCreate(
            ['vendor_id' => $vendorGreen->id],
            [
                'name' => 'The Green Fork (Salads)',
                'description' => 'Fresh organic salads and cold-pressed campus green juices.',
                'image_url' => 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
                'rating' => 4.7,
                'is_approved' => true,
                'status' => 'active',
                'commission_pct' => 10.00,
            ]
        );

        // 5. Create Food Items matching the screenshots exactly
        $foodItems = [
            // Maria's Homestyle Meals
            [
                'stall_id' => $stallMaria->id,
                'name' => 'Chicken Adobo Rice Meal',
                'description' => 'Savory chicken adobo served over warm, fragrant rice with boiled egg.',
                'price' => 95.00,
                'category' => 'Meals',
                'image_url' => 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=300',
                'is_available' => true,
            ],
            [
                'stall_id' => $stallMaria->id,
                'name' => 'Pork Sinigang Soup',
                'description' => 'Traditional sour tamarind broth with tender pork and fresh native vegetables.',
                'price' => 110.00,
                'category' => 'Meals',
                'image_url' => 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300',
                'is_available' => true,
            ],
            [
                'stall_id' => $stallMaria->id,
                'name' => 'Mango Shake',
                'description' => 'Freshly blended sweet ripe mangoes with milk and crushed ice.',
                'price' => 55.00,
                'category' => 'Drinks',
                'image_url' => 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300',
                'is_available' => true,
            ],

            // Wok & Roll Express
            [
                'stall_id' => $stallWok->id,
                'name' => 'Chow Mein Noodles',
                'description' => 'Classic stir-fried egg noodles with vegetables and chicken strips.',
                'price' => 85.00,
                'category' => 'Meals',
                'image_url' => 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=300',
                'is_available' => true,
            ],

            // The Green Fork
            [
                'stall_id' => $stallGreen->id,
                'name' => 'Caesar Salad',
                'description' => 'Crisp romaine lettuce, croutons, parmesan cheese, and creamy caesar dressing.',
                'price' => 115.00,
                'category' => 'Meals',
                'image_url' => 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300',
                'is_available' => true,
            ]
        ];

        foreach ($foodItems as $item) {
            FoodItem::updateOrCreate(
                [
                    'stall_id' => $item['stall_id'],
                    'name' => $item['name']
                ],
                [
                    'description' => $item['description'],
                    'price' => $item['price'],
                    'category' => $item['category'],
                    'image_url' => $item['image_url'],
                    'is_available' => $item['is_available'],
                ]
            );
        }

        // 6. Seed Mock Orders to produce the EXACT sales figures on the Figma Admin dashboard
        // Maria's Homestyle Meals sales total = ₱14,520
        Order::updateOrCreate(
            ['customer_id' => $student->id, 'stall_id' => $stallMaria->id, 'total' => 8520.00],
            [
                'status' => 'completed',
                'pickup_time' => 'ASAP',
                'payment_method' => 'GCash',
                'payment_status' => 'paid',
                'rating' => 5.0,
                'comment' => 'Delicious food!',
            ]
        );

        Order::updateOrCreate(
            ['customer_id' => $student->id, 'stall_id' => $stallMaria->id, 'total' => 6000.00],
            [
                'status' => 'completed',
                'pickup_time' => '12:00 PM',
                'payment_method' => 'GCash',
                'payment_status' => 'paid',
                'rating' => 5.0,
                'comment' => 'Super fast service.',
            ]
        );

        // Wok & Roll Express sales total = ₱12,300
        Order::updateOrCreate(
            ['customer_id' => $student->id, 'stall_id' => $stallWok->id, 'total' => 7300.00],
            [
                'status' => 'completed',
                'pickup_time' => 'ASAP',
                'payment_method' => 'GCash',
                'payment_status' => 'paid',
                'rating' => 4.5,
                'comment' => 'Great noodles!',
            ]
        );

        Order::updateOrCreate(
            ['customer_id' => $student->id, 'stall_id' => $stallWok->id, 'total' => 5000.00],
            [
                'status' => 'completed',
                'pickup_time' => '1:00 PM',
                'payment_method' => 'Cash',
                'payment_status' => 'paid',
                'rating' => 5.0,
            ]
        );

        // The Green Fork (Salads) sales total = ₱9,090
        Order::updateOrCreate(
            ['customer_id' => $student->id, 'stall_id' => $stallGreen->id, 'total' => 5090.00],
            [
                'status' => 'completed',
                'pickup_time' => 'ASAP',
                'payment_method' => 'GCash',
                'payment_status' => 'paid',
                'rating' => 5.0,
                'comment' => 'Very healthy.',
            ]
        );

        Order::updateOrCreate(
            ['customer_id' => $student->id, 'stall_id' => $stallGreen->id, 'total' => 4000.00],
            [
                'status' => 'completed',
                'pickup_time' => '11:30 AM',
                'payment_method' => 'Cash',
                'payment_status' => 'paid',
                'rating' => 4.0,
            ]
        );
    }
}

