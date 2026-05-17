class UserProfile {
  final String id;
  final String name;
  final String email;
  final String role; // 'customer', 'vendor', 'admin'
  final String campusId;
  final String? stallName;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.campusId,
    this.stallName,
  });
}

class CanteenStall {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String hours;
  final double rating;
  bool isApproved;

  CanteenStall({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.hours,
    required this.rating,
    this.isApproved = false,
  });
}

class FoodItem {
  final String id;
  final String stallId;
  final String name;
  final double price;
  final String description;
  final String category; // 'Meals', 'Drinks', 'Snacks', 'Desserts'
  final String imageUrl;
  bool isAvailable;

  FoodItem({
    required this.id,
    required this.stallId,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    this.isAvailable = true,
  });
}

class CartItem {
  final FoodItem foodItem;
  int quantity;
  String notes;

  CartItem({
    required this.foodItem,
    required this.quantity,
    this.notes = '',
  });

  double get total => foodItem.price * quantity;
}

class OrderModel {
  final String id;
  final String customerName;
  final String stallName;
  final String stallId;
  final List<CartItem> items;
  final double total;
  String status; // 'pending', 'preparing', 'ready', 'completed'
  final String pickupTime;
  final String paymentMethod;
  final String qrCode;
  double? rating;
  String? comment;
  final DateTime orderTime;

  OrderModel({
    required this.id,
    required this.customerName,
    required this.stallName,
    required this.stallId,
    required this.items,
    required this.total,
    required this.status,
    required this.pickupTime,
    required this.paymentMethod,
    required this.qrCode,
    this.rating,
    this.comment,
    required this.orderTime,
  });
}
