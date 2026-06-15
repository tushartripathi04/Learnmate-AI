import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardService {

  final String userId =
      FirebaseAuth.instance.currentUser!.uid;

  Future<int> getNotesCount() async {

    final snapshot =
    await FirebaseFirestore.instance
        .collection('notes')
        .where('userId',
        isEqualTo: userId)
        .get();

    return snapshot.docs.length;
  }

  Future<int> getQuizCount() async {

    final snapshot =
    await FirebaseFirestore.instance
        .collection('quiz_results')
        .where('userId',
        isEqualTo: userId)
        .get();

    return snapshot.docs.length;
  }

  Future<int> getBestScore() async {

    final snapshot =
    await FirebaseFirestore.instance
        .collection('quiz_results')
        .where('userId',
        isEqualTo: userId)
        .get();

    int best = 0;

    for (var doc in snapshot.docs) {

      int score =
          doc['score'] ?? 0;

      if (score > best) {
        best = score;
      }
    }

    return best;
  }

  Future<int> getChatCount() async {

    final snapshot =
    await FirebaseFirestore.instance
        .collection('chat_history')
        .where('userId',
        isEqualTo: userId)
        .get();

    return snapshot.docs.length;
  }
}