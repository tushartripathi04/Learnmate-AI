import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  Future<void> saveChat({
    required String userId,
    required String question,
    required String answer,
  }) async {
    await FirebaseFirestore.instance
        .collection('chat_history')
        .add({
      'userId': userId,
      'question': question,
      'answer': answer,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}