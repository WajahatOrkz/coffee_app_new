import 'package:coffee_app/core/constants/app_colors.dart';
import 'package:coffee_app/features/auth/presentation/widgets/custom_loader.dart'; // ✅ Import CustomLoader

import 'package:coffee_app/features/coffee/presentation/controllers/store_controller.dart';
import 'package:coffee_app/routes/routes.dart';

import 'package:coffee_app/features/coffee/presentation/widgets/custom_store_dialog.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreSelectionView extends GetView<StoreController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Select Store', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: AppColors.kPrimaryColor),
            onPressed: () {
              Get.dialog(showAddStoreDialog());
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CustomLoader(), // ✅ Use CustomLoader
          );
        }

        if (controller.stores.isEmpty) {
          return Center(
            child: Text(
              'No stores available.\nPlease add a store.',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: controller.stores.length,
          itemBuilder: (context, index) {
            final store = controller.stores[index];
            return Card(
              color: Color(0xFF1A1A1A),
              margin: EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  store.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  store.address,
                  style: TextStyle(color: Colors.grey[500]),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.kPrimaryColor,
                  size: 16,
                ),
                onTap: () {
                  controller.selectStore(store);
                  Get.toNamed(AppRoutes.kHomeCoffeeRoute);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
