import 'package:coffee_app/core/theme/app_colors.dart';
import 'package:coffee_app/features/chat/presentation/views/contacts.dart';
import 'package:coffee_app/features/coffee/presentation/views/coffee_home.dart';
import 'package:coffee_app/features/main/presentation/controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends GetView<MainController> {
  final List<Widget> pages = [
    CoffeeHomeView(),
    const ContactsScreen(),
  ];

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: pages,
          )),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: AppColors.background,
          selectedItemColor: AppColors.kPrimaryColor,
          unselectedItemColor: Colors.grey,
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.coffee),
              label: 'Coffee',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
          ],
        ),
      ),
    );
  }
}
