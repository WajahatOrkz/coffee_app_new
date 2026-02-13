import 'dart:async';
import 'package:coffee_app/core/constants/app_colors.dart';
import 'package:coffee_app/core/services/user_services.dart';
import 'package:coffee_app/features/coffee/domain/entities/cart_entity.dart';
import 'package:coffee_app/features/coffee/domain/entities/coffee_entity.dart';
import 'package:coffee_app/features/coffee/domain/entities/expense_entity.dart';
import 'package:coffee_app/features/coffee/domain/entities/expense_item_entity.dart';
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

  final selectedPaymentMethod = ''.obs;

  String? _currentCartId;

  StreamSubscription<CartEntity?>? _cartSubscription;

  final categories = ['All', 'Espresso', 'Cappuccino', 'Cold'];

  static const double cashTaxRate = 0.10;
  static const double cardTaxRate = 0.05;

  @override
  void onInit() {
    super.onInit();
    loadCoffeeList();
    _initializeCart();
  }

  double get taxAmount {
    final basePrice = totalPrice;

    if (selectedPaymentMethod.value == 'cash') {
      return basePrice * cashTaxRate;
    } else if (selectedPaymentMethod.value == 'card') {
      return basePrice * cardTaxRate;
    }

    return 0.0;
  }

  double get finalTotal {
    return totalPrice + taxAmount;
  }

  String get taxPercentage {
    if (selectedPaymentMethod.value == 'cash') {
      return '10%';
    } else if (selectedPaymentMethod.value == 'card') {
      return '5%';
    }
    return '0%';
  }

  void setPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  Future<void> _initializeCart() async {
    final userId = userService.currentUserId;
    if (userId == null) {
      Get.log('No user logged in');
      return;
    }

    try {
      _currentCartId = await firestoreRepository.createOrGetCartId(userId);
      Get.log('✅ Cart ID initialized: $_currentCartId');

      await loadUserCart();
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
      final CartEntity? cartEntity = await firestoreRepository.loadCart(
        _currentCartId!,
      );

      if (cartEntity != null) {
        // controller now receives domain entity directly
        cartItems.value = List<CoffeeEntity>.from(cartEntity.items);
        cartItems.refresh();

        final quantities = Map<String, int>.from(cartEntity.quantities);
        quantities.removeWhere(
          (id, _) => !cartItems.any((item) => item.id == id),
        );

        cartQuantities.value = quantities;
        cartQuantities.refresh();

        _updateCartCount();

        Get.log('✅ Cart loaded as entity: $_currentCartId');
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
      _cartSubscription = firestoreRepository
          .streamCart(_currentCartId!)
          .listen(
            (cartEntity) {
              cartItems.value = List<CoffeeEntity>.from(cartEntity.items);
              cartItems.refresh();

              final quantities = Map<String, int>.from(cartEntity.quantities);
              quantities.removeWhere(
                (id, _) => !cartItems.any((item) => item.id == id),
              );
              cartQuantities.value = quantities;
              cartQuantities.refresh();

              _updateCartCount();
              Get.log('✅ Cart updated from remote changes (entity)');
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

  Future<void> confirmOrder() async {
    final userId = userService.currentUserId;

    if (userId == null) {
      Get.snackbar(
        'Error',
        'User not logged in',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (cartItems.isEmpty) {
      Get.snackbar(
        'Error',
        'Cart is empty',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedPaymentMethod.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a payment method',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    // 🔥 Check if cartId exists
    if (_currentCartId == null) {
      Get.snackbar(
        'Error',
        'Cart ID not found',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      // ✅ Save expense with final total (including tax)
      final expenseEntity = ExpenseEntity(
        expenseId: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        items: cartItems.map((item) {
          final quantity = cartQuantities[item.id] ?? 0;
          return ExpenseItemEntity(
            id: item.id,
            name: item.name,
            subtitle: item.subtitle,
            price: item.price,
            quantity: quantity,
            totalItemPrice: item.price * quantity,
            image: item.image,
          );
        }).toList(),
        totalItems: cartCount.value,
        uniqueItems: uniqueItemsCount,
        totalPrice: finalTotal,
        subtotal: totalPrice,
        taxRate: taxPercentage,
        taxAmount: taxAmount,
        paymentMethod: selectedPaymentMethod.value,
        status: 'completed',
        orderDate: DateTime.now(),
      );

      await firestoreRepository.saveExpense(expenseEntity);

      await firestoreRepository.clearCart(_currentCartId!);
      Get.log('✅ clearCart completed');

      cartItems.clear();
      cartQuantities.clear();
      selectedPaymentMethod.value = '';
      _currentCartId = null;

      Get.back();

      Get.log('✅ Order confirmed and saved to expenses');
    } catch (e) {
      Get.log('❌ Error confirming order: $e');
      Get.snackbar(
        'Error',
        'Failed to place order: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
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
}
