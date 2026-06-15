import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;

  Future<void> addNote() async {

    if (titleController.text.isEmpty ||
        contentController.text.isEmpty) {
      return;
    }

    await FirebaseFirestore.instance
        .collection('notes')
        .add({
      'title': titleController.text.trim(),
      'content': contentController.text.trim(),
      'userId': user!.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });

    titleController.clear();
    contentController.clear();

    if (!mounted) return;
    Navigator.pop(context);
  }

  void showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Note"),
        content: SingleChildScrollView(
          child: Column(
            children: [

              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Title",
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: contentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: "Content",
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: addNote,
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> deleteNote(String id) async {
    await FirebaseFirestore.instance
        .collection('notes')
        .doc(id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: showAddNoteDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('notes')
            .where('userId',
            isEqualTo: user?.uid)
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final notes = snapshot.data!.docs;

          if (notes.isEmpty) {
            return const Center(
              child: Text("No Notes Yet"),
            );
          }

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {

              final note = notes[index];

              return Card(
                margin: const EdgeInsets.all(10),

                child: ListTile(
                  title: Text(note['title']),
                  subtitle: Text(note['content']),

                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () =>
                        deleteNote(note.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}