import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class AuthController extends GetxController {
  var currentUser = Rxn<UserProfile>();
  var isLoggedIn = false.obs;
  var authToken = ''.obs;

  static const String _apiBase = "https://foodcampus.onrender.com/api";
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
    authToken.value = _prefs.getString('auth_token') ?? '';
    
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
      '20221270': 'Jhonlord Dagasuan',
      '20221270@campus.edu': 'Jhonlord Dagasuan',
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
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 4));

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
          authToken.value = data['token'] ?? '';
          await _prefs.setString('auth_token', authToken.value);
          isLoggedIn.value = true;
          await _saveUserSession();
          
          // Trigger dynamic database sync
          Get.find<OrderController>().fetchCanteensFromApi();
          Get.find<OrderController>().fetchOrdersFromApi();
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
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'role': role,
          'campus_id': campusId,
          'stall_name': stallName,
        }),
      ).timeout(const Duration(seconds: 4));

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
          authToken.value = data['token'] ?? '';
          await _prefs.setString('auth_token', authToken.value);
          isLoggedIn.value = true;
          await _saveUserSession();
          
          Get.find<OrderController>().fetchCanteensFromApi();
          Get.find<OrderController>().fetchOrdersFromApi();
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
      id: '1', // STL001 corresponding customer ID or general customer ID
      name: finalName,
      email: inputEmail,
      role: 'customer',
      campusId: campusId ?? '2023-10042',
    );
    authToken.value = 'MOCK_TOKEN';
    isLoggedIn.value = true;
    _saveUserSession();
  }

  void loginAsVendor({String? name, String? email, String? campusId, String? stallName}) {
    currentUser.value = UserProfile(
      id: '2', // STL001 corresponding vendor ID
      name: name ?? 'Chef Maria',
      email: email ?? 'maria.stalls@campus.edu',
      role: 'vendor',
      campusId: campusId ?? 'VND-7782',
      stallName: stallName ?? 'Maria\'s Homestyle Meals',
    );
    authToken.value = 'MOCK_TOKEN';
    isLoggedIn.value = true;
    _saveUserSession();
  }

  void loginAsAdmin({String? name, String? email, String? campusId}) {
    currentUser.value = UserProfile(
      id: '3',
      name: name ?? 'Superuser Authority',
      email: email ?? 'admin.dave@campus.edu',
      role: 'admin',
      campusId: campusId ?? 'ADM-0001',
    );
    authToken.value = 'MOCK_TOKEN';
    isLoggedIn.value = true;
    _saveUserSession();
  }

  void logout() {
    currentUser.value = null;
    isLoggedIn.value = false;
    authToken.value = '';
    _prefs.remove('current_user');
    _prefs.remove('auth_token');
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
    authToken.value = 'MOCK_TOKEN';
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

  void addToCart(FoodItem item, int quantity, String notes, [List<String> addOns = const []]) {
    var existingIndex = cartItems.indexWhere((element) {
      if (element.foodItem.id != item.id) return false;
      if (element.addOns.length != addOns.length) return false;
      return element.addOns.every((addon) => addOns.contains(addon));
    });

    if (existingIndex >= 0) {
      cartItems[existingIndex].quantity += quantity;
      if (notes.isNotEmpty) {
        cartItems[existingIndex].notes = notes;
      }
      cartItems.refresh();
    } else {
      cartItems.add(CartItem(foodItem: item, quantity: quantity, notes: notes, addOns: addOns));
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
  var isLoadingOrders = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMockData();
    fetchCanteensFromApi();
    fetchOrdersFromApi();
  }

  void loadMockData() {
    canteens.assignAll([
      CanteenStall(
        id: '1', // Match backend stall auto-increment ID
        name: 'Maria\'s Homestyle Meals',
        description: 'Authentic and affordable Filipino home-cooked meals.',
        imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
        hours: '7:30 AM - 6:00 PM',
        rating: 4.8,
        isApproved: true,
      ),
      CanteenStall(
        id: '2',
        name: 'Wok & Roll Express',
        description: 'Fast, fresh wok dishes and modern Asian street food.',
        imageUrl: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400',
        hours: '8:00 AM - 7:00 PM',
        rating: 4.5,
        isApproved: true,
      ),
      CanteenStall(
        id: '3',
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
        id: '1', // Match backend ID
        stallId: '1',
        name: 'Chicken Adobo Rice Meal',
        price: 95.0,
        description: 'Tender chicken marinated in soy sauce, vinegar, and garlic, served with rice.',
        category: 'Meals',
        imageUrl: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=300',
      ),
      FoodItem(
        id: '2',
        stallId: '1',
        name: 'Pork Sinigang Soup',
        price: 110.0,
        description: 'Sour tamarind soup cooked with pork riblets and fresh campus vegetables.',
        category: 'Meals',
        imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300',
      ),
      FoodItem(
        id: '3',
        stallId: '1',
        name: 'Mango Shake',
        price: 55.0,
        description: 'Freshly blended sweet ripe mangoes with milk and crushed ice.',
        category: 'Drinks',
        imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300',
      ),
      FoodItem(
        id: '7',
        stallId: '1',
        name: 'Bicol Express Rice Meal',
        price: 105.0,
        description: 'Pork strips cooked in coconut milk and spicy chili peppers, served with rice.',
        category: 'Meals',
        imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300',
      ),
      // Wok & Roll
      FoodItem(
        id: '4',
        stallId: '2',
        name: 'Spicy Beef Fried Noodles',
        price: 120.0,
        description: 'Stir-fried egg noodles with tender beef strips, cabbage, and chili sauce.',
        category: 'Meals',
        imageUrl: 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=300',
      ),
      FoodItem(
        id: '5',
        stallId: '2',
        name: 'Crispy Pork Lumpia (5pcs)',
        price: 50.0,
        description: 'Golden deep-fried spring rolls stuffed with pork and served with sweet chili sauce.',
        category: 'Snacks',
        imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=300',
      ),
      // Green Fork
      FoodItem(
        id: '6',
        stallId: '3',
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
      customerName: 'Jhonlord Dagasuan',
      stallName: 'Maria\'s Homestyle Meals',
      stallId: '1',
      items: [
        CartItem(foodItem: menuItems[0], quantity: 2),
        CartItem(foodItem: menuItems[2], quantity: 1),
      ],
      total: 245.0, // 2 * 95 + 55 = 245
      status: 'completed',
      pickupTime: '12:30 PM (Completed)',
      paymentMethod: 'GCash',
      qrCode: 'QR_CFE_88910',
      rating: 5.0,
      comment: 'Super delicious and arrived very hot!',
      orderTime: DateTime.now().subtract(const Duration(days: 1)),
    ));
  }

  Future<void> fetchCanteensFromApi() async {
    try {
      final response = await http.get(
        Uri.parse('${AuthController._apiBase}/canteens'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 'success' && data['canteens'] != null) {
          var rawCanteens = data['canteens'] as List;
          List<CanteenStall> parsedCanteens = [];
          List<FoodItem> parsedMenu = [];
          
          for (var c in rawCanteens) {
            String cId = c['id'].toString();
            parsedCanteens.add(CanteenStall(
              id: cId,
              name: c['name'] ?? 'Stall',
              description: c['description'] ?? '',
              imageUrl: c['image_url'] ?? '',
              hours: c['hours'] ?? '7:30 AM - 6:00 PM',
              rating: double.tryParse(c['rating']?.toString() ?? '5.0') ?? 5.0,
              isApproved: c['is_approved'] == 1 || c['is_approved'] == true,
            ));
            
            // Sync its menu items
            await fetchMenuForCanteen(cId, parsedMenu);
          }
          if (parsedCanteens.isNotEmpty) {
            canteens.assignAll(parsedCanteens);
          }
          if (parsedMenu.isNotEmpty) {
            menuItems.assignAll(parsedMenu);
          }
        }
      }
    } catch (_) {}
  }

  Future<void> fetchMenuForCanteen(String canteenId, List<FoodItem> parsedMenu) async {
    try {
      final response = await http.get(
        Uri.parse('${AuthController._apiBase}/canteens/$canteenId/menu'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 'success' && data['menu'] != null) {
          var rawMenu = data['menu'] as List;
          for (var m in rawMenu) {
            parsedMenu.add(FoodItem(
              id: m['id'].toString(),
              stallId: m['stall_id'].toString(),
              name: m['name'] ?? 'Item',
              price: double.tryParse(m['price']?.toString() ?? '0.0') ?? 0.0,
              description: m['description'] ?? '',
              category: m['category'] ?? 'Meals',
              imageUrl: m['image_url'] ?? '',
              isAvailable: m['is_available'] == 1 || m['is_available'] == true,
            ));
          }
        }
      }
    } catch (_) {}
  }

  Future<void> fetchOrdersFromApi() async {
    final AuthController auth = Get.find<AuthController>();
    if (auth.authToken.value.isEmpty || auth.authToken.value == 'MOCK_TOKEN') {
      return;
    }
    
    isLoadingOrders.value = true;
    try {
      final response = await http.get(
        Uri.parse('${AuthController._apiBase}/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${auth.authToken.value}',
        },
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 'success' && data['orders'] != null) {
          var rawOrders = data['orders'] as List;
          List<OrderModel> parsedOrders = [];
          for (var o in rawOrders) {
            List<CartItem> parsedItems = [];
            if (o['order_items'] != null) {
              for (var oi in o['order_items']) {
                var fi = oi['food_item'];
                if (fi != null) {
                  parsedItems.add(CartItem(
                    foodItem: FoodItem(
                      id: fi['id'].toString(),
                      stallId: fi['stall_id']?.toString() ?? o['stall_id'].toString(),
                      name: fi['name'] ?? 'Unknown',
                      price: double.tryParse(fi['price']?.toString() ?? '0.0') ?? 0.0,
                      description: fi['description'] ?? '',
                      category: fi['category'] ?? 'Meals',
                      imageUrl: fi['image_url'] ?? '',
                      isAvailable: fi['is_available'] == 1 || fi['is_available'] == true,
                    ),
                    quantity: oi['quantity'] ?? 1,
                    notes: oi['notes'] ?? '',
                  ));
                }
              }
            }
            
            parsedOrders.add(OrderModel(
              id: o['id'].toString(),
              customerName: o['customer'] != null ? o['customer']['name'] : 'Student',
              stallName: o['canteen_stall'] != null ? o['canteen_stall']['name'] : (auth.currentUser.value?.stallName ?? 'Stall'),
              stallId: o['stall_id'].toString(),
              items: parsedItems,
              total: double.tryParse(o['total']?.toString() ?? '0.0') ?? 0.0,
              status: o['status'] ?? 'pending',
              pickupTime: o['pickup_time'] ?? 'ASAP',
              paymentMethod: o['payment_method'] ?? 'GCash',
              qrCode: o['qr_code'] ?? 'QR_CFE_${o['id']}',
              rating: double.tryParse(o['rating']?.toString() ?? ''),
              comment: o['comment'],
              orderTime: DateTime.tryParse(o['created_at'] ?? '') ?? DateTime.now(),
            ));
          }
          orders.assignAll(parsedOrders);
        }
      }
    } catch (_) {} finally {
      isLoadingOrders.value = false;
    }
  }

  Future<void> placeOrderRemote(List<CartItem> cartItems, String pickupTime, String paymentMethod) async {
    final AuthController auth = Get.find<AuthController>();
    if (auth.authToken.value.isEmpty || auth.authToken.value == 'MOCK_TOKEN') {
      return;
    }
    
    try {
      String stallId = cartItems.first.foodItem.stallId;
      var payload = {
        'stall_id': int.tryParse(stallId) ?? 1,
        'pickup_time': pickupTime,
        'payment_method': paymentMethod,
        'items': cartItems.map((i) => {
          'food_item_id': int.tryParse(i.foodItem.id) ?? 1,
          'quantity': i.quantity,
          'notes': i.notes,
        }).toList(),
      };

      await http.post(
        Uri.parse('${AuthController._apiBase}/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${auth.authToken.value}',
        },
        body: json.encode(payload),
      ).timeout(const Duration(seconds: 4));
    } catch (_) {}
  }

  void placeOrder(List<CartItem> cartItems, double total, String pickupTime, String paymentMethod) async {
    String stallId = cartItems.first.foodItem.stallId;
    CanteenStall stall = canteens.firstWhere(
      (element) => element.id == stallId,
      orElse: () => CanteenStall(id: stallId, name: 'My Stall', description: '', imageUrl: '', hours: '', rating: 5.0),
    );

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
    
    await placeOrderRemote(cartItems, pickupTime, paymentMethod);
    await fetchOrdersFromApi();
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

  Future<void> updateOrderStatusOnApi(String orderId, String status) async {
    final AuthController auth = Get.find<AuthController>();
    if (auth.authToken.value.isEmpty || auth.authToken.value == 'MOCK_TOKEN') {
      return;
    }
    try {
      await http.post(
        Uri.parse('${AuthController._apiBase}/orders/$orderId/status'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${auth.authToken.value}',
        },
        body: json.encode({'status': status}),
      ).timeout(const Duration(seconds: 3));
    } catch (_) {}
  }

  void acceptOrder(OrderModel order) async {
    order.status = 'preparing';
    Get.find<OrderController>().orders.refresh();
    await updateOrderStatusOnApi(order.id, 'preparing');
    await Get.find<OrderController>().fetchOrdersFromApi();
  }

  void markOrderReady(OrderModel order) async {
    order.status = 'ready';
    Get.find<OrderController>().orders.refresh();
    await updateOrderStatusOnApi(order.id, 'ready');
    await Get.find<OrderController>().fetchOrdersFromApi();
  }

  void completeOrder(OrderModel order) async {
    order.status = 'completed';
    totalRevenue.value += order.total;
    Get.find<OrderController>().orders.refresh();
    await updateOrderStatusOnApi(order.id, 'completed');
    await Get.find<OrderController>().fetchOrdersFromApi();
  }

  Future<void> addNewFoodItemRemote(String name, double price, String description, String category, String? imageUrl) async {
    final AuthController auth = Get.find<AuthController>();
    if (auth.authToken.value.isEmpty || auth.authToken.value == 'MOCK_TOKEN') {
      return;
    }
    try {
      await http.post(
        Uri.parse('${AuthController._apiBase}/menu/add'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${auth.authToken.value}',
        },
        body: json.encode({
          'name': name,
          'price': price,
          'description': description,
          'category': category,
          'image_url': imageUrl,
        }),
      ).timeout(const Duration(seconds: 3));
    } catch (_) {}
  }

  void addNewFoodItem(String stallId, String name, double price, String description, String category, {String? imageUrl}) async {
    var newItem = FoodItem(
      id: 'FD${DateTime.now().millisecondsSinceEpoch}',
      stallId: stallId,
      name: name,
      price: price,
      description: description,
      category: category,
      imageUrl: imageUrl != null && imageUrl.trim().isNotEmpty
          ? imageUrl
          : 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300',
    );
    Get.find<OrderController>().menuItems.add(newItem);
    
    await addNewFoodItemRemote(name, price, description, category, imageUrl);
    await Get.find<OrderController>().fetchCanteensFromApi();
  }

  Future<void> toggleAvailabilityRemote(String foodId) async {
    final AuthController auth = Get.find<AuthController>();
    if (auth.authToken.value.isEmpty || auth.authToken.value == 'MOCK_TOKEN') {
      return;
    }
    try {
      await http.post(
        Uri.parse('${AuthController._apiBase}/menu/$foodId/toggle-availability'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${auth.authToken.value}',
        },
      ).timeout(const Duration(seconds: 3));
    } catch (_) {}
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
