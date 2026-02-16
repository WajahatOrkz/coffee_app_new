import '../entities/coffee_entity.dart';

abstract class CoffeeRepository {
  Future<List<CoffeeEntity>> getCoffeeList({String? storeId});
  Future<void> seedData();

  // Future<dynamic> getCoffeeByCategory(String category) async {}

}