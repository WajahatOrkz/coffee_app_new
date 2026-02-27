import 'package:coffee_app/features/chat/domain/entities/message_entity.dart';

abstract class ChatRepository {
  Stream<List<MessageEntity>> getMessages(String chatId);
  Future<void> sendMessage(String chatId, MessageEntity message);
}