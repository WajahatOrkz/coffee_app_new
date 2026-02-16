import 'package:coffee_app/features/coffee/data/respositories/firestore_repository_impl.dart';
import 'package:coffee_app/features/coffee/domain/repositories/firestore_repository.dart';
import 'package:coffee_app/features/coffee/presentation/controllers/store_controller.dart';
import 'package:get/get.dart';

class StoreBinding extends Bindings{
  @override
  void dependencies(){
    if (!Get.isRegistered<FirestoreRepository>()) {
      Get.lazyPut<FirestoreRepository>(() => FirestoreRepositoryImpl());
    }
    Get.lazyPut<StoreController>(()=>StoreController(repository: Get.find()));
  }
}