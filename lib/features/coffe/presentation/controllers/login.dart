import 'package:coffee_app/features/coffe/domain/repositories/auth_repositories.dart';
import 'package:coffee_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final rememberMe = false.obs;
 late final GlobalKey<FormState> logInFormKey;

  final AuthRepository repository = Get.find<AuthRepository>();

  @override
  void onInit() {
    super.onInit();
    logInFormKey = GlobalKey<FormState>();
  }

  bool togglePasswordVisibility() {
    return isPasswordVisible.value = !isPasswordVisible.value;
    
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  Future<void> login() async {
    
    if (logInFormKey.currentState!.validate()) {
      try {
        isLoading.value = true;
        
        final userEntity = await repository.login(
          emailController.text.trim(),
          passwordController.text,
        );

        Get.snackbar(
          'Success',
          'Welcome ${userEntity.name}!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.toNamed(AppRoutes.kHomeCoffeeRoute);
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
      // Agar validation fail hui to yahan kuch karne ki zaroorat nahi, 
      // TextFormField khud error dikha dega.
      print("Form Validation Failed");
    }
  }

  // 

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}