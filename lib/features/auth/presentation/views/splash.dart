import 'package:coffee_app/features/auth/presentation/controllers/splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SplashScreen extends GetView<SplashController> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50], // Coffee feel ke liye soft background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_cafe, // Flutter ka coffee icon
              size: 100,
              color: Colors.brown[800],
            ),
            SizedBox(height: 20),
            Text(
              "Coffee App",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.brown[900],
              ),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(
              color: Colors.brown[700],
            ),
          ],
        ),
      ),
    );
  }
}
