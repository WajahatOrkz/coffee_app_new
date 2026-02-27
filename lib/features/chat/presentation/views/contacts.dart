import 'package:coffee_app/core/theme/app_colors.dart';
import 'package:coffee_app/features/chat/presentation/controller/contacts_controller.dart';
import 'package:coffee_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactsScreen extends GetView<ContactsController> {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: AppColors.white),
        ),
        title: const Text('Contacts', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.contacts.isEmpty) {
          return const Center(
            child: Text(
              "No contacts available",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.contacts.length,
          itemBuilder: (context, index) {
            final contact = controller.contacts[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(contact.avatarUrl),
                radius: 25,
              ),
              title: Text(
                contact.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'Tap to chat',
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                Get.toNamed(
                  AppRoutes.kChatRoute,
                  arguments: {
                    'chatId': contact.id,
                    'currentUserId':
                        'dummy_user', // Using dummy user as per initial implementation
                    'contactName': contact.name,
                  },
                );
              },
            );
          },
        );
      }),
    );
  }
}
