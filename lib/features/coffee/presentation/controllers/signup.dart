import 'package:coffee_app/core/constants/app_colors.dart';
import 'package:coffee_app/core/validation/validations.dart';
import 'package:coffee_app/features/coffee/domain/repositories/auth_repositories.dart';
import 'package:coffee_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final agreeToTerms = false.obs;
 late final GlobalKey<FormState> signUpFormKey;

  final AuthRepository _repository = Get.find<AuthRepository>();

  @override
  void onInit() {
    super.onInit();
    signUpFormKey = GlobalKey<FormState>();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleTerms() {
    agreeToTerms.value = !agreeToTerms.value;
  }

 // Name validator
  String? validateName(String? value) {
    return Validators.validateName(value);
  }

  // Email validator
  String? validateEmail(String? value) {
    return Validators.validateEmail(value);
  }

  // Strong password validator for signup
  String? validatePassword(String? value) {
    return Validators.validateSignupPassword(value);
  }

  // Confirm password validator
  // String? validateConfirmPassword(String? value) {
  //   return Validators.validateConfirmPassword(
  //     value,
  //     passwordController.text,
  //   );
  // }


 Future<void> register() async {
    // Validate form
    if (!signUpFormKey.currentState!.validate()) {
      return;
    }

    if (!agreeToTerms.value) {
      Get.snackbar(
        'Terms Required',
        'Please agree to Terms of Service',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      
      final userEntity = await _repository.register(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text,
      );

      Get.snackbar(
        'Success',
        'Account created for ${userEntity.name}!',
        backgroundColor: AppColors.kPrimaryColor,
        colorText: Colors.white,
      );

      // Navigate to home screen
      Get.toNamed(AppRoutes.kHomeCoffeeRoute);
    } catch (e) {
      Get.snackbar(
        'Registration Failed',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // void navigateToLogin() {
  //   Get.back();
  // }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}