
import 'package:coffee_app/features/coffee/data/models/expense_item_model.dart';
import 'package:coffee_app/features/coffee/domain/entities/expense_entity.dart';

class ExpenseModel {
  final String expenseId;
  final String userId;
  final List<ExpenseItemModel> items;
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

  ExpenseModel({
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

  /// 🔹 JSON → Model
  factory ExpenseModel.fromJson(Map<String, dynamic> json, String docId) {
    return ExpenseModel(
      expenseId: docId,
      userId: json['userId'],
      items: (json['items'] as List)
          .map((e) => ExpenseItemModel.fromJson(e))
          .toList(),
      totalItems: json['totalItems'],
      uniqueItems: json['uniqueItems'],
      totalPrice: (json['totalPrice'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      taxRate: json['taxRate'],
      taxAmount: (json['taxAmount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'],
      status: json['status'],
      orderDate: json['orderDate']?.toDate(),
      storeName: json['storeName'],
      storeLocation: json['storeLocation'],
    );
  }

  /// 🔹 Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'items': items.map((e) => e.toJson()).toList(),
      'totalItems': totalItems,
      'uniqueItems': uniqueItems,
      'totalPrice': totalPrice,
      'subtotal': subtotal,
      'taxRate': taxRate,
      'taxAmount': taxAmount,
      'paymentMethod': paymentMethod,
      'status': status,
      'orderDate': orderDate,
      'storeName': storeName,
      'storeLocation': storeLocation,
    };
  }

  /// ✅ Model → Entity
  ExpenseEntity toEntity() {
    return ExpenseEntity(
      expenseId: expenseId,
      userId: userId,
      items: items.map((e) => e.toEntity()).toList(),
      totalItems: totalItems,
      uniqueItems: uniqueItems,
      totalPrice: totalPrice,
      subtotal: subtotal,
      taxRate: taxRate,
      taxAmount: taxAmount,
      paymentMethod: paymentMethod,
      status: status,
      orderDate: orderDate,
      storeName: storeName,
      storeLocation: storeLocation,
    );
  }

  /// ✅ Entity → Model
  factory ExpenseModel.fromEntity(ExpenseEntity entity) {
    return ExpenseModel(
      expenseId: entity.expenseId,
      userId: entity.userId,
      items: entity.items.map((e) => ExpenseItemModel.fromEntity(e)).toList(),
      totalItems: entity.totalItems,
      uniqueItems: entity.uniqueItems,
      totalPrice: entity.totalPrice,
      subtotal: entity.subtotal,
      taxRate: entity.taxRate,
      taxAmount: entity.taxAmount,
      paymentMethod: entity.paymentMethod,
      status: entity.status,
      orderDate: entity.orderDate,
      storeName: entity.storeName,
      storeLocation: entity.storeLocation,
    );
  }
}