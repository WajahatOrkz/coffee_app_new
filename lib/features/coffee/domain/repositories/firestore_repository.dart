
import 'package:coffee_app/features/coffee/domain/entities/cart_entity.dart';
import 'package:coffee_app/features/coffee/domain/entities/coffee_entity.dart';

abstract class FirestoreRepository {
  Future<String> createOrGetCartId(String userId);
  Future<void> updateUserCartId(String userId, String cartId);

  Future<void> saveCart(
    String userId,
    String cartId,
    List<CoffeeEntity> cartItems,
    Map<String, int> quantities,
  );

  // repository now returns domain CartEntity
  Future<CartEntity> loadCart(String cartId);
  Stream<CartEntity> streamCart(String cartId);

  Future<void> clearCart(String cartId);

  Future<Map<String, dynamic>?> loadUserPreferences(String userId);

  Future<void> saveExpense({
    required String userId,
    required List<CoffeeEntity> items,
    required Map<String, int> quantities,
    required double totalPrice,
    required int totalItems,
    required int uniqueItems,
    required double totalItemPrice,
    required double subtotal,
    required String taxRate,
    required double taxAmount,
    required String paymentMethod,
  });

  Future<List<Map<String, dynamic>>> getUserExpenses(String userId);
}
