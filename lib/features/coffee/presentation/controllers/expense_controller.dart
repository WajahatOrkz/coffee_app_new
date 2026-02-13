import 'package:coffee_app/features/coffee/domain/entities/expense_entity.dart';
import 'package:get/get.dart';
import 'package:coffee_app/features/coffee/domain/repositories/firestore_repository.dart';

class ExpenseController extends GetxController {
  final FirestoreRepository repository;
  final String userId;

  ExpenseController({required this.repository, required this.userId});

  // UI update ke liye observable variables
  var expenses = <ExpenseEntity>[].obs;
  var isLoading = false.obs;

  void onInit() {
    super.onInit();
    print("userId :$userId");
    if (userId.isNotEmpty) {
      fetchExpenses();
    } else {
      isLoading(false);
      Get.snackbar("Error", "User not logged in");
    }
  }

  Future<void> fetchExpenses() async {
    try {
      isLoading(true);
      final data = await repository.getUserExpenses(userId);
      print("**********************$data");
      expenses.assignAll(data);
    } catch (e) {
      print("Error fetching expenses: $e");
    } finally {
      isLoading(false);
    }
  }


}