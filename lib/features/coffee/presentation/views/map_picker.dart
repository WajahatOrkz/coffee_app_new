import 'package:coffee_app/core/theme/app_colors.dart';
import 'package:coffee_app/features/coffee/coffee_strings.dart';

import 'package:coffee_app/features/coffee/presentation/controllers/map_picker_controller.dart';
import 'package:coffee_app/features/auth/presentation/widgets/custom_loader.dart'; // ✅ Import CustomLoader
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerScreen extends GetView<MapPickerController> {
  const MapPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          CoffeeStrings.pickStoreLocation,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.transparent,
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: MapPickerController.kDefaultPosition,
            onMapCreated: controller.onMapCreated,
            markers: Set<Marker>.from(controller.markers),
            onTap: controller.onMapTapped,
            myLocationEnabled: true,
            buildingsEnabled: true,

            myLocationButtonEnabled: true,
          ),

          Obx(() {
            if (controller.isLoading.value) {
              return Container(
                color: Colors.black,
                child: const Center(child: CustomLoader()),
              );
            }
            return const SizedBox.shrink();
          }),

          Obx(() {
            if (controller.isLoading.value) return const SizedBox.shrink();
            return Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.location_on_outlined, color: Colors.white70, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Obx(
                                () => Text(
                                  controller.address.value,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: controller.confirmSelection,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kPrimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 8,
                      shadowColor: AppColors.kPrimaryColor.withOpacity(0.5),
                      shape: const StadiumBorder(),
                    ),
                    icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                    label: const Text(
                      "Confirm Location",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
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
