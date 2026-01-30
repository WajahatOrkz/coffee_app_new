import 'package:coffee_app/core/constants/app_colors.dart';
import 'package:coffee_app/routes/pages.dart';
import 'package:coffee_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
    initialRoute: AppRoutes.kLoginRoute,
      getPages: AppPages.routes,
      defaultTransition: Transition.noTransition,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: AppColors.black
      ),
      
    );
  }
}
