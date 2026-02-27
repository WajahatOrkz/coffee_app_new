import 'package:coffee_app/features/chat/presentation/bindings/contacts_binding.dart';
import 'package:coffee_app/features/coffee/presentation/bindings/coffee_binding.dart';
import 'package:coffee_app/features/main/presentation/controllers/main_controller.dart';
import 'package:get/get.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    
    // Initialize Coffee dependencies
    CoffeeBinding().dependencies();

    // Initialize Contacts dependencies
    ContactsBinding().dependencies();
  }
}
