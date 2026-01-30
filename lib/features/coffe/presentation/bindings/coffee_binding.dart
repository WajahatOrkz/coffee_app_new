import 'package:coffee_app/features/coffe/data/respositories/coffee_repositories.dart';

import 'package:coffee_app/features/coffe/domain/repositories/coffee_repositories.dart';
import 'package:get/get.dart';


import '../controllers/coffee_controller.dart';

class CoffeeBinding extends Bindings {
  @override
  void dependencies() {
    // Repository inject
    Get.lazyPut<CoffeeRepository>(() => CoffeeRepositoryImpl());
    
    // Controller inject
    Get.lazyPut(() => CoffeeController(Get.find<CoffeeRepository>()));
  }
}