import 'dart:async';
import 'package:coffee_app/core/constants/app_colors.dart';
import 'package:coffee_app/core/services/user_services.dart';
import 'package:coffee_app/features/coffee/domain/entities/coffee_entity.dart';
import 'package:coffee_app/features/coffee/domain/repositories/coffee_repository.dart';
import 'package:coffee_app/features/coffee/domain/repositories/firestore_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoffeeController extends GetxController {
  final CoffeeRepository coffeeRepository;
  final FirestoreRepository firestoreRepository;
  final UserService userService = Get.find<UserService>();

  CoffeeController({
    required this.coffeeRepository,
    required this.firestoreRepository,
  });

  // Observable variables
  final allCoffeeList = <CoffeeEntity>[].obs;
  var searchedCoffeeList = <CoffeeEntity>[].obs;
  final isLoading = false.obs;
  final selectedCategory = 'All'.obs;
  final searchQuery = ''.obs;
  final filteredPrice = 0.obs;
  final cartItems = <CoffeeEntity>[].obs;
  final cartCount = 0.obs;
  final cartQuantities = <String, int>{}.obs;
  
  // ✅ New: Current user's cart ID
  String? _currentCartId;
  
  StreamSubscription<Map<String, dynamic>?>? _cartSubscription;

  final categories = ['All', 'Espresso', 'Cappuccino', 'Cold'];

  @override
  void onInit() {
    super.onInit();
    loadCoffeeList();
    _initializeCart(); // ✅ Changed
  }

  // ✅ Initialize cart with cartId
  Future<void> _initializeCart() async {
    final userId = userService.currentUserId;
    if (userId == null) {
      Get.log('No user logged in');
      return;
    }

    try {
      // ✅ Get or create cart ID
      _currentCartId = await firestoreRepository.createOrGetCartId(userId);
      Get.log('✅ Cart ID initialized: $_currentCartId');

      // ✅ Load cart data
      await loadUserCart();

      // ✅ Start listening to cart changes
      _startCartListener();
    } catch (e) {
      Get.log('❌ Failed to initialize cart: $e');
    }
  }

  Future<void> loadUserCart() async {
    if (_currentCartId == null) {
      Get.log('No cart ID available');
      return;
    }

    try {
      final cartData = await firestoreRepository.loadCart(_currentCartId!);

      if (cartData != null) {
        // Restore items
        final items = (cartData['items'] as List?)
                ?.map((item) {
                  return CoffeeEntity(
                    id: item['id'],
                    name: item['name'],
                    subtitle: item['subtitle'],
                    price: item['price'].toDouble(),
                    image: item['image'],
                    rating: item['rating'].toDouble(),
                  );
                })
                .toList() ??
            [];

        cartItems.value = items;

        // Restore quantities
        final quantities = Map<String, int>.from(cartData['quantities'] ?? {});
        quantities.removeWhere((id, _) => !items.any((item) => item.id == id));

        cartQuantities.value = quantities;
        cartQuantities.refresh();

        _updateCartCount();

        Get.log('✅ Cart loaded: $_currentCartId');
      } else {
        Get.log('No saved cart found: $_currentCartId');
      }
    } catch (e) {
      Get.log('❌ Error loading cart: $e');
    }
  }

  void _startCartListener() {
    if (_currentCartId == null) return;

    try {
      _cartSubscription = firestoreRepository.streamCart(_currentCartId!).listen(
            (cartData) {
              if (cartData == null) {
                cartItems.clear();
                cartItems.refresh();
                cartQuantities.clear();
                cartQuantities.refresh();
                cartCount.value = 0;
                Get.log('✅ Remote cart deleted - local cart cleared');
                return;
              }

              final items = (cartData['items'] as List?)
                      ?.map((item) {
                        return CoffeeEntity(
                          id: item['id'],
                          name: item['name'],
                          subtitle: item['subtitle'],
                          price: (item['price'] is int)
                              ? (item['price'] as int).toDouble()
                              : (item['price'] as double),
                          image: item['image'],
                          rating: (item['rating'] is int)
                              ? (item['rating'] as int).toDouble()
                              : (item['rating'] as double),
                        );
                      })
                      .toList() ??
                  [];

              cartItems.value = items;

              final quantities = Map<String, int>.from(
                cartData['quantities'] ?? {},
              );

              quantities.removeWhere(
                (id, _) => !items.any((item) => item.id == id),
              );

              cartQuantities.value = quantities;
              cartQuantities.refresh();

              _updateCartCount();
              Get.log('✅ Cart updated from remote changes');
            },
            onError: (e) {
              Get.log('❌ Cart stream error: $e');
            },
          );
    } catch (e) {
      Get.log('❌ Failed to start cart listener: $e');
    }
  }

  Future<void> _saveCartToFirestore() async {
    final userId = userService.currentUserId;
    if (userId == null || _currentCartId == null) {
      Get.log('Cannot save cart: No user or cart ID');
      return;
    }

    try {
      await firestoreRepository.saveCart(
        userId,
        _currentCartId!,
        cartItems,
        cartQuantities,
      );
      Get.log('✅ Cart saved: $_currentCartId');
    } catch (e) {
      Get.log('❌ Error saving cart: $e');
    }
  }

  // ✅ Rest of the methods remain the same
  void incrementFilter() {
    if (filteredPrice.value < 10) {
      filteredPrice.value++;
    } else {
      Get.snackbar(
        'Limit Reached',
        'Maximum value 10 hi ho sakti hai',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  void decrementFilter() {
    if (filteredPrice.value > 0) {
      filteredPrice.value--;
    } else {
      Get.snackbar(
        'Limit Reached',
        'Minimum value 0 hi ho sakti hai',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  Future<void> loadCoffeeList() async {
    try {
      isLoading.value = true;
      final list = await coffeeRepository.getCoffeeList();
      allCoffeeList.value = list;
      searchedCoffeeList.value = list;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void searchCoffee(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      searchedCoffeeList.value = allCoffeeList;
    } else {
      searchedCoffeeList.value = allCoffeeList.where((eachItem) {
        final nameLower = eachItem.name.toLowerCase();
        final queryLower = query.toLowerCase();
        return nameLower.contains(queryLower);
      }).toList();
    }
  }

  void applyFilters() {
    String query = searchQuery.value.toLowerCase();

    searchedCoffeeList.value = allCoffeeList.where((coffee) {
      final matchesName =
          query.isEmpty || coffee.name.toLowerCase().contains(query);
      final matchesRate =
          filteredPrice.value == 0 || (coffee.price <= filteredPrice.value);
      return matchesName && matchesRate;
    }).toList();

    Get.log("Filtered Results: ${searchedCoffeeList.length}");
  }

  void clearSearch() {
    searchQuery.value = '';
    searchedCoffeeList.value = allCoffeeList;
    applyFilters();
  }

  void addToCart(CoffeeEntity coffee) {
    final existingIndex = cartItems.indexWhere((item) => item.id == coffee.id);

    if (existingIndex != -1) {
      cartQuantities[coffee.id] = (cartQuantities[coffee.id] ?? 1) + 1;
    } else {
      cartItems.add(coffee);
      cartQuantities[coffee.id] = 1;
    }

    _updateCartCount();
    _saveCartToFirestore();
  }

  int getQuantity(String coffeeId) {
    return cartQuantities[coffeeId] ?? 0;
  }

  void increaseQuantity(CoffeeEntity coffee) {
    if (cartQuantities.containsKey(coffee.id)) {
      cartQuantities[coffee.id] = (cartQuantities[coffee.id] ?? 0) + 1;
      cartQuantities.refresh();
      _updateCartCount();
      _saveCartToFirestore();
    }
  }

  void decreaseQuantity(CoffeeEntity coffee) {
    if (cartQuantities.containsKey(coffee.id)) {
      final currentQty = cartQuantities[coffee.id] ?? 0;

      if (currentQty > 1) {
        cartQuantities[coffee.id] = currentQty - 1;
        cartQuantities.refresh();
        _updateCartCount();
        _saveCartToFirestore();
      } else {
        removeFromCart(coffee);
      }
    }
  }

  void removeFromCart(CoffeeEntity coffee) {
    cartItems.removeWhere((item) => item.id == coffee.id);
    cartItems.refresh();

    cartQuantities.remove(coffee.id);
    cartQuantities.refresh();

    _sanitizeQuantities();

    _updateCartCount();
    _saveCartToFirestore();

    Get.snackbar(
      'Removed from Cart',
      '${coffee.name} removed successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }

  void removeFromCartById(String coffeeId) {
    final item = cartItems.firstWhereOrNull((item) => item.id == coffeeId);
    if (item == null) return;

    cartItems.removeWhere((item) => item.id == coffeeId);
    cartItems.refresh();

    cartQuantities.remove(coffeeId);
    cartQuantities.refresh();

    _sanitizeQuantities();

    _updateCartCount();
    _saveCartToFirestore();
  }

  Future<void> clearCart() async {
    if (_currentCartId == null) return;

    try {
      isLoading.value = true;
      cartItems.clear();
      cartItems.refresh();
      cartQuantities.clear();
      cartQuantities.refresh();
      cartCount.value = 0;

      await firestoreRepository.clearCart(_currentCartId!);
    } catch (e) {
      Get.log('❌ Error clearing cart: $e');
      Get.snackbar('Error', 'Failed to clear cart: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _cartSubscription?.cancel();
    super.onClose();
  }

  void _updateCartCount() {
    int totalCount = 0;
    cartQuantities.forEach((key, quantity) {
      totalCount += quantity;
    });
    cartCount.value = totalCount;
  }

  void _sanitizeQuantities() {
    final currentItemIds = cartItems.map((item) => item.id).toSet();
    cartQuantities.removeWhere((id, _) => !currentItemIds.contains(id));
    cartQuantities.refresh();
    Get.log('✅ Quantities sanitized - removed stale entries');
  }

  double get totalPrice {
    double total = 0.0;
    for (var item in cartItems) {
      final quantity = cartQuantities[item.id] ?? 0;
      total += item.price * quantity;
    }
    return total;
  }

  int get uniqueItemsCount => cartItems.length;

  void processCheckout() {
    if (cartItems.isEmpty) {
      Get.snackbar("Error", "Aapka cart pehle hi khali hai!");
      return;
    }

    clearCart();

    Get.snackbar(
      'Success',
      'Aapki shopping mukammal ho gayi hai!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.kPrimaryColor,
      colorText: Colors.white,
    );
    Future.delayed(Duration(seconds: 2), () => Get.back());
  }
}