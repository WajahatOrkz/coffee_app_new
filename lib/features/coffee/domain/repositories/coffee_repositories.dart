import '../entities/coffee_entity.dart';

abstract class CoffeeRepository {
  Future<List<CoffeeEntity>> getCoffeeList();

  // Future<dynamic> getCoffeeByCategory(String category) async {}

}