import 'package:coffee_app/features/chat/presentation/controller/contacts_controller.dart';
import 'package:get/get.dart';

class ContactsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactsController>(() => ContactsController());
  }
}
