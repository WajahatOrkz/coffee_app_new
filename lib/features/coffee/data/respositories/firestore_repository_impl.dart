import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/features/coffee/data/models/expense_model.dart';
import 'package:coffee_app/features/coffee/data/models/store_model.dart';
import 'package:coffee_app/features/coffee/domain/entities/coffee_entity.dart';
import 'package:coffee_app/features/coffee/domain/entities/expense_entity.dart';
import 'package:coffee_app/features/coffee/domain/entities/store_entity.dart';
import 'package:coffee_app/features/coffee/domain/repositories/firestore_repository.dart';
import '../models/cart_model.dart';

import 'package:coffee_app/features/coffee/domain/entities/cart_entity.dart';

class FirestoreRepositoryImpl implements FirestoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  // @override
  // Future<Map<String, dynamic>?> loadUserPreferences(String userId) async {
  //   try {
  //     final doc = await _firestore.collection('users').doc(userId).get();
  //     if (!doc.exists) return null;
  //     final data = doc.data();
  //     return data?['preferences'] as Map<String, dynamic>?;
  //   } catch (e) {
  //     throw Exception('Preferences load failed: $e');
  //   }
  // }

  @override
  Future<void> saveExpense(ExpenseEntity entity) async {
    try {
      // ✅ Step 1: Entity → Model
      final model = ExpenseModel.fromEntity(entity);

      // ✅ Step 2: Model → JSON and Save to Firestore
      await _firestore
          .collection('expenses')
          .doc(model.expenseId)
          .set(model.toJson());

      print('✅ Expense saved successfully: ${model.expenseId}');
    } catch (e) {
      print('❌ Error saving expense: $e');
      throw Exception('Failed to save expense: $e');
    }
  }

  @override
  Future<List<ExpenseEntity>> getUserExpenses(String userId) async {
    try {
      // ✅ Step 1: Fetch from Firestore
      final snapshot = await _firestore
          .collection('expenses')
          .where('userId', isEqualTo: userId)
          .orderBy('orderDate', descending: true)
          .get();

      // ✅ Step 2: JSON → Model → Entity
      final entities = snapshot.docs
          .map((doc) => ExpenseModel.fromJson(doc.data(), doc.id).toEntity())
          .toList();

      print('✅ Fetched ${entities.length} expenses for user: $userId');

      // ✅ Step 3: Return List<ExpenseEntity> (NOT Model)
      return entities;
    } catch (e) {
      print('❌ Error fetching expenses: $e');
      throw Exception('Failed to load expenses: $e');
    }
  }

  @override
  Future<List<StoreEntity>> getStores() async {
    try {
      final snapshot = await _firestore.collection('stores').get();
      return snapshot.docs
          .map((doc) => StoreModel.fromJson(doc.data(), doc.id).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to load stores: $e');
    }
  }

  @override
  Future<void> addStore(StoreEntity store) async {
    try {
      final storeModel = StoreModel(
        id: store.id,
        name: store.name,
        address: store.address,
      );
      // If ID is empty, let Firestore generate it, effectively
      if (store.id.isEmpty) {
        await _firestore.collection('stores').add(storeModel.toJson());
      } else {
        await _firestore
            .collection('stores')
            .doc(store.id)
            .set(storeModel.toJson());
      }
    } catch (e) {
      throw Exception('Failed to add store: $e');
    }
  }
}
