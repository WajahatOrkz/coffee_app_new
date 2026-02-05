import 'package:coffee_app/core/constants/app_colors.dart';
import 'package:coffee_app/core/validation/validations.dart';
import 'package:coffee_app/features/auth/domain/repositories/auth_repositories.dart';

import 'package:coffee_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameFocusNode=FocusNode();
   final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  final isLoading = false.obs;
  final isGoogleLoading=false.obs;
  final isPasswordVisible = false.obs;
  final agreeToTerms = false.obs;

  final AuthRepository repository = Get.find<AuthRepository>();

  @override
  void onInit() {
    super.onInit();
    // signUpFormKey = GlobalKey<FormState>();
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

  Future<void> register(GlobalKey<FormState> signUpFormKey) async {
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

      final userEntity = await repository.register(
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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();

    super.onClose();
  }
}
