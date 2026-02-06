import 'package:coffee_app/core/constants/app_colors.dart';

import 'package:coffee_app/core/services/user_services.dart';
import 'package:coffee_app/features/coffee/domain/entities/coffee_entity.dart';
import 'package:coffee_app/features/coffee/domain/repositories/coffee_repositories.dart';

import 'package:coffee_app/features/coffee/domain/repositories/firestore_repositories.dart';

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

  final categories = ['All', 'Espresso', 'Cappuccino', 'Cold'];

  @override
  void onInit() {
    super.onInit();
    loadCoffeeList();
    loadUserCart();
  }

  Future<void> loadUserCart() async {
    final userId = userService.currentUserId;
    if (userId == null) {
      Get.log('No user logged in');
      return;
    }

    try {
      final cartData = await firestoreRepository.loadCart(userId);

      if (cartData != null) {
        // Restore items
        final items =
            (cartData['items'] as List?)?.map((item) {
              return CoffeeEntity(
                id: item['id'],
                name: item['name'],
                subtitle: item['subtitle'],
                price: item['price'].toDouble(),
                image: item['image'],
                rating: item['rating'].toDouble(),
              );
            }).toList() ??
            [];

        cartItems.value = items;

        // Restore quantities
        final quantities = Map<String, int>.from(cartData['quantities'] ?? {});
        cartQuantities.value = quantities;

        _updateCartCount();

        Get.log('✅ Cart loaded for user: $userId');
      } else {
        Get.log('No saved cart found for user: $userId');
      }
    } catch (e) {
      Get.log('❌ Error loading cart: $e');
    }
  }

  Future<void> _saveCartToFirestore() async {
    final userId = userService.currentUserId;
    if (userId == null) {
      Get.log('Cannot save cart: No user logged in');
      return;
    }

    try {
      await firestoreRepository.saveCart(userId, cartItems, cartQuantities);
      Get.log('✅ Cart saved for user: $userId');
    } catch (e) {
      Get.log('❌ Error saving cart: $e');
    }
  }

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
      final matchesName = coffee.name.toLowerCase().contains(query);
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

  // ========== Cart Functions ==========

  void addToCart(CoffeeEntity coffee) {
    final existingIndex = cartItems.indexWhere((item) => item.id == coffee.id);

    if (existingIndex != -1) {
      cartQuantities[coffee.id] = (cartQuantities[coffee.id] ?? 1) + 1;

      Get.snackbar(
        'Updated Cart',
        '${coffee.name} quantity: ${cartQuantities[coffee.id]}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.kPrimaryColor,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    } else {
      cartItems.add(coffee);
      cartQuantities[coffee.id] = 1;

      Get.snackbar(
        'Added to Cart',
        '${coffee.name} added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.kPrimaryColor,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    }

    _updateCartCount();
    _saveCartToFirestore(); // ✅ Save to Firestore
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
    cartQuantities.remove(coffee.id);
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

  Future<void> clearCart() async {
    cartItems.clear();
    cartQuantities.clear();
    cartCount.value = 0;

    final userId = userService.currentUserId;
    if (userId != null) {
      await firestoreRepository.clearCart(userId);
    }
  }

  void _updateCartCount() {
    int totalCount = 0;
    cartQuantities.forEach((key, quantity) {
      totalCount += quantity;
    });
    cartCount.value = totalCount;
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
