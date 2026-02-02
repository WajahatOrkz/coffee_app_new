import 'package:coffee_app/core/validation/validations.dart';
import 'package:coffee_app/features/coffee/domain/repositories/auth_repositories.dart';
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

   
  String? validateEmail(String? value) {
    return Validators.validateEmail(value);
  }

  
  String? validatePassword(String? value) {
    return Validators.validateLoginPassword(value);
  }
 
//  login function yahan hai
  Future<void> login() async {
    
    if (logInFormKey.currentState!.validate()) {
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
       ;
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
    
      print("Form Validation Failed");
    }
  }

  Future<void> logout()async{
   await repository.logout();
  }




  @override
  void onClose() {
    super.onClose();
    print("onclosen");
    emailController.dispose();
    passwordController.dispose();
   
  }
}