import 'package:coffee_app/features/coffee/domain/entities/expense_item_entity.dart';

class ExpenseEntity {
  final String expenseId;
  final String userId;
  final List<ExpenseItemEntity> items;
  final int totalItems;
  final int uniqueItems;
  final double totalPrice;
  final double subtotal;
  final String taxRate;
  final double taxAmount;
  final String paymentMethod;
  final String status;
  final DateTime? orderDate;
  final String? storeName;
  final String? storeLocation;

  ExpenseEntity({
    required this.expenseId,
    required this.userId,
    required this.items,
    required this.totalItems,
    required this.uniqueItems,
    required this.totalPrice,
    required this.subtotal,
    required this.taxRate,
    required this.taxAmount,
    required this.paymentMethod,
    required this.status,
    this.orderDate,
    this.storeName,
    this.storeLocation,
  });
}