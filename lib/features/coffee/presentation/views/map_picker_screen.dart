import 'package:coffee_app/core/constants/app_colors.dart';
import 'package:coffee_app/features/coffee/presentation/controllers/map_picker_controller.dart';
import 'package:coffee_app/features/auth/presentation/widgets/custom_loader.dart'; // ✅ Import CustomLoader
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerScreen extends GetView<MapPickerController> {
  const MapPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Pick Store Location",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // ✅ Map hamesha render hoti rahe, kabhi conditionally remove mat karo
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: MapPickerController.kDefaultPosition,
            onMapCreated: controller.onMapCreated,
            markers: Set<Marker>.from(controller.markers),
            onTap: controller.onMapTapped,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),

          // ✅ Loading spinner map ke upar overlay ke taur pe
          Obx(() {
            if (controller.isLoading.value) {
              return Container(
                color: Colors.black,
                child: const Center(
                  child: CustomLoader(),
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // ✅ Bottom address + button - sirf tab dikhao jab loading nahi ho
          Obx(() {
            if (controller.isLoading.value) return const SizedBox.shrink();
            return Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Obx(
                      () => Text(
                        controller.address.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.confirmSelection,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kPrimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Confirm Location",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
