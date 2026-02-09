import 'package:coffee_app/core/constants/app_colors.dart';
import 'package:coffee_app/core/validation/validations.dart';
import 'package:coffee_app/features/auth/domain/repositories/auth_repository.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  final isLoading = false.obs;
  final isGoogleLoading = false.obs;
  final isPasswordVisible = false.obs;
  final rememberMe = false.obs;

  final AuthRepository repository = Get.find<AuthRepository>();

  @override
  void onInit() {
    super.onInit();
  }

  bool togglePasswordVisibility() {
    return isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  String? validateEmail(String? value) {
    return Validators.validateEmail(value);
  }

  String? validatePassword(String? value) {
    return Validators.validateLoginPassword(value);
  }

  //  login function yahan hai
  Future<void> login(GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      try {
        isLoading.value = true;
        final userEntity = await repository.login(
          emailController.text.trim(),
          passwordController.text,
        );
        // Ye print karke dekho
        print('Full User Entity: $userEntity');
        print('User Name: ${userEntity.name}');
        print('User Email: ${userEntity.email}');

        // Get.snackbar(
        //   'Success',
        //   'Welcome ${userEntity.name}!',
        //   backgroundColor: AppColors.kPrimaryColor,
        //   colorText: Colors.white,
        //   snackPosition: SnackPosition.BOTTOM,
        // );
      } catch (e) {
        Get.snackbar(
          'Login Failed',
          e.toString().replaceAll('Exception: ', ''),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        isLoading.value = false;
      }
    } else {
      print("Form Validation Failed");
    }
  }

  // Google Sign-In Method
  Future<void> signInWithGoogle() async {
    try {
      isGoogleLoading.value = true;
      final userEntity = await repository.signInWithGoogle();

      print('Google Sign-In Successful');
      print('User Name: ${userEntity.name}');
      print('User Email: ${userEntity.email}');

      Get.snackbar(
        'Success',
        'Welcome ${userEntity.name}!',
        backgroundColor: AppColors.kPrimaryColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print(e);
      Get.snackbar(
        'Google Sign-In Failed',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isGoogleLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
    print("onclosen");
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
