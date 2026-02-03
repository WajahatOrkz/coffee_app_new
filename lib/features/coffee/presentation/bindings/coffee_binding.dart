import 'package:coffee_app/features/auth/presentation/controllers/logout_controller.dart';
import 'package:coffee_app/features/coffee/data/respositories/coffee_repositories.dart';

import 'package:coffee_app/features/coffee/domain/repositories/coffee_repositories.dart';
import 'package:get/get.dart';


import '../controllers/coffee_controller.dart';

class CoffeeBinding extends Bindings {
  @override
  void dependencies() {
    // Repository inject
    Get.lazyPut<CoffeeRepository>(() => CoffeeRepositoryImpl());
    
    // Controller inject
    Get.lazyPut(() => CoffeeController(Get.find<CoffeeRepository>()));
    Get.lazyPut(()=> LogoutController());
  }
}