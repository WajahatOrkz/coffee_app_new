import 'package:coffee_app/core/constants/app_colors.dart';
import 'package:coffee_app/features/auth/presentation/controllers/splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends GetView<SplashController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_cafe,
              size: 100,
              // color: Colors.brown[800],
              color: AppColors.kPrimaryColor,
            ),
            SizedBox(height: 20),
            Text(
              "Coffee App",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(
              // color: Colors.brown[700],
              color: AppColors.kPrimaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
