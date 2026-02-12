import 'coffee_model.dart';
import 'package:coffee_app/features/coffee/domain/entities/cart_entity.dart';
import 'package:coffee_app/features/coffee/domain/entities/coffee_entity.dart';

class CartModel {
  final List<CoffeeModel> items;
  final Map<String, int> quantities;

  CartModel({
    required this.items,
    required this.quantities,
  });

  factory CartModel.fromMap(Map<String, dynamic> map) {
    final rawItems = (map['items'] as List?) ?? [];
    final items = rawItems.map<CoffeeModel>((e) {
      return CoffeeModel.fromMap(Map<String, dynamic>.from(e as Map));
    }).toList();

    final rawQuantities = Map<String, dynamic>.from(map['quantities'] ?? {});
    final quantities = rawQuantities.map<String, int>((k, v) => MapEntry(k, (v as int)));

    return CartModel(items: items, quantities: quantities);
  }

  Map<String, dynamic> toMap() => {
        'items': items.map((e) => e.toMap()).toList(),
        'quantities': quantities,
      };

  // convert data model -> domain entity
  CartEntity toEntity() {
    final entityItems = items.map<CoffeeEntity>((m) => m.toEntity()).toList();
    return CartEntity(items: entityItems, quantities: Map<String, int>.from(quantities));
  }
}