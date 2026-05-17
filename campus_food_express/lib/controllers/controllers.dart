import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class AuthController extends GetxController {
  var currentUser = Rxn<UserProfile>();
  var isLoggedIn = false.obs;

  static const String _apiBase = "http://127.0.0.1:8000/api";
  late SharedPreferences _prefs;

  @override
  void onInit() {
    super.onInit();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    // Load previously stored active user session if any
    String? storedUser = _prefs.getString('current_user');
    if (storedUser != null) {
      try {
        var decoded = json.decode(storedUser);
        currentUser.value = UserProfile(
          id: decoded['id'],
          name: decoded['name'],
          email: decoded['email'],
          role: decoded['role'],
          campusId: decoded['campusId'],
          stallName: decoded['stallName'],
        );
        isLoggedIn.value = true;
      } catch (_) {}
    } else {
      // Default fallback auto-login
      loginAsCustomer();
    }
  }

  // Resolves the student name dynamically from email, ID, or custom map
  String _getNameFromEmailOrId(String emailOrId) {
    String clean = emailOrId.trim().toLowerCase();

    // Check locally saved mappings (e.g. from sign ups or previous logins)
    String? localSaved = _prefs.getString('name_map_$clean');
    if (localSaved != null) return localSaved;

    // Direct student ID / email mock database mapping
    Map<String, String> studentDatabase = {
      '20221270': 'Mary Jane',
      '20221270@campus.edu': 'Mary Jane',
      '20231004': 'John Doe',
      '20231004@campus.edu': 'John Doe',
      '20221234': 'Alice Smith',
      '20221234@campus.edu': 'Alice Smith',
    };

    if (studentDatabase.containsKey(clean)) {
      return studentDatabase[clean]!;
    }

    // Otherwise, parse clean name from email
    if (clean.contains('@')) {
      String part = clean.split('@')[0];
      if (part.contains('.')) {
        return part.split('.').map((s) => s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : '').join(' ');
      } else {
        return part.isNotEmpty ? part[0].toUpperCase() + part.substring(1) : 'Student';
      }
    }

    // Check if numeric (Student ID) and return formatted "Student 20221270"
    if (RegExp(r'^\d+$').hasMatch(clean)) {
      return 'Student $clean';
    }

    return emailOrId.capitalizeFirst ?? 'Student';
  }

  Future<bool> loginRemote(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiBase/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 'success') {
          var u = data['user'];
          currentUser.value = UserProfile(
            id: u['id'].toString(),
            name: u['name'],
            email: u['email'],
            role: u['role'],
            campusId: u['campus_id'] ?? 'N/A',
            stallName: u['stall_name'],
          );
          isLoggedIn.value = true;
          await _saveUserSession();
          return true;
        }
      }
    } catch (_) {}
    return false;
  }

  Future<bool> registerRemote(String name, String email, String password, String role, String campusId, String? stallName) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiBase/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'role': role,
          'campus_id': campusId,
          'stall_name': stallName,
        }),
      ).timeout(const Duration(seconds: 3));

      if (response.statusCode == 201) {
        var data = json.decode(response.body);
        if (data['status'] == 'success') {
          var u = data['user'];
          currentUser.value = UserProfile(
            id: u['id'].toString(),
            name: u['name'],
            email: u['email'],
            role: u['role'],
            campusId: u['campus_id'] ?? 'N/A',
            stallName: u['stall_name'],
          );
          isLoggedIn.value = true;
          await _saveUserSession();
          return true;
        }
      }
    } catch (_) {}
    return false;
  }

  Future<void> _saveUserSession() async {
    if (currentUser.value != null) {
      String jsonStr = json.encode({
        'id': currentUser.value!.id,
        'name': currentUser.value!.name,
        'email': currentUser.value!.email,
        'role': currentUser.value!.role,
        'campusId': currentUser.value!.campusId,
        'stallName': currentUser.value!.stallName,
      });
      await _prefs.setString('current_user', jsonStr);
      await _prefs.setString('name_map_${currentUser.value!.email.toLowerCase()}', currentUser.value!.name);
      if (currentUser.value!.campusId.isNotEmpty) {
        await _prefs.setString('name_map_${currentUser.value!.campusId.toLowerCase()}', currentUser.value!.name);
      }
    }
  }

  void loginAsCustomer({String? name, String? email, String? campusId}) {
    String inputEmail = email ?? 'john.doe@campus.edu';
    String finalName = name ?? _getNameFromEmailOrId(inputEmail);
    if (campusId != null && (finalName == 'Student' || RegExp(r'^\d+$').hasMatch(finalName))) {
      finalName = _getNameFromEmailOrId(campusId);
    }

    currentUser.value = UserProfile(
      id: 'USR001',
      name: finalName,
      email: inputEmail,
      role: 'customer',
      campusId: campusId ?? '2023-10042',
    );
    isLoggedIn.value = true;
    _saveUserSession();
  }

  void loginAsVendor({String? name, String? email, String? campusId, String? stallName}) {
    currentUser.value = UserProfile(
      id: 'USR002',
      name: name ?? 'Chef Maria',
      email: email ?? 'maria.stalls@campus.edu',
      role: 'vendor',
      campusId: campusId ?? 'VND-7782',
      stallName: stallName ?? 'Maria\'s Homestyle Meals',
    );
    isLoggedIn.value = true;
    _saveUserSession();
  }

  void loginAsAdmin({String? name, String? email, String? campusId}) {
    currentUser.value = UserProfile(
      id: 'USR003',
      name: name ?? 'Admin Dave',
      email: email ?? 'admin.dave@campus.edu',
      role: 'admin',
      campusId: campusId ?? 'ADM-0001',
    );
    isLoggedIn.value = true;
    _saveUserSession();
  }

  void logout() {
    currentUser.value = null;
    isLoggedIn.value = false;
    _prefs.remove('current_user');
  }

  void registerUser(String name, String email, String role, String campusId, String? stallName) {
    currentUser.value = UserProfile(
      id: 'USR${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      role: role,
      campusId: campusId,
      stallName: stallName,
    );
    isLoggedIn.value = true;
    _saveUserSession();
  }
}

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;

  double get subtotal => cartItems.fold(0.0, (sum, item) => sum + item.total);
  double get tax => subtotal * 0.05; // 5% VAT
  double get total => subtotal + tax;
  int get itemCount => cartItems.fold(0, (sum, item) => sum + item.quantity);

  void addToCart(FoodItem item, int quantity, String notes) {
    var existingIndex = cartItems.indexWhere((element) => element.foodItem.id == item.id);
    if (existingIndex >= 0) {
      cartItems[existingIndex].quantity += quantity;
      if (notes.isNotEmpty) {
        cartItems[existingIndex].notes = notes;
      }
      cartItems.refresh();
    } else {
      cartItems.add(CartItem(foodItem: item, quantity: quantity, notes: notes));
    }
  }

  void updateQuantity(CartItem item, int newQty) {
    if (newQty <= 0) {
      cartItems.remove(item);
    } else {
      item.quantity = newQty;
      cartItems.refresh();
    }
  }

  void removeFromCart(CartItem item) {
    cartItems.remove(item);
  }

  void clearCart() {
    cartItems.clear();
  }
}

class OrderController extends GetxController {
  var orders = <OrderModel>[].obs;
  var canteens = <CanteenStall>[].obs;
  var menuItems = <FoodItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMockData();
  }

  void loadMockData() {
    canteens.assignAll([
      CanteenStall(
        id: 'STL001',
        name: 'Maria\'s Homestyle Meals',
        description: 'Authentic and affordable Filipino home-cooked meals.',
        imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
        hours: '7:30 AM - 6:00 PM',
        rating: 4.8,
        isApproved: true,
      ),
      CanteenStall(
        id: 'STL002',
        name: 'Wok & Roll Express',
        description: 'Fast, fresh wok dishes and modern Asian street food.',
        imageUrl: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400',
        hours: '8:00 AM - 7:00 PM',
        rating: 4.5,
        isApproved: true,
      ),
      CanteenStall(
        id: 'STL003',
        name: 'The Green Fork',
        description: 'Healthy salads, wraps, fresh pressed juices and fruit cups.',
        imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
        hours: '9:00 AM - 5:00 PM',
        rating: 4.6,
        isApproved: false, // For admin approval demo
      ),
    ]);

    menuItems.assignAll([
      // Maria's Meals
      FoodItem(
        id: 'FD001',
        stallId: 'STL001',
        name: 'Chicken Adobo Rice Meal',
        price: 95.0,
        description: 'Tender chicken marinated in soy sauce, vinegar, and garlic, served with rice.',
        category: 'Meals',
        imageUrl: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=300',
      ),
      FoodItem(
        id: 'FD002',
        stallId: 'STL001',
        name: 'Pork Sinigang Soup',
        price: 110.0,
        description: 'Sour tamarind soup cooked with pork riblets and fresh campus vegetables.',
        category: 'Meals',
        imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300',
      ),
      FoodItem(
        id: 'FD003',
        stallId: 'STL001',
        name: 'Iced Sweet Melon Juice',
        price: 35.0,
        description: 'Freshly shredded melon juice served over crushed ice.',
        category: 'Drinks',
        imageUrl: 'https://images.unsplash.com/photo-1497534446932-c925b458314e?w=300',
      ),
      // Wok & Roll
      FoodItem(
        id: 'FD004',
        stallId: 'STL002',
        name: 'Spicy Beef Fried Noodles',
        price: 120.0,
        description: 'Stir-fried egg noodles with tender beef strips, cabbage, and chili sauce.',
        category: 'Meals',
        imageUrl: 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=300',
      ),
      FoodItem(
        id: 'FD005',
        stallId: 'STL002',
        name: 'Crispy Pork Lumpia (5pcs)',
        price: 50.0,
        description: 'Golden deep-fried spring rolls stuffed with pork and served with sweet chili sauce.',
        category: 'Snacks',
        imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=300',
      ),
      // Green Fork
      FoodItem(
        id: 'FD006',
        stallId: 'STL003',
        name: 'Avocado Chicken Wrap',
        price: 135.0,
        description: 'Grilled chicken breast, avocado slices, greens, and yogurt dressing in a tortilla wrap.',
        category: 'Meals',
        imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=300',
      ),
    ]);

    // Initial mock completed order in history
    orders.add(OrderModel(
      id: 'CFE-88910',
      customerName: 'John Doe',
      stallName: 'Maria\'s Homestyle Meals',
      stallId: 'STL001',
      items: [
        CartItem(foodItem: menuItems[0], quantity: 2),
        CartItem(foodItem: menuItems[2], quantity: 1),
      ],
      total: 225.0,
      status: 'completed',
      pickupTime: '12:30 PM (Completed)',
      paymentMethod: 'GCash',
      qrCode: 'QR_CFE_88910',
      rating: 5.0,
      comment: 'Super delicious and arrived very hot!',
      orderTime: DateTime.now().subtract(const Duration(days: 1)),
    ));
  }

  void placeOrder(List<CartItem> cartItems, double total, String pickupTime, String paymentMethod) {
    String stallId = cartItems.first.foodItem.stallId;
    CanteenStall stall = canteens.firstWhere((element) => element.id == stallId);

    var newOrder = OrderModel(
      id: 'CFE-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      customerName: Get.find<AuthController>().currentUser.value?.name ?? 'Guest',
      stallName: stall.name,
      stallId: stallId,
      items: List.from(cartItems),
      total: total,
      status: 'pending',
      pickupTime: pickupTime,
      paymentMethod: paymentMethod,
      qrCode: 'QR_CFE_${DateTime.now().millisecondsSinceEpoch}',
      orderTime: DateTime.now(),
    );

    orders.insert(0, newOrder);
  }

  void submitRating(OrderModel order, double rating, String comment) {
    order.rating = rating;
    order.comment = comment;
    orders.refresh();
  }
}

class VendorController extends GetxController {
  var totalRevenue = 14520.0.obs;
  var activeOrdersCount = 0.obs;

  void acceptOrder(OrderModel order) {
    order.status = 'preparing';
    Get.find<OrderController>().orders.refresh();
  }

  void markOrderReady(OrderModel order) {
    order.status = 'ready';
    Get.find<OrderController>().orders.refresh();
  }

  void completeOrder(OrderModel order) {
    order.status = 'completed';
    totalRevenue.value += order.total;
    Get.find<OrderController>().orders.refresh();
  }

  void addNewFoodItem(String stallId, String name, double price, String description, String category) {
    var newItem = FoodItem(
      id: 'FD${DateTime.now().millisecondsSinceEpoch}',
      stallId: stallId,
      name: name,
      price: price,
      description: description,
      category: category,
      imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300',
    );
    Get.find<OrderController>().menuItems.add(newItem);
  }
}

class AdminController extends GetxController {
  var totalSales = 35910.0.obs;
  var commissionEarned = 3591.0.obs; // 10% commission rate

  void approveStall(CanteenStall stall) {
    stall.isApproved = true;
    Get.find<OrderController>().canteens.refresh();
  }

  void rejectStall(CanteenStall stall) {
    Get.find<OrderController>().canteens.remove(stall);
  }

  void toggleStallStatus(CanteenStall stall) {
    stall.isApproved = !stall.isApproved;
    Get.find<OrderController>().canteens.refresh();
  }
}
