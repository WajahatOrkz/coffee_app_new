import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/features/coffee/domain/entities/coffee_entity.dart';
import 'package:coffee_app/features/coffee/domain/repositories/firestore_repository.dart';

class FirestoreRepositoryImpl implements FirestoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ Create or get existing cartId for user
  @override
  Future<String> createOrGetCartId(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        final data = userDoc.data();
        final existingCartId = data?['cartId'] as String?;

        if (existingCartId != null && existingCartId.isNotEmpty) {
          return existingCartId; // ✅ Existing cart ID return karo
        }
      }

      // ✅ Naya cart ID generate karo
      final newCartId = 'cart_${DateTime.now().millisecondsSinceEpoch}';

      // ✅ User document mein cart ID save karo
      await _firestore.collection('users').doc(userId).set({
        'cartId': newCartId,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return newCartId;
    } catch (e) {
      throw Exception('Failed to create/get cart ID: $e');
    }
  }

  // ✅ Update user's cartId
  @override
  Future<void> updateUserCartId(String userId, String cartId) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'cartId': cartId,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to update cart ID: $e');
    }
  }

  // ✅ Save cart to carts collection
  @override
  Future<void> saveCart(
    String userId,
    String cartId,
    List<CoffeeEntity> cartItems,
    Map<String, int> quantities,
  ) async {
    try {
      await _firestore.collection('carts').doc(cartId).set(
        {
          'userId': userId,
          'items': cartItems
              .map((item) => {
                    'id': item.id,
                    'name': item.name,
                    'subtitle': item.subtitle,
                    'price': item.price,
                    'image': item.image,
                    'rating': item.rating,
                  })
              .toList(),
          'quantities': quantities,
          'cartCount': cartItems.length,
          'lastUpdated': FieldValue.serverTimestamp(),
        },
        // SetOptions(merge: true),
      );
    } catch (e) {
      throw Exception('Cart save failed: $e');
    }
  }

  // ✅ Load cart from carts collection
  @override
  Future<Map<String, dynamic>?> loadCart(String cartId) async {
    try {
      final doc = await _firestore.collection('carts').doc(cartId).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      throw Exception('Cart load failed: $e');
    }
  }

  // ✅ Stream cart from carts collection
  @override
  Stream<Map<String, dynamic>?> streamCart(String cartId) {
    try {
      return _firestore
          .collection('carts')
          .doc(cartId)
          .snapshots()
          .map((doc) => doc.exists ? doc.data() : null);
    } catch (e) {
      return Stream.error('Cart stream failed: $e');
    }
  }

  // ✅ Clear cart from carts collection
  @override
  Future<void> clearCart(String cartId) async {
    try {
      await _firestore.collection('carts').doc(cartId).delete();
    } catch (e) {
      throw Exception('Cart clear failed: $e');
    }
  }

  // ✅ User preferences (unchanged)
  // @override
  // Future<void> saveUserPreferences(
  //   String userId,
  //   Map<String, dynamic> preferences,
  // ) async {
  //   try {
  //     await _firestore.collection('users').doc(userId).set({
  //       'preferences': preferences,
  //       'lastUpdated': FieldValue.serverTimestamp(),
  //     }, SetOptions(merge: true));
  //   } catch (e) {
  //     throw Exception('Preferences save failed: $e');
  //   }
  // }

  @override
  Future<Map<String, dynamic>?> loadUserPreferences(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) return null;
      final data = doc.data();
      return data?['preferences'] as Map<String, dynamic>?;
    } catch (e) {
      throw Exception('Preferences load failed: $e');
    }
  }
}