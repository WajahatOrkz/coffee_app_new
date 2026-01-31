import 'package:coffee_app/core/constants/app_colors.dart';
import 'package:coffee_app/features/coffe/domain/repositories/coffee_repositories.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../domain/entities/coffee_entity.dart';

class CoffeeController extends GetxController {
  final CoffeeRepository repository;
  CoffeeController(this.repository);

  // Observable variables
  final allCoffeeList = <CoffeeEntity>[].obs;
  var searchedCoffeeList = <CoffeeEntity>[].obs;
  final isLoading = false.obs;
  final selectedCategory = 'All'.obs;
  final searchQuery = ''.obs;
  final filteredPrice = 0.obs;
  final cartItems = <CoffeeEntity>[].obs;
  final cartCount = 0.obs;
  final cartQuantities = <String, int>{}.obs; // ID -> Quantity mapping

  // Categories
  final categories = ['All', 'Espresso', 'Cappuccino', 'Cold'];

  @override
  void onInit() {
    super.onInit();
    loadCoffeeList();
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

  // Load coffee list
  Future<void> loadCoffeeList() async {
    try {
      isLoading.value = true;
      final list = await repository.getCoffeeList();
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
      searchedCoffeeList.value =
          allCoffeeList; // Agar search empty hai to original list show krna hai wo yahan ho raha
    } else {
      searchedCoffeeList.value = allCoffeeList.where((eachItem) {
        // Search query ke basis pe filter karna yahan se start ho raha
        final nameLower = eachItem.name.toLowerCase();
        // final subtitleLower = eachItem.subtitle.toLowerCase();
        final queryLower = query.toLowerCase();

        return nameLower.contains(queryLower);
      }).toList();
    }
  }

  // Ye function search aur counter dono ko check karega
  void applyFilters() {
    String query = searchQuery.value.toLowerCase();

    Get.log("SEARCH $searchQuery and FILTER valus is ${filteredPrice.value}");

    searchedCoffeeList.value = allCoffeeList.where((coffee) {
      final matchesName = coffee.name.toLowerCase().contains(query);

      final matchesRate =
          filteredPrice.value == 0 || (coffee.price <= filteredPrice.value);

      return matchesName && matchesRate;
    }).toList();

    Get.log("Filtered Results: ${searchedCoffeeList.length}");
  }

  //   void applyFilters() {
  //   String query = searchQuery.value.toLowerCase().trim();
  //   var filterSearchList = allCoffeeList.where((coffee) {
  //     final bool matchesName = query.isEmpty || coffee.name.toLowerCase().contains(query);
  //     final bool matchesPrice = filteredValue.value == 0 || (coffee.price <= filteredValue.value);
  //     return matchesName && matchesPrice;
  //   }).toList();
  //   // Pure list ko assign karein taake UI refresh ho
  //   searchedCoffeeList.value = filterSearchList;
  //   Get.log("Filtered Results: ${searchedCoffeeList.length}");
  // }

  // Clear search
  void clearSearch() {
    searchQuery.value = '';
    searchedCoffeeList.value = allCoffeeList;
    applyFilters();
  }

  void addToCart(CoffeeEntity coffee) {
    // Check if item already exists in cart
    final existingIndex = cartItems.indexWhere(
      (item) => item.id == coffee.id,
    ); // Check krna hai item already exist kr raha hai ya nahi?

    if (existingIndex != -1) {
      // Item already exists - increase quantity
      cartQuantities[coffee.id] =
          (cartQuantities[coffee.id] ?? 1) +
          1; // check kr raha hai k Item already exists kr raha hai - increase quantity

      Get.snackbar(
        'Updated Cart',
        '${coffee.name} quantity: ${cartQuantities[coffee.id]}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.kPrimaryColor,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    } else {
      // New item - add krna hai cart ko quantity 1 k saath
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

    // Update total count
    _updateCartCount();
  }

  // Get quantity for a specific item
  int getQuantity(String coffeeId) {
    return cartQuantities[coffeeId] ?? 0;
  }

  // Increase quantity
  void increaseQuantity(CoffeeEntity coffee) {
    if (cartQuantities.containsKey(coffee.id)) {
      cartQuantities[coffee.id] = (cartQuantities[coffee.id] ?? 0) + 1;
      cartQuantities.refresh();
      _updateCartCount();
    }
  }

  // Decrease quantity
  void decreaseQuantity(CoffeeEntity coffee) {
    if (cartQuantities.containsKey(coffee.id)) {
      final currentQty = cartQuantities[coffee.id] ?? 0;

      if (currentQty > 1) {
        cartQuantities[coffee.id] = currentQty - 1;
        cartQuantities.refresh();
        _updateCartCount();
      } else {
        // If quantity is 1, remove item completely
        removeFromCart(coffee);
      }
    }
  }

  // Remove from cart
  void removeFromCart(CoffeeEntity coffee) {
    cartItems.removeWhere((item) => item.id == coffee.id);
    cartQuantities.remove(coffee.id);
    _updateCartCount();

    Get.snackbar(
      'Removed from Cart',
      '${coffee.name} removed successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }

  // Clear all cart
  void clearCart() {
    cartItems.clear();
    cartQuantities.clear();
    cartCount.value = 0;
  }

  // Update cart count (total items with quantities)
  void _updateCartCount() {
    int totalCount = 0;
    cartQuantities.forEach((key, quantity) {
      totalCount += quantity;
    });
    cartCount.value = totalCount;
  }

  // Get total price (price × quantity for each item)
  double get totalPrice {
    double total = 0.0;
    for (var item in cartItems) {
      final quantity = cartQuantities[item.id] ?? 0;
      total += item.price * quantity;
    }
    return total;
  }

  // Get unique items count
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
