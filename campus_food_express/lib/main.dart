import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'models/models.dart';
import 'controllers/controllers.dart';

// Custom AppColors to support our premium Emerald theme
class AppColors {
  static const Color emerald = Color(0xFF10B981); // Vibrant organic green from Figma design
  static const Color background = Color(0xFFF5F6F6); // Soft off-white clean background
  static const Color textPrimary = Color(0xFF0D121B); // Deep blue-black font
  static const Color textSecondary = Color(0xFF7D8B9B); // Slate-gray secondary font
}

void main() {
  // Initialize GetX Controllers
  Get.put(AuthController());
  Get.put(CartController());
  Get.put(OrderController());
  Get.put(VendorController());
  Get.put(AdminController());

  runApp(const CampusFoodExpressApp());
}

class CampusFoodExpressApp extends StatelessWidget {
  const CampusFoodExpressApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Campus Food Express',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.emerald,
          primary: AppColors.emerald,
          secondary: const Color(0xFF6366F1), // Indigo
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.emerald, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const WelcomeLoginScreen(),
    );
  }
}

// ==========================================
// 1. WELCOME & LOGIN SCREEN (3 ROLES DEMO)
// ==========================================
class WelcomeLoginScreen extends StatefulWidget {
  const WelcomeLoginScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeLoginScreen> createState() => _WelcomeLoginScreenState();
}

class _WelcomeLoginScreenState extends State<WelcomeLoginScreen> {
  final AuthController authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _campusIdController = TextEditingController();
  final _stallNameController = TextEditingController();

  bool isRegistering = false;
  String selectedRole = 'customer';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Foodeli-style Header
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.emerald.withOpacity(0.08),
                                  spreadRadius: 8,
                                  blurRadius: 24,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.local_dining_rounded,
                              size: 56,
                              color: AppColors.emerald,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Foodeli',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                              letterSpacing: -1.0,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Premium Campus Food & Fast Delivery',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Credentials & Form Card
                    Container(
                      padding: const EdgeInsets.all(28.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              isRegistering ? 'Create Account' : 'Sign In',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isRegistering
                                  ? 'Join the premium food delivery community'
                                  : 'Welcome back! Please enter your details',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 28),

                            // Form Fields
                            if (isRegistering) ...[
                              TextFormField(
                                controller: _nameController,
                                style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                decoration: InputDecoration(
                                  labelText: 'Full Name',
                                  labelStyle: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                                  prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.textSecondary),
                                  filled: true,
                                  fillColor: AppColors.background,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                ),
                                validator: (v) => v!.isEmpty ? 'Name is required' : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _campusIdController,
                                style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                decoration: InputDecoration(
                                  labelText: 'Campus ID / Staff ID',
                                  labelStyle: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                                  prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.textSecondary),
                                  filled: true,
                                  fillColor: AppColors.background,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                ),
                                validator: (v) => v!.isEmpty ? 'Campus ID is required' : null,
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Role Selector Dropdown
                            DropdownButtonFormField<String>(
                              value: selectedRole,
                              dropdownColor: Colors.white,
                              style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              decoration: InputDecoration(
                                labelText: isRegistering ? 'Register as...' : 'Sign in as...',
                                labelStyle: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                                prefixIcon: const Icon(Icons.supervised_user_circle_outlined, color: AppColors.textSecondary),
                                filled: true,
                                fillColor: AppColors.background,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'customer', child: Text('Customer / Student')),
                                DropdownMenuItem(value: 'vendor', child: Text('Vendor / Canteen Stall')),
                                DropdownMenuItem(value: 'admin', child: Text('Admin / Platform Manager')),
                              ],
                              onChanged: (val) {
                                setState(() {
                                  selectedRole = val!;
                                });
                              },
                            ),
                            const SizedBox(height: 16),

                            if (isRegistering && selectedRole == 'vendor') ...[
                              TextFormField(
                                controller: _stallNameController,
                                style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                decoration: InputDecoration(
                                  labelText: 'Stall / Canteen Name',
                                  labelStyle: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                                  prefixIcon: const Icon(Icons.storefront_outlined, color: AppColors.textSecondary),
                                  filled: true,
                                  fillColor: AppColors.background,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                ),
                                validator: (v) => v!.isEmpty ? 'Stall name is required' : null,
                              ),
                              const SizedBox(height: 16),
                            ],

                            TextFormField(
                              controller: _emailController,
                              style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              decoration: InputDecoration(
                                  labelText: 'Campus Email',
                                  labelStyle: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary),
                                  filled: true,
                                  fillColor: AppColors.background,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                              ),
                              validator: (v) => v!.isEmpty ? 'Email is required' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                                prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.textSecondary),
                                filled: true,
                                fillColor: AppColors.background,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                              ),
                              validator: (v) => v!.isEmpty ? 'Password is required' : null,
                            ),
                            const SizedBox(height: 28),

                            // Action Button
                            SizedBox(
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    Future.delayed(const Duration(milliseconds: 1100), () {
                                      if (isRegistering) {
                                        authController.registerUser(
                                          _nameController.text,
                                          _emailController.text,
                                          selectedRole,
                                          _campusIdController.text,
                                          selectedRole == 'vendor' ? _stallNameController.text : null,
                                        );
                                        if (selectedRole == 'admin') {
                                          Get.offAll(() => const AdminMainScreen(), transition: Transition.fadeIn, duration: const Duration(milliseconds: 600));
                                        } else if (selectedRole == 'vendor') {
                                          Get.offAll(() => const VendorMainScreen(), transition: Transition.fadeIn, duration: const Duration(milliseconds: 600));
                                        } else {
                                          Get.offAll(() => const CustomerMainScreen(), transition: Transition.fadeIn, duration: const Duration(milliseconds: 600));
                                        }
                                      } else {
                                        if (selectedRole == 'admin') {
                                          authController.loginAsAdmin(
                                            name: 'Admin Dave',
                                            email: _emailController.text.trim(),
                                          );
                                          Get.offAll(() => const AdminMainScreen(), transition: Transition.fadeIn, duration: const Duration(milliseconds: 600));
                                        } else if (selectedRole == 'vendor') {
                                          authController.loginAsVendor(
                                            name: 'Chef Maria',
                                            email: _emailController.text.trim(),
                                          );
                                          Get.offAll(() => const VendorMainScreen(), transition: Transition.fadeIn, duration: const Duration(milliseconds: 600));
                                        } else {
                                          String email = _emailController.text.trim();
                                          authController.loginAsCustomer(
                                            email: email,
                                            campusId: email,
                                          );
                                          Get.offAll(() => const CustomerMainScreen(), transition: Transition.fadeIn, duration: const Duration(milliseconds: 600));
                                        }
                                      }
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.emerald,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                  elevation: 0,
                                ),
                                child: Text(
                                  isRegistering ? 'Sign Up' : 'Sign In',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            Center(
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    isRegistering = !isRegistering;
                                  });
                                },
                                child: Text(
                                  isRegistering
                                      ? 'Already have an account? Sign In'
                                      : 'New to Foodeli? Create Account',
                                  style: const TextStyle(
                                    color: AppColors.emerald,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.emerald.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const SizedBox(
                        width: 56,
                        height: 56,
                        child: CircularProgressIndicator(
                          strokeWidth: 4.5,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.emerald),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Preparing your dashboard...',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Sleek experience loading in a snap',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ==========================================
// 2. CUSTOMER WORKFLOW EXPERIENCE (FOODELI NAVBAR)
// ==========================================
class CustomerMainScreen extends StatefulWidget {
  const CustomerMainScreen({Key? key}) : super(key: key);

  @override
  State<CustomerMainScreen> createState() => _CustomerMainScreenState();
}

class _CustomerMainScreenState extends State<CustomerMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const CustomerHomeScreen(),
    const CustomerCartScreen(),
    const CustomerActiveOrderScreen(),
    const CustomerHistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _screens[_currentIndex],
      bottomNavigationBar: FoodeliBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class FoodeliBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const FoodeliBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    final List<Map<String, dynamic>> navItems = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.shopping_cart_rounded, 'label': 'Cart', 'badge': true},
      {'icon': Icons.local_shipping_rounded, 'label': 'Track'},
      {'icon': Icons.history_rounded, 'label': 'History'},
    ];

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(navItems.length, (index) {
          bool isActive = currentIndex == index;
          var item = navItems[index];

          Widget iconWidget = Icon(
            item['icon'],
            color: isActive ? Colors.white : AppColors.textSecondary,
            size: 22,
          );

          if (item['badge'] == true) {
            iconWidget = Obx(() => Badge(
              label: Text('${cartController.itemCount}'),
              isLabelVisible: cartController.itemCount > 0,
              child: Icon(
                item['icon'],
                color: isActive ? Colors.white : AppColors.textSecondary,
                size: 22,
              ),
            ));
          }

          return InkWell(
            onTap: () => onTap(index),
            borderRadius: BorderRadius.circular(28),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isActive ? AppColors.emerald : Colors.transparent,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                children: [
                  iconWidget,
                  if (isActive) ...[
                    const SizedBox(width: 8),
                    Text(
                      item['label'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class NavigationRequestDestination extends NavigationDestination {
  const NavigationRequestDestination({
    Key? key,
    required Widget icon,
    required Widget selectedIcon,
    required String label,
  }) : super(
          key: key,
          icon: icon,
          selectedIcon: selectedIcon,
          label: label,
        );
}

// 2a. CUSTOMER HOME (BROWSE CANTEENS - FIGMA PREMIUM LAYOUT)
class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({Key? key}) : super(key: key);

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  String selectedCategory = 'Meals';

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find<OrderController>();
    final AuthController authController = Get.find<AuthController>();

    // Jhonford's Figma Category List (No icons, pure text pills)
    final List<String> categories = ['Meals', 'Drinks', 'Desserts', 'Snacks'];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Jhonford's Figma Slate Header Banner (Option B: Midnight Navy Gradient)
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 20,
                right: 20,
                bottom: 24,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0F172A),
                    Color(0xFF1E293B),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good morning,',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            authController.currentUser.value?.name ?? 'Jhonford!',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // Bell Notification with Dot
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 22),
                                  onPressed: () {},
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF10B981),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          // User Circular Initial Avatar
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: const Color(0xFF10B981),
                            child: Text(
                              (authController.currentUser.value?.name ?? 'J').substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Search Bar Input
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.search_rounded, color: Colors.white.withOpacity(0.4), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            decoration: InputDecoration(
                              hintText: 'Search for meals, cafes...',
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 13,
                              ),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Premium Promo Banner Card with overlapping Salad Bowl
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFFEAB308)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Campus Lunch\nSpecials',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Campus Lunch Specials: 20% OFF ALL BOWLS! - Chef Maria\'s',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 18),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF10B981),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                            ),
                            child: const Text(
                              'VIEW OFFERS',
                              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 4,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage('https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=300'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Horizontal Scrolling Categories Selector
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (context, i) {
                  String catName = categories[i];
                  bool isSel = selectedCategory == catName;

                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedCategory = catName;
                        });
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSel ? const Color(0xFF10B981) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            catName,
                            style: TextStyle(
                              color: isSel ? Colors.white : const Color(0xFF475569),
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Featured Campus Stalls Heading
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Featured Campus Stalls',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Premium Landscape Stall Cards List
            Obx(() {
              var approvedStalls = orderController.canteens.where((c) => c.isApproved).toList();
              if (approvedStalls.isEmpty) {
                return const Center(child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text('No campus canteens currently open.'),
                ));
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: approvedStalls.length,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (context, idx) {
                  var stall = approvedStalls[idx];

                  // Setup display details mimicking Jhonford's Figma Screenshot
                  String subtitleText = stall.name.contains('Maria') 
                      ? 'Campus Center • Western' 
                      : 'University Plaza • Fast Food';
                  String ratingText = '${stall.rating} (1.2k+ Reviews)';
                  String deliveryText = '\$\$, Fast Delivery (15-20 mins)';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9), // Light gray background container
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        // Left: Square rounded Food Stall photo
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            stall.imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Center: Canteen details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stall.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF131D24),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                subtitleText,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                                  const SizedBox(width: 3),
                                  Text(
                                    ratingText,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF131D24),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                deliveryText,
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Right: Order Now button
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => Get.to(() => CustomerMenuScreen(stall: stall)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          ),
                          child: const Text(
                            'Order Now',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// 2b. CUSTOMER STALL MENU SCREEN
class CustomerMenuScreen extends StatefulWidget {
  final CanteenStall stall;
  const CustomerMenuScreen({Key? key, required this.stall}) : super(key: key);

  @override
  State<CustomerMenuScreen> createState() => _CustomerMenuScreenState();
}

class _CustomerMenuScreenState extends State<CustomerMenuScreen> {
  final OrderController orderController = Get.find<OrderController>();
  final CartController cartController = Get.find<CartController>();
  String selectedCategory = 'All';
  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<String> categories = ['All', 'Meals', 'Drinks', 'Snacks'];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // 1. Sleek Hero Image Header (Foodeli Style)
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36)),
                child: Image.network(
                  widget.stall.imageUrl,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36)),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.15),
                        Colors.black.withOpacity(0.7),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              // Floating Buttons
              Positioned(
                top: 48,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 18),
                        onPressed: () => Get.back(),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.favorite_rounded, color: Colors.redAccent, size: 18),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              // Stall Details overlay at the bottom of the hero
              Positioned(
                bottom: 24,
                left: 24,
                right: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.stall.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.stall.rating}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.stall.hours,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 2. Compact Search in Menu
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: TextField(
              controller: searchController,
              onChanged: (val) {
                setState(() {
                  searchQuery = val.trim().toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search delicious dishes...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 3. Compact Categories Selector Row
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                var cat = categories[index];
                bool isSelected = selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedCategory = cat;
                      });
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.emerald : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          cat,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // 4. Menu Items list
          Expanded(
            child: Obx(
              () {
                var items = orderController.menuItems
                    .where((item) => item.stallId == widget.stall.id)
                    .where((item) => selectedCategory == 'All' || item.category == selectedCategory)
                    .where((item) => searchQuery.isEmpty || item.name.toLowerCase().contains(searchQuery))
                    .toList();

                if (items.isEmpty) {
                  return const Center(child: Text('No menu items in this category.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    var food = items[index];
                    bool isAvailable = food.isAvailable;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.01),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Opacity(
                        opacity: isAvailable ? 1.0 : 0.6,
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      food.imageUrl,
                                      height: 84,
                                      width: 84,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  if (!isAvailable)
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.45),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'SOLD OUT',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            food.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 15,
                                              color: AppColors.textPrimary,
                                              letterSpacing: -0.3,
                                            ),
                                          ),
                                        ),
                                        if (!isAvailable)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.red.shade50,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              'Sold Out',
                                              style: TextStyle(
                                                color: Colors.red.shade800,
                                                fontSize: 9,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      food.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 11,
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '₱${food.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.emerald,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Dribbble Green Rounded Circular Add Button (Disabled if Sold Out)
                              if (isAvailable)
                                InkWell(
                                  onTap: () {
                                    _showAddToCartSheet(context, food);
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                      color: AppColors.emerald,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.add_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.block_rounded,
                                    color: Colors.grey.shade400,
                                    size: 20,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddToCartSheet(BuildContext context, FoodItem food) {
    int qty = 1;
    final notesController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          food.imageUrl,
                          height: 90,
                          width: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              food.name,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '₱${food.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.emerald,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Quantity Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Quantity',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Row(
                        children: [
                          IconButton.outlined(
                            onPressed: () {
                              if (qty > 1) {
                                setModalState(() => qty--);
                              }
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              '$qty',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton.outlined(
                            onPressed: () {
                              setModalState(() => qty++);
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Notes Text field
                  const Text(
                    'Special Instructions (Optional)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: notesController,
                    decoration: InputDecoration(
                      hintText: 'e.g. Less spicy, extra sauce, no onions',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        cartController.addToCart(food, qty, notesController.text);
                        Get.back();
                        Get.snackbar(
                          'Success',
                          'Added ${food.name} to cart!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.emerald,
                          colorText: Colors.white,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emerald,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Add to Cart', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// 2c. CUSTOMER CART & CHECKOUT
class CustomerCartScreen extends StatefulWidget {
  const CustomerCartScreen({Key? key}) : super(key: key);

  @override
  State<CustomerCartScreen> createState() => _CustomerCartScreenState();
}

class _CustomerCartScreenState extends State<CustomerCartScreen> {
  final CartController cartController = Get.find<CartController>();
  final OrderController orderController = Get.find<OrderController>();

  String selectedPickupTime = 'ASAP';
  String selectedPaymentMethod = 'GCash';

  @override
  Widget build(BuildContext context) {
    List<String> pickupTimes = ['ASAP', '12:00 PM', '12:30 PM', '1:00 PM', '1:30 PM'];
    List<String> paymentMethods = ['GCash', 'Card Payment', 'Campus Wallet'];

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('My Cart', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Obx(
        () {
          if (cartController.cartItems.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Your cart is empty!', style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Items List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartController.cartItems.length,
                  itemBuilder: (context, index) {
                    var item = cartController.cartItems[index];
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                item.foodItem.imageUrl,
                                height: 70,
                                width: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.foodItem.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  if (item.notes.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      'Notes: ${item.notes}',
                                      style: const TextStyle(color: Colors.blueAccent, fontSize: 11),
                                    ),
                                  ],
                                  const SizedBox(height: 6),
                                  Text(
                                    '₱${item.foodItem.price.toStringAsFixed(2)}',
                                    style: const TextStyle(color: AppColors.emerald, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
                                  onPressed: () {
                                    cartController.updateQuantity(item, item.quantity - 1);
                                  },
                                ),
                                Text(
                                  '${item.quantity}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, color: AppColors.emerald),
                                  onPressed: () {
                                    cartController.updateQuantity(item, item.quantity + 1);
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Checkout Sheet
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Pickup Time Picker
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Pickup Time:', style: TextStyle(fontWeight: FontWeight.bold)),
                        DropdownButton<String>(
                          value: selectedPickupTime,
                          items: pickupTimes.map((time) {
                            return DropdownMenuItem(value: time, child: Text(time));
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedPickupTime = val!;
                            });
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Payment Method Picker
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Payment Method:', style: TextStyle(fontWeight: FontWeight.bold)),
                        DropdownButton<String>(
                          value: selectedPaymentMethod,
                          items: paymentMethods.map((method) {
                            return DropdownMenuItem(value: method, child: Text(method));
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedPaymentMethod = val!;
                            });
                          },
                        )
                      ],
                    ),
                    const Divider(height: 24),

                    // Totals
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal'),
                        Text('₱${cartController.subtotal.toStringAsFixed(2)}'),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('VAT (5%)'),
                        Text('₱${cartController.tax.toStringAsFixed(2)}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(
                          '₱${cartController.total.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.emerald),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Checkout Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          // Open Mock Payment screen
                          Get.to(() => MockPaymentGatewayScreen(
                                amount: cartController.total,
                                paymentMethod: selectedPaymentMethod,
                                onPaymentSuccess: () {
                                  // Submit order
                                  orderController.placeOrder(
                                    cartController.cartItems,
                                    cartController.total,
                                    selectedPickupTime,
                                    selectedPaymentMethod,
                                  );
                                  cartController.clearCart();
                                  Get.back(); // Pop payment screen
                                  Get.snackbar(
                                    'Order Confirmed!',
                                    'Check the Track tab for status.',
                                    backgroundColor: AppColors.emerald,
                                    colorText: Colors.white,
                                  );
                                },
                              ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.emerald,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Proceed to Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

// 2d. MOCK PAYMENT GATEWAY GATEWAY
class MockPaymentGatewayScreen extends StatelessWidget {
  final double amount;
  final String paymentMethod;
  final VoidCallback onPaymentSuccess;

  const MockPaymentGatewayScreen({
    Key? key,
    required this.amount,
    required this.paymentMethod,
    required this.onPaymentSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('$paymentMethod Gateway'),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  paymentMethod == 'GCash'
                      ? Icons.account_balance_wallet_rounded
                      : Icons.credit_card_rounded,
                  size: 64,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Review Transaction',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Paying to Campus Food Express',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              Text(
                '₱${amount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 32),

              // Mock inputs
              TextField(
                decoration: InputDecoration(
                  labelText: paymentMethod == 'GCash' ? 'GCash Mobile Number' : 'Card Number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.phone_iphone_rounded),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: onPaymentSuccess,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Authorize Payment', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// 2e. CUSTOMER ORDER TRACKING (LIVE STATUS)
class CustomerActiveOrderScreen extends StatelessWidget {
  const CustomerActiveOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find<OrderController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Active Order Status', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Obx(
        () {
          var activeOrders = orderController.orders.where((o) => o.status != 'completed').toList();

          if (activeOrders.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_shipping_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No active orders right now.', style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            );
          }

          var order = activeOrders.first; // Track the most recent active order

          // Helper logic for status progress
          int statusProgress = 1;
          if (order.status == 'preparing') statusProgress = 2;
          if (order.status == 'ready') statusProgress = 3;

          return ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              // Main Ticket Header
              Card(
                color: Colors.white,
                elevation: 4,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ORDER ID: ${order.id}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                order.stallName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                          Chip(
                            label: Text(
                              order.status.toUpperCase(),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                            backgroundColor: order.status == 'pending'
                                ? Colors.amber.shade100
                                : order.status == 'preparing'
                                    ? Colors.blue.shade100
                                    : Colors.green.shade100,
                          )
                        ],
                      ),
                      const Divider(height: 32),

                      // Elegant status trackers
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatusStep('Placed', true, statusProgress >= 1),
                          _buildStatusStep('Preparing', statusProgress >= 2, statusProgress >= 2),
                          _buildStatusStep('Ready', statusProgress >= 3, statusProgress >= 3),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // QR Code Container for pick up verification
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Present QR Code at Canteen to pickup:',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                            ),
                            const SizedBox(height: 12),
                            // Simulated QR Code Graphic
                            Container(
                              padding: const EdgeInsets.all(12),
                              color: Colors.white,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.qr_code_2_rounded, size: 140, color: Colors.grey.shade800),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Pickup Code: ${order.id.substring(4)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Items details
              const Text(
                'Order Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ...order.items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${item.quantity}x ${item.foodItem.name}'),
                              Text('₱${item.total.toStringAsFixed(2)}'),
                            ],
                          ),
                        );
                      }).toList(),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Amount Paid', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            '₱${order.total.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.emerald, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusStep(String label, bool isDone, bool isActive) {
    return Column(
      children: [
        Icon(
          isDone ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isDone
              ? AppColors.emerald
              : isActive
                  ? Colors.amber
                  : Colors.grey,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isDone || isActive ? FontWeight.bold : FontWeight.normal,
            color: isDone
                ? AppColors.emerald
                : isActive
                    ? Colors.amber.shade800
                    : Colors.grey,
          ),
        ),
      ],
    );
  }
}

// 2f. CUSTOMER ORDER HISTORY & REVIEWS
class CustomerHistoryScreen extends StatelessWidget {
  const CustomerHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find<OrderController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Order History', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Obx(
        () {
          var completedOrders = orderController.orders.where((o) => o.status == 'completed').toList();

          if (completedOrders.isEmpty) {
            return const Center(child: Text('No orders completed yet.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: completedOrders.length,
            itemBuilder: (context, index) {
              var order = completedOrders[index];
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.stallName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                'Order ${order.id}',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          Text(
                            '₱${order.total.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.emerald),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        order.items.map((i) => '${i.quantity}x ${i.foodItem.name}').join(', '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      const Divider(height: 24),

                      // Rating widget
                      if (order.rating != null) ...[
                        Row(
                          children: [
                            const Text('Your Rating: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 4),
                            ...List.generate(5, (starIndex) {
                              return Icon(
                                Icons.star_rounded,
                                color: starIndex < order.rating!.toInt() ? Colors.amber : Colors.grey.shade300,
                                size: 18,
                              );
                            }),
                          ],
                        ),
                        if (order.comment != null && order.comment!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            '"${order.comment}"',
                            style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
                          ),
                        ]
                      ] else ...[
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _showRatingDialog(context, order);
                            },
                            icon: const Icon(Icons.star_outline_rounded, color: Colors.amber),
                            label: const Text('Rate & Review Order', style: TextStyle(color: Colors.amber)),
                          ),
                        )
                      ]
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showRatingDialog(BuildContext context, OrderModel order) {
    double selectedRating = 5;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('Rate & Review', style: TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('How was your dining experience from this stall?'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          Icons.star_rounded,
                          color: index < selectedRating ? Colors.amber : Colors.grey.shade300,
                          size: 36,
                        ),
                        onPressed: () {
                          setModalState(() {
                            selectedRating = index + 1.0;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'Share your feedback about the food quality & packaging',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.find<OrderController>().submitRating(order, selectedRating, commentController.text);
                    Get.back();
                    Get.snackbar(
                      'Thank You!',
                      'Your review has been successfully submitted.',
                      backgroundColor: AppColors.emerald,
                      colorText: Colors.white,
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.emerald, foregroundColor: Colors.white),
                  child: const Text('Submit'),
                )
              ],
            );
          },
        );
      },
    );
  }
}

// ==========================================
// 3. VENDOR WORKFLOW EXPERIENCE
// ==========================================
class VendorMainScreen extends StatefulWidget {
  const VendorMainScreen({Key? key}) : super(key: key);

  @override
  State<VendorMainScreen> createState() => _VendorMainScreenState();
}

class _VendorMainScreenState extends State<VendorMainScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    final List<Widget> vendorScreens = [
      const VendorOrdersTab(),
      const VendorMenuTab(),
      const VendorAnalyticsTab(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          if (_tabIndex != 1) ...[
            // Premium Midnight Navy Gradient Header (Option B Matching)
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                left: 20,
                right: 20,
                bottom: 22,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                    ),
                    child: const Icon(
                      Icons.storefront_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => Text(
                          authController.currentUser.value?.stallName ?? "My Canteen Stall",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            letterSpacing: -0.5,
                          ),
                        )),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withOpacity(0.18),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF10B981),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'ONLINE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 9,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'STL001',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      authController.logout();
                      Get.offAll(() => const WelcomeLoginScreen());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.15)),
                      ),
                      child: const Icon(
                        Icons.logout_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          Expanded(
            child: vendorScreens[_tabIndex],
          ),
        ],
      ),
      bottomNavigationBar: VendorBottomNavBar(
        currentIndex: _tabIndex,
        onTap: (index) {
          setState(() {
            _tabIndex = index;
          });
        },
      ),
    );
  }
}

class VendorBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const VendorBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> navItems = [
      {'icon': Icons.receipt_long_rounded, 'label': 'Orders'},
      {'icon': Icons.restaurant_menu_rounded, 'label': 'Menu'},
      {'icon': Icons.bar_chart_rounded, 'label': 'Analytics'},
    ];

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(navItems.length, (index) {
          bool isActive = currentIndex == index;
          var item = navItems[index];

          return InkWell(
            onTap: () => onTap(index),
            borderRadius: BorderRadius.circular(28),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF6366F1) : Colors.transparent,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                children: [
                  Icon(
                    item['icon'],
                    color: isActive ? Colors.white : AppColors.textSecondary,
                    size: 22,
                  ),
                  if (isActive) ...[
                    const SizedBox(width: 8),
                    Text(
                      item['label'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// 3a. VENDOR TAB: ORDERS FULFILLMENT MANAGER
class VendorOrdersTab extends StatelessWidget {
  const VendorOrdersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find<OrderController>();

    return Obx(
      () {
        var myStallOrders = orderController.orders.where((o) => o.stallId == 'STL001').toList();

        if (myStallOrders.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      size: 48,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No orders found',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Your canteen stall has no registered transactions in the log.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return DefaultTabController(
          length: 4,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: const TabBar(
                  indicatorColor: Color(0xFF6366F1),
                  labelColor: Color(0xFF6366F1),
                  unselectedLabelColor: AppColors.textSecondary,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  tabs: [
                    Tab(text: 'Pending'),
                    Tab(text: 'Preparing'),
                    Tab(text: 'Ready'),
                    Tab(text: 'History'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildOrderListView(myStallOrders.where((o) => o.status == 'pending').toList(), 'pending'),
                    _buildOrderListView(myStallOrders.where((o) => o.status == 'preparing').toList(), 'preparing'),
                    _buildOrderListView(myStallOrders.where((o) => o.status == 'ready').toList(), 'ready'),
                    _buildOrderListView(myStallOrders.where((o) => o.status == 'completed').toList(), 'completed'),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrderListView(List<OrderModel> list, String listType) {
    final VendorController vendorController = Get.find<VendorController>();

    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  size: 48,
                  color: Color(0xFF6366F1),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'No ${listType.toUpperCase()} orders yet',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'New orders placed by students will stream live onto this dashboard in real-time.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        var order = list[index];
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Order: ${order.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      '₱${order.total.toStringAsFixed(2)}',
                      style: const TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Text('Customer: ${order.customerName}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text('Pickup Scheduled: ${order.pickupTime}', style: const TextStyle(color: Colors.blue, fontSize: 12)),
                const Divider(),
                ...order.items.map((i) => Text('${i.quantity}x ${i.foodItem.name}')).toList(),
                const SizedBox(height: 16),

                // Dynamic buttons based on status
                if (order.status == 'pending') ...[
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        vendorController.acceptOrder(order);
                        Get.snackbar('Accepted!', 'Order status changed to Preparing.',
                            backgroundColor: const Color(0xFF6366F1), colorText: Colors.white);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Accept Order & Start Cooking'),
                    ),
                  )
                ] else if (order.status == 'preparing') ...[
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        vendorController.markOrderReady(order);
                        Get.snackbar('Ready!', 'Notification sent to customer to collect.',
                            backgroundColor: Colors.green, colorText: Colors.white);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Mark Order as Ready'),
                    ),
                  )
                ] else if (order.status == 'ready') ...[
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showHandoffConfirmation(context, order);
                      },
                      icon: const Icon(Icons.qr_code_scanner_rounded),
                      label: const Text('Scan QR / Confirm Handoff'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emerald,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  )
                ] else ...[
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 16),
                      const SizedBox(width: 4),
                      const Text('Collected & Completed Successfully', style: TextStyle(color: Colors.green)),
                    ],
                  )
                ]
              ],
            ),
          ),
        );
      },
    );
  }

  void _showHandoffConfirmation(BuildContext context, OrderModel order) {
    final VendorController vendorController = Get.find<VendorController>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Confirm Handoff', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline_rounded, size: 64, color: AppColors.emerald),
              const SizedBox(height: 16),
              Text(
                'Are you handing over order ${order.id} to ${order.customerName}?',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'This will debit payments and complete the platform transaction.',
                style: TextStyle(fontSize: 11, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                vendorController.completeOrder(order);
                Get.back();
                Get.snackbar('Completed!', 'Order has been successfully delivered and payment captured!',
                    backgroundColor: AppColors.emerald, colorText: Colors.white);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.emerald, foregroundColor: Colors.white),
              child: const Text('Confirm & Complete'),
            )
          ],
        );
      },
    );
  }
}

// 3b. VENDOR TAB: STALL MENU MANAGER
// 3b. VENDOR TAB: STALL MENU MANAGER (FIGMA HIGH-FIDELITY LAYOUT)
class VendorMenuTab extends StatelessWidget {
  const VendorMenuTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find<OrderController>();
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddNewFoodDialog(context);
        },
        backgroundColor: const Color(0xFF10B981),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Food', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Obx(() {
        var myMenuItems = orderController.menuItems.where((i) => i.stallId == 'STL001').toList();

        return ListView(
          padding: EdgeInsets.zero,
          children: [
            // Jhonford's Figma Slate Header Banner (Option B: Midnight Navy Gradient)
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 20,
                right: 20,
                bottom: 24,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0F172A),
                    Color(0xFF1E293B),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authController.currentUser.value?.stallName ?? 'Chef Maria\'s Canteen Stall',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            // Green verified badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(color: const Color(0xFF10B981).withOpacity(0.2)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 14),
                                  SizedBox(width: 4),
                                  Text(
                                    'Active Authority',
                                    style: TextStyle(
                                      color: Color(0xFF10B981),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          authController.logout();
                          Get.offAll(() => const WelcomeLoginScreen());
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withOpacity(0.12)),
                          ),
                          child: const Icon(
                            Icons.logout_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Jhonford's Floating metrics panel container
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2E38).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Today\'s Sales:',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  '₱4,520',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Active Orders:',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    '8',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: const Color(0xFF10B981).withOpacity(0.2)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'OPEN FOR ORDERS',
                                      style: TextStyle(
                                        color: Color(0xFF10B981),
                                        fontWeight: FontWeight.w900,
                                        fontSize: 11,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF10B981),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E3E4F),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.settings_rounded, color: Colors.white, size: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Dropdown label: MENU MANAGEMENT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'MENU MANAGEMENT',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF131D24),
                      letterSpacing: 0.5,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF131D24)),
                ],
              ),
            ),

            // Jhonford's premium rounded dark-slate list cards
            myMenuItems.isEmpty
                ? const Center(child: Text('No menu items created yet.'))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: myMenuItems.length,
                    itemBuilder: (context, idx) {
                      var food = myMenuItems[idx];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2E38), // Custom dark-slate background
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            // Left: Dish photo
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.network(
                                food.imageUrl,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 14),
                            // Center: Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    food.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text(
                                        '₱${food.price.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      if (food.isAvailable) ...[
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF10B981),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Text(
                                          'Available',
                                          style: TextStyle(
                                            color: Color(0xFF10B981),
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ] else ...[
                                        const Text(
                                          'Sold Out',
                                          style: TextStyle(
                                            color: Colors.white24,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Right: Edit pencil & Available Switch
                            const SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.06),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.edit_outlined, color: Colors.white70, size: 18),
                                onPressed: () {},
                              ),
                            ),
                            const SizedBox(width: 8),
                            Switch(
                              value: food.isAvailable,
                              activeColor: const Color(0xFF10B981),
                              inactiveThumbColor: Colors.grey.shade400,
                              inactiveTrackColor: Colors.white.withOpacity(0.1),
                              onChanged: (val) {
                                food.isAvailable = val;
                                orderController.menuItems.refresh();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 80), // extra padding for fab list scroll
          ],
        );
      }),
    );
  }

  void _showAddNewFoodDialog(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final descController = TextEditingController();
    final imageController = TextEditingController();
    String category = 'Meals';

    final List<Map<String, String>> imagePresets = [
      {
        'label': '🍗 Adobo Rice',
        'url': 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=300'
      },
      {
        'label': '🍔 Hamburger',
        'url': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300'
      },
      {
        'label': '🍜 Ramen Bowl',
        'url': 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=300'
      },
      {
        'label': '🥗 Fresh Salad',
        'url': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=300'
      },
      {
        'label': '🍰 Cake Slice',
        'url': 'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=300'
      },
      {
        'label': '🥤 Melon Juice',
        'url': 'https://images.unsplash.com/photo-1497534446932-c925b458314e?w=300'
      },
    ];

    // Set default preset
    imageController.text = imagePresets[0]['url']!;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('Add New Food Item', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Live Image Preview Card
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: imageController.text.trim().isNotEmpty
                            ? Image.network(
                                imageController.text,
                                fit: BoxFit.cover,
                                errorBuilder: (c, o, s) => const Center(
                                  child: Icon(Icons.broken_image_rounded, size: 36, color: Colors.grey),
                                ),
                              )
                            : const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_photo_alternate_rounded, size: 36, color: Colors.grey),
                                    SizedBox(height: 6),
                                    Text('No image chosen', style: TextStyle(color: Colors.grey, fontSize: 11)),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Select Food Photo Preset:',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 6),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(imagePresets.length, (i) {
                          bool isSelected = imageController.text == imagePresets[i]['url'];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(imagePresets[i]['label']!),
                              selected: isSelected,
                              selectedColor: const Color(0xFF6366F1).withOpacity(0.15),
                              backgroundColor: Colors.white,
                              labelStyle: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? const Color(0xFF6366F1) : AppColors.textSecondary,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: isSelected ? const Color(0xFF6366F1) : Colors.grey.shade200,
                                ),
                              ),
                              onSelected: (val) {
                                setModalState(() {
                                  imageController.text = imagePresets[i]['url']!;
                                });
                              },
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 14),

                    TextField(
                      controller: imageController,
                      decoration: const InputDecoration(
                        labelText: 'Or Paste Custom Image URL',
                        hintText: 'https://example.com/food.jpg',
                      ),
                      onChanged: (val) {
                        setModalState(() {});
                      },
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Food Name'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(labelText: 'Price (PHP)'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: descController,
                      decoration: const InputDecoration(labelText: 'Description'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: category,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: const [
                        DropdownMenuItem(value: 'Meals', child: Text('Meals')),
                        DropdownMenuItem(value: 'Drinks', child: Text('Drinks')),
                        DropdownMenuItem(value: 'Snacks', child: Text('Snacks')),
                      ],
                      onChanged: (val) {
                        setModalState(() {
                          category = val!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    Get.find<VendorController>().addNewFoodItem(
                      'STL001',
                      nameController.text,
                      double.parse(priceController.text),
                      descController.text,
                      category,
                      imageUrl: imageController.text,
                    );
                    Get.back();
                    Get.snackbar('Added!', '${nameController.text} added to your menu list!',
                        backgroundColor: const Color(0xFF6366F1), colorText: Colors.white);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1), foregroundColor: Colors.white),
                  child: const Text('Add Item'),
                )
              ],
            );
          },
        );
      },
    );
  }
}

// 3c. VENDOR TAB: ANALYTICS & REVENUE CHARTS
class VendorAnalyticsTab extends StatelessWidget {
  const VendorAnalyticsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VendorController vendorController = Get.find<VendorController>();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Stats boxes
        Row(
          children: [
            Expanded(
              child: Card(
                color: const Color(0xFF6366F1).withOpacity(0.08),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text('Total Stall Sales', style: TextStyle(color: Color(0xFF6366F1), fontSize: 13)),
                      const SizedBox(height: 6),
                      Obx(() => Text(
                            '₱${vendorController.totalRevenue.value.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF6366F1)),
                          )),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text('Stall Rating', style: TextStyle(color: Colors.green, fontSize: 13)),
                      const SizedBox(height: 6),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          const Text('4.8 / 5.0', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        const Text('Daily Revenue Analytics (Mock Chart)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBarChartColumn('Mon', 0.4),
                    _buildBarChartColumn('Tue', 0.65),
                    _buildBarChartColumn('Wed', 0.8),
                    _buildBarChartColumn('Thu', 0.95),
                    _buildBarChartColumn('Fri', 0.7),
                    _buildBarChartColumn('Sat', 0.2),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildBarChartColumn(String day, double heightPct) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 120 * heightPct,
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 8),
        Text(day, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}

// ==========================================
// 4. ADMIN WORKFLOW EXPERIENCE
// ==========================================
class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({Key? key}) : super(key: key);

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _adminTab = 0;

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    final List<Widget> adminScreens = [
      const AdminApprovalsTab(),
      const AdminVendorsListTab(),
      const AdminRevenueTab(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Premium Admin Gradient Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              left: 20,
              right: 20,
              bottom: 22,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Admin Console',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.18),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF10B981),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'SYS ACTIVE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 9,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Superuser Authority',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    authController.logout();
                    Get.offAll(() => const WelcomeLoginScreen());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.15)),
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: adminScreens[_adminTab],
          ),
        ],
      ),
      bottomNavigationBar: AdminBottomNavBar(
        currentIndex: _adminTab,
        onTap: (index) {
          setState(() {
            _adminTab = index;
          });
        },
      ),
    );
  }
}

class AdminBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AdminBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> navItems = [
      {'icon': Icons.fact_check_rounded, 'label': 'Approvals'},
      {'icon': Icons.storefront_rounded, 'label': 'Canteens'},
      {'icon': Icons.payments_rounded, 'label': 'Commissions'},
    ];

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(navItems.length, (index) {
          bool isActive = currentIndex == index;
          var item = navItems[index];

          return InkWell(
            onTap: () => onTap(index),
            borderRadius: BorderRadius.circular(28),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFFEF4444) : Colors.transparent,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                children: [
                  Icon(
                    item['icon'],
                    color: isActive ? Colors.white : AppColors.textSecondary,
                    size: 22,
                  ),
                  if (isActive) ...[
                    const SizedBox(width: 8),
                    Text(
                      item['label'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// 4a. ADMIN TAB: STALLS REGISTRATION APPROVALS
class AdminApprovalsTab extends StatelessWidget {
  const AdminApprovalsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find<OrderController>();
    final AdminController adminController = Get.find<AdminController>();

    return Obx(
      () {
        var unapproved = orderController.canteens.where((c) => !c.isApproved).toList();

        if (unapproved.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_outline_rounded,
                      size: 48,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'All Stalls Approved!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'There are no pending vendor registrations needing your review.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: unapproved.length,
          itemBuilder: (context, index) {
            var stall = unapproved[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(stall.imageUrl, width: 68, height: 68, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stall.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                stall.description,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  height: 1.3,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Divider(height: 28, color: Color(0xFFF1F5F9)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            adminController.rejectStall(stall);
                            Get.snackbar('Rejected', 'Stall application has been rejected.',
                                backgroundColor: const Color(0xFFEF4444), colorText: Colors.white);
                          },
                          child: const Text(
                            'Reject',
                            style: TextStyle(
                              color: Color(0xFFEF4444),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            adminController.approveStall(stall);
                            Get.snackbar('Approved!', '${stall.name} is now visible to customers!',
                                backgroundColor: AppColors.emerald, colorText: Colors.white);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.emerald,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Approve Application', style: TextStyle(fontWeight: FontWeight.bold)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// 4b. ADMIN TAB: MANAGE VENDORS & SUSPENDS
class AdminVendorsListTab extends StatelessWidget {
  const AdminVendorsListTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find<OrderController>();
    final AdminController adminController = Get.find<AdminController>();

    return Obx(
      () => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orderController.canteens.length,
        itemBuilder: (context, index) {
          var stall = orderController.canteens[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      stall.imageUrl,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stall.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: stall.isApproved 
                                    ? AppColors.emerald.withOpacity(0.08) 
                                    : const Color(0xFFEF4444).withOpacity(0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                stall.isApproved ? 'ACTIVE' : 'SUSPENDED',
                                style: TextStyle(
                                  color: stall.isApproved ? AppColors.emerald : const Color(0xFFEF4444),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      adminController.toggleStallStatus(stall);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: stall.isApproved 
                          ? const Color(0xFFEF4444).withOpacity(0.08) 
                          : AppColors.emerald.withOpacity(0.08),
                      foregroundColor: stall.isApproved ? const Color(0xFFEF4444) : AppColors.emerald,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    child: Text(
                      stall.isApproved ? 'Suspend' : 'Activate',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// 4c. ADMIN TAB: REVENUE REPORTS & COMMISSION LEDGER
class AdminRevenueTab extends StatelessWidget {
  const AdminRevenueTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AdminController adminController = Get.find<AdminController>();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Stats Boxes
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withOpacity(0.06),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.12)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Platform Sales',
                      style: TextStyle(color: Color(0xFFEF4444), fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => Text(
                          '₱${adminController.totalSales.value.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            color: Color(0xFFEF4444),
                            letterSpacing: -0.5,
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.emerald.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.emerald.withOpacity(0.12)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Commissions (10%)',
                      style: TextStyle(color: AppColors.emerald, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => Text(
                          '₱${adminController.commissionEarned.value.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            color: AppColors.emerald,
                            letterSpacing: -0.5,
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),

        const Text(
          'Commission Transaction Ledger',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 16,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
              },
              children: [
                const TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Text('Stall Name', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textSecondary, fontSize: 12)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Text('Sales', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textSecondary, fontSize: 12)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Text('Commission', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textSecondary, fontSize: 12)),
                    ),
                  ],
                ),
                _buildTableRow('Maria\'s Homestyle Meals', 14520.0, 1452.0),
                _buildTableRow('Wok & Roll Express', 12300.0, 1230.0),
                _buildTableRow('The Green Fork (Salads)', 9090.0, 909.0),
              ],
            ),
          ),
        )
      ],
    );
  }

  TableRow _buildTableRow(String name, double sales, double comm) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            name,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            '₱${sales.toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            '₱${comm.toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.emerald),
          ),
        ),
      ],
    );
  }
}
