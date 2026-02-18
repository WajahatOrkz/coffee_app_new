import 'package:coffee_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:coffee_app/features/coffee/presentation/controllers/store_controller.dart';
import 'package:coffee_app/features/coffee/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class showAddStoreDialog extends GetView<StoreController> {
  const showAddStoreDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add New Store',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            CustomTextField(
              controller: controller.nameController,
              hintText: 'Store Name',
              label: "store name",
              prefixIcon: Icons.store,
            ),
            SizedBox(height: 12),
            CustomTextField(
              controller: controller.addressController,
              hintText: 'Store Location',
              label: "Store Location",

              suffixIcon: IconButton(
                icon: Icon(Icons.location_on, color: Colors.blue),
                onPressed: () => controller.pickLocation(),
              ),
            ),
            SizedBox(height: 24),
            CustomButton(
              text: "Add Store",

              onPressed: () => controller.addStore(),
            ),
          ],
        ),
      ),
    );
  }
}
