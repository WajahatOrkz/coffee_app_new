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
  Future<String> createOrGetCartId(String userId); // ✅ New method
  Future<void> updateUserCartId(String userId, String cartId); // ✅ New method
  
  // User preferences
  // Future<void> saveUserPreferences(
  //   String userId,
  //   Map<String, dynamic> preferences,
  // );
  
  Future<Map<String, dynamic>?> loadUserPreferences(String userId);
}