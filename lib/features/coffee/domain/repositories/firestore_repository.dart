import 'package:coffee_app/features/coffee/domain/entities/coffee_entity.dart';

abstract class FirestoreRepository {
  // Cart methods - ab cartId use karenge
  Future<void> saveCart(
    String userId,
    String cartId,
    List<CoffeeEntity> cartItems,
    Map<String, int> quantities,
  );

  Future<Map<String, dynamic>?> loadCart(String cartId);

  Stream<Map<String, dynamic>?> streamCart(String cartId);

  Future<void> clearCart(String cartId);

  // User methods - ab cartId manage karenge
  Future<String> createOrGetCartId(String userId);
  Future<void> updateUserCartId(String userId, String cartId);

  // User preferences
  // Future<void> saveUserPreferences(
  //   String userId,
  //   Map<String, dynamic> preferences,
  // );

  Future<Map<String, dynamic>?> loadUserPreferences(String userId);

  // ✅ Expense tracking
  Future<void> saveExpense({
    required String userId,
    required List<CoffeeEntity> items,
    required Map<String, int> quantities,
    required double totalPrice,
    required int totalItems,
    required int uniqueItems,
    required double subtotal,
    required String taxRate,
    required double taxAmount,
    required String paymentMethod,
    required double totalItemPrice,
  });

  Future<List<Map<String, dynamic>>> getUserExpenses(String userId);
}
