import 'package:coffee_app/core/constants/app_colors.dart';
import 'package:coffee_app/core/services/user_services.dart';
import 'package:coffee_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogoutController extends GetxController {
  final AuthRepository repository = Get.find<AuthRepository>();
  final UserService userService = Get.find<UserService>();
  
  final isLoading = false.obs;

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await Future.delayed(Duration(seconds: 2));
      await repository.logout();
      
      Get.snackbar(
        'Logged Out',
        'Successfully logged out',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.kPrimaryColor,
        colorText: Colors.white,
      );
      
     
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Logout failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}