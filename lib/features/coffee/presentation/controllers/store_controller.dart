import 'package:coffee_app/core/constants/app_colors.dart';
import 'package:coffee_app/features/coffee/domain/entities/store_entity.dart';
import 'package:coffee_app/features/coffee/domain/repositories/firestore_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreController extends GetxController {
  final FirestoreRepository repository;

  StoreController({required this.repository});

  final stores = <StoreEntity>[].obs;
  final isLoading = false.obs;
  final selectedStore = Rxn<StoreEntity>();

  final nameController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadStores();
  }

  Future<void> loadStores() async {
    try {
      print("store controller call ho raha hai??");
      isLoading.value = true;
      final loadedStores = await repository.getStores();
      stores.value = loadedStores;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load stores: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addStore() async {
    if (nameController.text.isEmpty || addressController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        backgroundColor: AppColors.kPrimaryColor,
        colorText: AppColors.textPrimary,
      );
      return;
    }

    try {
      print("store controller call ho raha hai??");
      isLoading.value = true;
      final newStore = StoreEntity(
        id: '', // Firestore will generate ID if we use add() logic or we can generate here
        name: nameController.text.trim(),
        address: addressController.text.trim(),
      );

      await repository.addStore(newStore);

      nameController.clear();
      addressController.clear();
      Get.back(); // Close dialog

      await loadStores();
      Get.snackbar(
        'Success',
        'Store added successfully',
        colorText: AppColors.kPrimaryColor,
        backgroundColor: AppColors.kPrimaryColor,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add store: $e',
        colorText: AppColors.kPrimaryColor,
        backgroundColor: AppColors.kPrimaryColor,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void selectStore(StoreEntity store) {
    selectedStore.value = store;
  }

  // Method to clear selected store on logout if needed
  void clearSelection() {
    selectedStore.value = null;
  }
}
