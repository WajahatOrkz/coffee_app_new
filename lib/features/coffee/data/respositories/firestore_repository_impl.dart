import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/features/coffee/domain/entities/coffee_entity.dart';
import 'package:coffee_app/features/coffee/domain/repositories/firestore_repository.dart';
import '../models/cart_model.dart';

import 'package:coffee_app/features/coffee/domain/entities/cart_entity.dart';

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
              .map(
                (item) => {
                  'id': item.id,
                  'name': item.name,
                  'subtitle': item.subtitle,
                  'price': item.price,
                  'image': item.image,
                  'rating': item.rating,
                },
              )
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
  Future<CartEntity> loadCart(String cartId) async {
    try {
      final doc = await _firestore.collection('carts').doc(cartId).get();

      final data = Map<String, dynamic>.from(doc.data()!);
      final cartModel = CartModel.fromMap(data);

      return cartModel.toEntity();
    } catch (e) {
      throw Exception('Cart load failed: $e');
    }
  }

  // ✅ Stream cart from carts collection
  @override
  Stream<CartEntity> streamCart(String cartId) {
    try {
      return _firestore
          .collection('carts')
          .doc(cartId)
          .snapshots()
          .map(
            (doc) => doc.exists
                ? CartModel.fromMap(
                    Map<String, dynamic>.from(doc.data()!),
                  ).toEntity()
                : CartEntity(items: [], quantities: {}),
          );
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

  // ✅ Save Expense to Firestore
  @override
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
  }) async {
    try {
      final expenseId = 'expense_${DateTime.now().millisecondsSinceEpoch}';

      final itemsData = items.map((item) {
        final quantity = quantities[item.id] ?? 1;
        return {
          'id': item.id,
          'name': item.name,
          'subtitle': item.subtitle,
          'price': item.price,
          'quantity': quantity,
          'totalItemPrice': totalItemPrice,
          'image': item.image,
        };
      }).toList();

      await _firestore.collection('expenses').doc(expenseId).set({
        'userId': userId,
        'expenseId': expenseId,
        'items': itemsData,
        'totalItems': totalItems,
        'uniqueItems': uniqueItems,
        'totalPrice': totalPrice,
        'orderDate': FieldValue.serverTimestamp(),
        'status': 'completed',
        'subtotal': subtotal,
        'taxRate': taxRate,
        'taxAmount': taxAmount,
        'paymentMethod': paymentMethod,
      });

      print('✅ Expense saved: $expenseId');
    } catch (e) {
      throw Exception('Failed to save expense: $e');
    }
  }

  // ✅ Get user expenses
  @override
  Future<List<Map<String, dynamic>>> getUserExpenses(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('expenses')
          .where('userId', isEqualTo: userId)
          .orderBy('orderDate', descending: true)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to load expenses: $e');
    }
  }
}
