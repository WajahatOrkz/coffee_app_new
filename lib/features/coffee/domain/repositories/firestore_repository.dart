import 'package:coffee_app/features/coffee/domain/entities/cart_entity.dart';
import 'package:coffee_app/features/coffee/domain/entities/coffee_entity.dart';
import 'package:coffee_app/features/coffee/domain/entities/expense_entity.dart';
import 'package:coffee_app/features/coffee/domain/entities/store_entity.dart';

abstract class FirestoreRepository {
  Future<String> createOrGetCartId(String userId);
  Future<void> updateUserCartId(String userId, String cartId);

  Future<void> saveCart(
    String userId,
    String cartId,
    List<CoffeeEntity> cartItems,
    Map<String, int> quantities,
  );

  Future<CartEntity> loadCart(String cartId);
  Stream<CartEntity> streamCart(String cartId);

  Future<void> clearCart(String cartId);

  Future<void> saveExpense(ExpenseEntity expense);
  Future<List<ExpenseEntity>> getUserExpenses(String userId);

  Future<List<StoreEntity>> getStores();
  Future<void> addStore(StoreEntity store);
}
