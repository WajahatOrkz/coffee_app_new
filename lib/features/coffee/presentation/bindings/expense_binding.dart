import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:coffee_app/features/coffee/domain/repositories/firestore_repository.dart';
import 'package:coffee_app/features/coffee/presentation/controllers/expense_controller.dart'; // Apna path check karein

class ExpenseBinding extends Bindings {
 

  @override
  void dependencies() {

    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";
    // Repository pehle se inject honi chahiye ya yahan inject karein
    Get.lazyPut<ExpenseController>(
      () => ExpenseController(
        repository: Get.find<FirestoreRepository>(),
        userId: currentUserId,
      ),
    );
  }
}