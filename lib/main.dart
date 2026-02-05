import 'package:coffee_app/core/constants/app_colors.dart';
import 'package:coffee_app/firebase_options.dart';
import 'package:coffee_app/routes/pages.dart';
import 'package:coffee_app/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
    initialRoute: AppRoutes.kSplashRoute,
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
