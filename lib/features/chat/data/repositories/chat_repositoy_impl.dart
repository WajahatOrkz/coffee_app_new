import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/features/chat/domain/entities/message_entity.dart';
import 'package:coffee_app/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirebaseFirestore firestore;

  ChatRepositoryImpl(this.firestore);

  @override
  Stream<List<MessageEntity>> getMessages(String chatId) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => MessageEntity(
              id: doc.id,
              senderId: doc['senderId'],
              text: doc['text'],
              timestamp: (doc['timestamp'] as Timestamp).toDate(),
            )).toList());
  }

  @override
  Future<void> sendMessage(String chatId, MessageEntity message) {
    return firestore.collection('chats').doc(chatId).collection('messages').add({
      'senderId': message.senderId,
      'text': message.text,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}