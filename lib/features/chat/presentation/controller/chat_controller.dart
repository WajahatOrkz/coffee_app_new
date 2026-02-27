import 'package:coffee_app/features/chat/domain/entities/message_entity.dart';
import 'package:coffee_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ChatController extends GetxController {
  final ChatRepository repository;
  final String chatId;
  final String currentUserId;

  ChatController({required this.repository, required this.chatId, required this.currentUserId});

  var messages = <MessageEntity>[].obs;
  TextEditingController textController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    repository.getMessages(chatId).listen((event) {
      messages.value = event;
    });
  }

  void sendMessage() {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    final message = MessageEntity(
      id: '', 
      senderId: currentUserId,
      text: text,
      timestamp: DateTime.now(),
    );

    repository.sendMessage(chatId, message);
    textController.clear();
  }
}