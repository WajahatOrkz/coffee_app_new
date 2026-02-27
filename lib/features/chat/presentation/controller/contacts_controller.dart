import 'package:coffee_app/features/chat/domain/entities/contact_entity.dart';
import 'package:get/get.dart';

class ContactsController extends GetxController {
  var contacts = <ContactEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDummyContacts();
  }

  void loadDummyContacts() {
    contacts.value = [
      ContactEntity(
        id: 'user_1',
        name: 'Waseem',
        avatarUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026024d',
      ),
      ContactEntity(
        id: 'user_2',
        name: 'Samra',
        avatarUrl: 'https://i.pravatar.cc/150?u=a042581f4e29026704d',
      ),
      ContactEntity(
        id: 'user_3',
        name: 'Sara',
        avatarUrl: 'https://i.pravatar.cc/150?u=a04258114e29026702d',
      ),
      ContactEntity(
        id: 'user_4',
        name: 'Zahid',
        avatarUrl: 'https://i.pravatar.cc/150?u=a04258a2462d826712d',
      ),
      ContactEntity(
        id: 'user_5',
        name: 'Faisal',
        avatarUrl: 'https://i.pravatar.cc/150?u=a048581f4e29026701d',
      ),
    ];
  }
}
