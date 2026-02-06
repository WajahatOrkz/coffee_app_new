import 'package:coffee_app/features/coffee/domain/entities/coffee_entity.dart';

abstract class FirestoreRepository {
  Future<void> saveCart(
    String userId,
    List<CoffeeEntity> cartItems,
    Map<String, int> quantities,
  );

  Future<Map<String, dynamic>?> loadCart(String userId);

  Future<void> clearCart(String userId);

  Future<void> saveUserPreferences(
    String userId,
    Map<String, dynamic> preferences,
  );

  Future<Map<String, dynamic>?> loadUserPreferences(String userId);
}