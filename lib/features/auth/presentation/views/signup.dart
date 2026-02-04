import 'package:coffee_app/core/constants/app_colors.dart';
import 'package:coffee_app/features/auth/presentation/controllers/signup_controller.dart';
import 'package:coffee_app/features/coffee/presentation/widgets/custom_button.dart';
import 'package:coffee_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
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
          ),
          body: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(20),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.kPrimaryColor.withOpacity(0.6),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Form(
                  key: controller.signUpFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                        'Create an Account?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Name Field using Custom Widget
                      CustomTextField(
                        label: 'Name',
                        hintText: 'Ahmed khan',
                        controller: controller.nameController,
                        validator: controller.validateName,
                      ),
                      const SizedBox(height: 20),

                      // Email Field using Custom Widget
                      CustomTextField(
                        label: 'Email',
                        hintText: 'ali@gmail.com',
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: controller.validateEmail,
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
                      const SizedBox(height: 16),

                      // Terms Checkbox
                      Row(
                        children: [
                          Obx(
                            () => SizedBox(
                              height: 20,
                              width: 20,
                              child: Checkbox(
                                value: controller.agreeToTerms.value,
                                onChanged: (val) => controller.toggleTerms(),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                activeColor: AppColors.kPrimaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'I agree to the Terms of Service',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Create Account Button using Custom Widget
                      Obx(
                        () => CustomButton(
                          text: 'Create account',
                          onPressed: controller.register,
                          isLoading: controller.isLoading.value,
                          backgroundColor: AppColors.kPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Or Sign in with
                      Text(
                        'Or Sign in with',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
                          _SocialButton(icon: Icons.apple, onPressed: () {}),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Already have an account? Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Text(
                              'Login',
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

  const _SocialButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      // putting icon button inside container
      child: IconButton(
        icon: Icon(icon, size: 24, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}
