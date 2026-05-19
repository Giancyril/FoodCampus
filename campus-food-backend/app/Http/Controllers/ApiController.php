<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\CanteenStall;
use App\Models\FoodItem;
use App\Models\Order;
use App\Models\OrderItem;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class ApiController extends Controller
{
    // ==========================================
    // 1. AUTHENTICATION ENDPOINTS
    // ==========================================
    public function register(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:6',
            'role' => 'required|string|in:customer,vendor,admin',
            'campus_id' => 'required|string',
            'stall_name' => 'nullable|string',
        ]);

        DB::beginTransaction();
        try {
            $user = User::create([
                'name' => $validated['name'],
                'email' => $validated['email'],
                'password' => Hash::make($validated['password']),
                'role' => $validated['role'],
                'campus_id' => $validated['campus_id'],
                'stall_name' => $validated['stall_name'] ?? null,
            ]);

            // If registering as vendor, create a canteen stall awaiting admin approval
            if ($validated['role'] === 'vendor') {
                CanteenStall::create([
                    'name' => $validated['stall_name'] ?? ($validated['name'] . "'s Stall"),
                    'description' => 'Delicious food on campus',
                    'image_url' => 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&q=80&w=400',
                    'rating' => 5.00,
                    'is_approved' => false,
                    'status' => 'active',
                    'vendor_id' => $user->id,
                    'commission_pct' => 10.00,
                ]);
            }

            DB::commit();

            $token = $user->createToken('CampusFoodExpress')->accessToken;

            return response()->json([
                'status' => 'success',
                'message' => 'User registered successfully',
                'user' => $user->load('canteenStall'),
                'token' => $token,
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage()
            ], 500);
        }
    }

    public function login(Request $request)
    {
        $validated = $request->validate([
            'email' => 'required|string',
            'password' => 'required|string',
        ]);

        $loginField = $request->input('email');
        
        $user = User::where('email', $loginField)
                    ->orWhere('campus_id', $loginField)
                    ->first();

        if (!$user || !\Illuminate\Support\Facades\Hash::check($request->input('password'), $user->password)) {
            return response()->json([
                'status' => 'error',
                'message' => 'Invalid email/student ID or password'
            ], 401);
        }

        Auth::login($user);
        $token = $user->createToken('CampusFoodExpress')->accessToken;

        return response()->json([
            'status' => 'success',
            'message' => 'Logged in successfully',
            'user' => $user->load('canteenStall'),
            'token' => $token,
        ]);
    }

    public function profile(Request $request)
    {
        return response()->json([
            'status' => 'success',
            'user' => $request->user()->load('canteenStall')
        ]);
    }

    public function logout(Request $request)
    {
        $request->user()->token()->revoke();
        return response()->json([
            'status' => 'success',
            'message' => 'Logged out successfully'
        ]);
    }

    // ==========================================
    // 2. CANTEEN STALLS ENDPOINTS
    // ==========================================
    public function listCanteens(Request $request)
    {
        // Customers only see approved canteens, admins see all
        $user = $request->user();
        if ($user && $user->role === 'admin') {
            $stalls = CanteenStall::with('vendor')->get();
        } else {
            $stalls = CanteenStall::where('is_approved', true)
                ->where('status', 'active')
                ->get();
        }

        return response()->json([
            'status' => 'success',
            'canteens' => $stalls
        ]);
    }

    public function getCanteenMenu($id)
    {
        $stall = CanteenStall::findOrFail($id);
        $menu = FoodItem::where('stall_id', $id)->get();

        return response()->json([
            'status' => 'success',
            'canteen' => $stall,
            'menu' => $menu
        ]);
    }

    // ==========================================
    // 3. VENDOR MENU MANAGER ENDPOINTS
    // ==========================================
    public function addFoodItem(Request $request)
    {
        $user = $request->user();
        if ($user->role !== 'vendor') {
            return response()->json(['status' => 'error', 'message' => 'Unauthorized'], 403);
        }

        $stall = CanteenStall::where('vendor_id', $user->id)->firstOrFail();

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'image_url' => 'nullable|string',
            'price' => 'required|numeric|min:0',
            'category' => 'required|string|in:Meals,Drinks,Snacks',
        ]);

        $food = FoodItem::create([
            'name' => $validated['name'],
            'description' => $validated['description'] ?? 'Delicious campus item',
            'image_url' => $validated['image_url'] ?? 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&q=80&w=400',
            'price' => $validated['price'],
            'category' => $validated['category'],
            'is_available' => true,
            'stall_id' => $stall->id,
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Food item added successfully',
            'food_item' => $food
        ], 201);
    }

    public function toggleFoodAvailability(Request $request, $id)
    {
        $user = $request->user();
        if ($user->role !== 'vendor') {
            return response()->json(['status' => 'error', 'message' => 'Unauthorized'], 403);
        }

        $stall = CanteenStall::where('vendor_id', $user->id)->firstOrFail();
        $food = FoodItem::where('id', $id)->where('stall_id', $stall->id)->firstOrFail();

        $food->is_available = !$food->is_available;
        $food->save();

        return response()->json([
            'status' => 'success',
            'message' => 'Availability updated successfully',
            'food_item' => $food
        ]);
    }

    // ==========================================
    // 4. TRANSACTION & ORDER FLOWS
    // ==========================================
    public function placeOrder(Request $request)
    {
        $user = $request->user();
        if ($user->role !== 'customer') {
            return response()->json(['status' => 'error', 'message' => 'Only customers can place orders'], 403);
        }

        $validated = $request->validate([
            'stall_id' => 'required|exists:canteen_stalls,id',
            'items' => 'required|array|min:1',
            'items.*.food_item_id' => 'required|exists:food_items,id',
            'items.*.quantity' => 'required|integer|min:1',
            'items.*.notes' => 'nullable|string',
            'pickup_time' => 'required|string',
            'payment_method' => 'required|string',
        ]);

        DB::beginTransaction();
        try {
            $total = 0;
            $orderItemsToCreate = [];

            foreach ($validated['items'] as $item) {
                $food = FoodItem::where('id', $item['food_item_id'])
                    ->where('stall_id', $validated['stall_id'])
                    ->firstOrFail();

                if (!$food->is_available) {
                    throw new \Exception("Food item '{$food->name}' is currently unavailable");
                }

                $itemTotal = $food->price * $item['quantity'];
                $total += $itemTotal;

                $orderItemsToCreate[] = [
                    'food_item_id' => $food->id,
                    'quantity' => $item['quantity'],
                    'notes' => $item['notes'] ?? null,
                    'price' => $food->price,
                ];
            }

            // Apply 5% VAT (matching Flutter frontend logic)
            $vat = $total * 0.05;
            $grandTotal = $total + $vat;

            $order = Order::create([
                'customer_id' => $user->id,
                'stall_id' => $validated['stall_id'],
                'total' => $grandTotal,
                'status' => 'pending',
                'pickup_time' => $validated['pickup_time'],
                'payment_method' => $validated['payment_method'],
                'payment_status' => 'paid', // Instant authorize in mock checkout
            ]);

            foreach ($orderItemsToCreate as $itemData) {
                $itemData['order_id'] = $order->id;
                OrderItem::create($itemData);
            }

            DB::commit();

            return response()->json([
                'status' => 'success',
                'message' => 'Order placed successfully',
                'order' => $order->load('orderItems.foodItem')
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage()
            ], 400);
        }
    }

    public function listOrders(Request $request)
    {
        $user = $request->user();

        if ($user->role === 'customer') {
            $orders = Order::where('customer_id', $user->id)
                ->with(['canteenStall', 'orderItems.foodItem'])
                ->orderBy('created_at', 'desc')
                ->get();
        } elseif ($user->role === 'vendor') {
            $stall = CanteenStall::where('vendor_id', $user->id)->firstOrFail();
            $orders = Order::where('stall_id', $stall->id)
                ->with(['customer', 'orderItems.foodItem'])
                ->orderBy('created_at', 'desc')
                ->get();
        } else {
            // Admin lists all platform transactions
            $orders = Order::with(['customer', 'canteenStall', 'orderItems.foodItem'])
                ->orderBy('created_at', 'desc')
                ->get();
        }

        return response()->json([
            'status' => 'success',
            'orders' => $orders
        ]);
    }

    public function updateOrderStatus(Request $request, $id)
    {
        $user = $request->user();
        if ($user->role !== 'vendor') {
            return response()->json(['status' => 'error', 'message' => 'Unauthorized'], 403);
        }

        $validated = $request->validate([
            'status' => 'required|string|in:preparing,ready,completed,cancelled',
        ]);

        $stall = CanteenStall::where('vendor_id', $user->id)->firstOrFail();
        $order = Order::where('id', $id)->where('stall_id', $stall->id)->firstOrFail();

        $order->status = $validated['status'];
        if ($validated['status'] === 'completed') {
            $order->payment_status = 'paid';
        }
        $order->save();

        return response()->json([
            'status' => 'success',
            'message' => "Order status updated to {$validated['status']}",
            'order' => $order
        ]);
    }

    public function submitRating(Request $request, $id)
    {
        $user = $request->user();
        if ($user->role !== 'customer') {
            return response()->json(['status' => 'error', 'message' => 'Unauthorized'], 403);
        }

        $validated = $request->validate([
            'rating' => 'required|numeric|min:1|max:5',
            'comment' => 'nullable|string',
        ]);

        $order = Order::where('id', $id)->where('customer_id', $user->id)->firstOrFail();
        if ($order->status !== 'completed') {
            return response()->json(['status' => 'error', 'message' => 'Order must be completed before rating'], 400);
        }

        $order->rating = $validated['rating'];
        $order->comment = $validated['comment'] ?? null;
        $order->save();

        // Update stall rating average
        $averageRating = Order::where('stall_id', $order->stall_id)
            ->whereNotNull('rating')
            ->avg('rating');

        $stall = CanteenStall::find($order->stall_id);
        if ($stall && $averageRating) {
            $stall->rating = $averageRating;
            $stall->save();
        }

        return response()->json([
            'status' => 'success',
            'message' => 'Review submitted successfully',
            'order' => $order
        ]);
    }

    // ==========================================
    // 5. ADMIN CONTROLLER ENDPOINTS
    // ==========================================
    public function approveStall(Request $request, $id)
    {
        $user = $request->user();
        if ($user->role !== 'admin') {
            return response()->json(['status' => 'error', 'message' => 'Unauthorized'], 403);
        }

        $stall = CanteenStall::findOrFail($id);
        $stall->is_approved = true;
        $stall->save();

        return response()->json([
            'status' => 'success',
            'message' => 'Stall approved successfully',
            'canteen' => $stall
        ]);
    }

    public function rejectStall(Request $request, $id)
    {
        $user = $request->user();
        if ($user->role !== 'admin') {
            return response()->json(['status' => 'error', 'message' => 'Unauthorized'], 403);
        }

        $stall = CanteenStall::findOrFail($id);
        $stall->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Stall registration rejected and deleted'
        ]);
    }

    public function toggleStallStatus(Request $request, $id)
    {
        $user = $request->user();
        if ($user->role !== 'admin') {
            return response()->json(['status' => 'error', 'message' => 'Unauthorized'], 403);
        }

        $stall = CanteenStall::findOrFail($id);
        $stall->status = ($stall->status === 'active') ? 'suspended' : 'active';
        $stall->save();

        return response()->json([
            'status' => 'success',
            'message' => "Stall status updated to {$stall->status}",
            'canteen' => $stall
        ]);
    }

    public function adminAnalytics(Request $request)
    {
        $user = $request->user();
        if ($user->role !== 'admin') {
            return response()->json(['status' => 'error', 'message' => 'Unauthorized'], 403);
        }

        $totalSales = Order::where('status', 'completed')->sum('total');
        // Standard 10% commission
        $commissions = $totalSales * 0.10;

        $stallsLedger = CanteenStall::withSum(['orders as total_sales' => function ($query) {
            $query->where('status', 'completed');
        }], 'total')->get()->map(function ($stall) {
            $sales = $stall->total_sales ?? 0.00;
            return [
                'stall_name' => $stall->name,
                'sales' => (float)$sales,
                'commission' => (float)($sales * ($stall->commission_pct / 100.00)),
            ];
        });

        return response()->json([
            'status' => 'success',
            'total_sales' => (float)$totalSales,
            'commission_earned' => (float)$commissions,
            'ledger' => $stallsLedger
        ]);
    }
}
