import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/features/coffee/domain/entities/coffee_entity.dart';
import 'package:coffee_app/features/coffee/domain/repositories/firestore_repositories.dart';


class FirestoreRepositoryImpl implements FirestoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> saveCart(
    String userId,
    List<CoffeeEntity> cartItems,
    Map<String, int> quantities,
  ) async {
    try {
      // ✅ Optimized: Use merge to prevent overwriting other user data
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc('items')
          .set(
            {
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
              'cartCount': cartItems.length, // ✅ Cache frequently accessed count
              'lastUpdated': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true), // ✅ Prevent data loss if document has other fields
          );
    } catch (e) {
      throw Exception('Cart save failed: $e');
    }
  }

  @override
  Future<Map<String, dynamic>?> loadCart(String userId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc('items')
          .get();

      return doc.exists ? doc.data() : null;
    } catch (e) {
      throw Exception('Cart load failed: $e');
    }
  }

  @override
  Stream<Map<String, dynamic>?> streamCart(String userId) {
    try {
      return _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc('items')
          .snapshots()
          .map((doc) => doc.exists ? doc.data() : null);
    } catch (e) {
      // Convert error to a stream error
      return Stream.error('Cart stream failed: $e');
    }
  }

  @override
  Future<void> clearCart(String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc('items')
          .delete();
    } catch (e) {
      throw Exception('Cart clear failed: $e');
    }
  }

  @override
  Future<void> saveUserPreferences(
    String userId,
    Map<String, dynamic> preferences,
  ) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'preferences': preferences,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Preferences save failed: $e');
    }
  }

  @override
  Future<Map<String, dynamic>?> loadUserPreferences(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) return null;
      final data = doc.data();
      return data?['preferences'] as Map<String, dynamic>?; // ✅ Fixed typo: prefrences -> preferences
    } catch (e) {
      throw Exception('Preferences load failed: $e');
    }
  }
}