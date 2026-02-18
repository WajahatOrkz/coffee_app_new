import 'package:coffee_app/core/constants/app_colors.dart';
import 'package:coffee_app/features/coffee/domain/entities/store_entity.dart';
import 'package:coffee_app/features/coffee/domain/repositories/firestore_repository.dart';
import 'package:coffee_app/features/coffee/domain/repositories/coffee_repository.dart'; // ✅ Import this
import 'package:coffee_app/routes/routes.dart'; // ✅ Import Routes
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreController extends GetxController {
  final FirestoreRepository repository;
  final CoffeeRepository coffeeRepository;

  StoreController({required this.repository, required this.coffeeRepository});

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

      if (loadedStores.isEmpty) {
        print("No stores found. Seeding default data...");
        await coffeeRepository.seedData();
        stores.value = await repository.getStores();
      } else {
        stores.value = loadedStores;
      }
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
        latitude: selectedLat.value,
        longitude: selectedLng.value,
      );

      await repository.addStore(newStore);

      nameController.clear();
      addressController.clear();
      selectedLat.value = null;
      selectedLng.value = null;
      Get.back(); // Close dialog

      await loadStores();
      // Get.snackbar(
      //   'Success',
      //   'Store added successfully',
      //   colorText: AppColors.kPrimaryColor,
      //   backgroundColor: AppColors.kPrimaryColor,
      // );
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

  final selectedLat = Rxn<double>();
  final selectedLng = Rxn<double>();

  void pickLocation() async {
    final result = await Get.toNamed(AppRoutes.kMapPickerRoute);
    if (result != null && result is Map) {
      addressController.text = result['address'];
      selectedLat.value = result['lat'];
      selectedLng.value = result['lng'];
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
