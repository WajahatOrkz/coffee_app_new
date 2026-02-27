


import 'package:coffee_app/core/theme/app_colors.dart';

import 'package:coffee_app/core/services/user_services.dart';
import 'package:coffee_app/firebase_options.dart';
import 'package:coffee_app/routes/pages.dart';
import 'package:coffee_app/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:coffee_app/core/services/push_notification_service.dart';
import 'package:get/get.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  // Initialize PushNotificationService 
  await Get.putAsync(() => PushNotificationService().init());

  // ✅ UserService ko globally initialize karo
  Get.put(UserService(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppRoutes.kSplashRoute,
      getPages: AppPages.routes,
      defaultTransition: Transition.noTransition,
      debugShowCheckedModeBanner: false,
      title: 'Coffee App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: AppColors.black,
      ),
    );
  }
}