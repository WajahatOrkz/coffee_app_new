import 'package:coffee_app/features/coffee/domain/entities/coffee_entity.dart';

class CartEntity {
  final List<CoffeeEntity> items;
  final Map<String, int> quantities;

  CartEntity({
    required this.items,
    required this.quantities,
  });
}
