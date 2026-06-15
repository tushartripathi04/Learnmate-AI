import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatHistoryScreen extends StatelessWidget {
  const ChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final user =
        FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat History"),
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat_history')
            .where(
          'userId',
          isEqualTo: user?.uid,
        )
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final chats = snapshot.data!.docs;

          if (chats.isEmpty) {
            return const Center(
              child: Text(
                "No Chat History",
              ),
            );
          }

          return ListView.builder(
            itemCount: chats.length,

            itemBuilder: (context, index) {

              final chat = chats[index];

              return Card(
                margin:
                const EdgeInsets.all(10),

                child: ListTile(
                  title:
                  Text(chat['question']),
                  subtitle:
                  Text(chat['answer']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}