import 'package:coffee_app/features/coffee/data/respositories/firestore_repository_impl.dart';
import 'package:coffee_app/features/coffee/domain/repositories/firestore_repository.dart';
import 'package:coffee_app/features/coffee/domain/repositories/coffee_repository.dart'; // ✅ Import interface
import 'package:coffee_app/features/coffee/data/respositories/coffee_repository_impl.dart'; // ✅ Import implementation
import 'package:coffee_app/features/coffee/presentation/controllers/store_controller.dart';
import 'package:get/get.dart';

class StoreBinding extends Bindings{
  @override
  void dependencies(){
    if (!Get.isRegistered<FirestoreRepository>()) {
      Get.lazyPut<FirestoreRepository>(() => FirestoreRepositoryImpl());
    }

    if (!Get.isRegistered<CoffeeRepository>()) {
       Get.lazyPut<CoffeeRepository>(
          () => CoffeeRepositoryImpl(
            firestoreRepository: Get.find<FirestoreRepository>(),
          ),
        );
    }
    
    Get.lazyPut<StoreController>(()=>StoreController(
      repository: Get.find<FirestoreRepository>(),
      coffeeRepository: Get.find<CoffeeRepository>()
    ));
  }
}