import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/features/chat/data/repositories/chat_repositoy_impl.dart';
import 'package:coffee_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:coffee_app/features/chat/presentation/controller/chat_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class ChatBinding extends Bindings {
  final String chatId;
  final String currentUserId;

  ChatBinding({required this.chatId, required this.currentUserId});

  @override
  void dependencies() {
    Get.lazyPut<ChatRepository>(() => ChatRepositoryImpl(FirebaseFirestore.instance));
    Get.lazyPut<ChatController>(() => ChatController(
          repository: Get.find<ChatRepository>(),
          chatId: chatId,
          currentUserId: currentUserId,
        ));
  }
}