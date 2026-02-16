// import 'package:coffee_app/features/auth/presentation/controllers/logout_controller.dart';
// import 'package:coffee_app/features/coffee/data/respositories/coffee_repositories_impl.dart';

// import 'package:coffee_app/features/coffee/domain/repositories/coffee_repositories.dart';
// import 'package:get/get.dart';


// import '../controllers/coffee_controller.dart';

// class CoffeeBinding extends Bindings {
//   @override
//   void dependencies() {
//     // Repository inject
//     Get.lazyPut<CoffeeRepository>(() => CoffeeRepositoryImpl());
    
//     // Controller inject
//     Get.lazyPut(() => CoffeeController(Get.find<CoffeeRepository>()));
//     Get.lazyPut(()=> LogoutController());
//   }
// }




import 'package:coffee_app/core/services/user_services.dart';
import 'package:coffee_app/features/auth/presentation/controllers/logout_controller.dart';

import 'package:coffee_app/features/coffee/data/respositories/coffee_repository_impl.dart';
import 'package:coffee_app/features/coffee/data/respositories/firestore_repository_impl.dart';
import 'package:coffee_app/features/coffee/domain/repositories/coffee_repository.dart';

import 'package:coffee_app/features/coffee/domain/repositories/firestore_repository.dart';

import 'package:get/get.dart';

import '../controllers/coffee_controller.dart';

class CoffeeBinding extends Bindings {
  @override
  void dependencies() {
    // ✅ UserService (agar pehle se nahi hai)
    if (!Get.isRegistered<UserService>()) {
      Get.put(UserService(), permanent: true);
    }

    // ✅ Firestore Repository
    Get.lazyPut<FirestoreRepository>(() => FirestoreRepositoryImpl());

    // ✅ Coffee Repository
    Get.lazyPut<CoffeeRepository>(() => CoffeeRepositoryImpl(
      firestoreRepository: Get.find<FirestoreRepository>(),
    ));

    // ✅ CoffeeController with both repositories
    Get.lazyPut(() => CoffeeController(
          coffeeRepository: Get.find<CoffeeRepository>(),
          firestoreRepository: Get.find<FirestoreRepository>(),
        ));

    // ✅ LogoutController
    Get.lazyPut(() => LogoutController());
  }
}