
import 'package:coffee_app/features/coffee/domain/entities/expense_item_entity.dart';

class ExpenseItemModel {
  final String id;
  final String name;
  final String subtitle;
  final double price;
  final int quantity;
  final double totalItemPrice;
  final String image;

  ExpenseItemModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.quantity,
    required this.totalItemPrice,
    required this.image,
  });

  /// 🔹 JSON → Model
  factory ExpenseItemModel.fromJson(Map<String, dynamic> json) {
    return ExpenseItemModel(
      id: json['id'],
      name: json['name'],
      subtitle: json['subtitle'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      totalItemPrice: (json['totalItemPrice'] as num).toDouble(),
      image: json['image'],
    );
  }

  /// 🔹 Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subtitle': subtitle,
      'price': price,
      'quantity': quantity,
      'totalItemPrice': totalItemPrice,
      'image': image,
    };
  }

  /// ✅ Model → Entity
  ExpenseItemEntity toEntity() {
    return ExpenseItemEntity(
      id: id,
      name: name,
      subtitle: subtitle,
      price: price,
      quantity: quantity,
      totalItemPrice: totalItemPrice,
      image: image,
    );
  }

  /// ✅ Entity → Model
  factory ExpenseItemModel.fromEntity(ExpenseItemEntity entity) {
    return ExpenseItemModel(
      id: entity.id,
      name: entity.name,
      subtitle: entity.subtitle,
      price: entity.price,
      quantity: entity.quantity,
      totalItemPrice: entity.totalItemPrice,
      image: entity.image,
    );
  }
}