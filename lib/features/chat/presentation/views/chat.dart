import 'package:coffee_app/core/theme/app_colors.dart';
import 'package:coffee_app/features/chat/presentation/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
        title: Text(
          Get.arguments?['contactName'] ?? "Chat",
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.background,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                reverse: true,
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  bool isMe = message.senderId == controller.currentUserId;
                  return Align(
                    alignment: isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(message.text),
                    ),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.textController,
                    decoration: InputDecoration(hintText: 'Type a message...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: controller.sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
