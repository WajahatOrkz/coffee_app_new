import 'package:coffee_app/core/constants/app_colors.dart';
import 'package:coffee_app/features/coffee/presentation/controllers/login.dart';
import 'package:coffee_app/features/coffee/presentation/widgets/custom_button.dart';
import 'package:coffee_app/features/coffee/presentation/widgets/custom_textfield.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/routes.dart';



class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'CoffeeMart',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.kPrimaryColor,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.kPrimaryColor,
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Form(
                  key: controller.logInFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Welcome to\nCoffeeMart login now!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 32),
                  
                      // Email Field using Custom Widget
                      CustomTextField(
                        label: 'Email',
                        hintText: 'ali@gmail.com',
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator:controller.validateEmail,
                      ),
                      const SizedBox(height: 20),
                  
                      // Password Field using Custom Widget with Toggle
                      Obx(
                        () => CustomTextField(
                          label: 'Password',
                          hintText: '*Waja1234',
                          controller: controller.passwordController,
                          obscureText: !controller.isPasswordVisible.value,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                          validator: controller.validatePassword,
                        ),
                      ),
                      const SizedBox(height: 12),
                  
                      // Remember & Forgot Password
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Checkbox(
                                    value: controller.rememberMe.value,
                                    onChanged:(Value)=> controller.toggleRememberMe(),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    activeColor: AppColors.kPrimaryColor,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Remember me',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Forget password?',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.kPrimaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                  
                      // Login Button using Custom Widget
                      Obx(
                        () => CustomButton(
                          text: 'Login',
                          onPressed: controller.login,
                          isLoading: controller.isLoading.value,
                          backgroundColor: AppColors.kPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                  
                      // Or Sign in with
                      Text(
                        'Or Sign in with',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                  
                      // Social Login Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                         
                          const SizedBox(width: 16),
                          _SocialButton(
                            icon: Icons.g_mobiledata,
                            onPressed: () {},
                          ),
                          const SizedBox(width: 16),
                          _SocialButton(
                            icon: Icons.apple,
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                  
                      // Don't have an account? Sign up
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              print("click ho rahi");
                            Get.toNamed(AppRoutes.kSignUpRoute);
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.kPrimaryColor,
                              
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, size: 24,color: Colors.white,),
        onPressed: onPressed,
      ),
    );
  }
}