import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestion = 0;
  int score = 0;

  final List<Map<String, dynamic>> questions = [
    {
      "question": "What is Flutter?",
      "options": [
        "Database",
        "Framework",
        "Operating System",
        "Compiler"
      ],
      "answer": "Framework"
    },
    {
      "question": "Who developed Flutter?",
      "options": [
        "Microsoft",
        "Apple",
        "Google",
        "Amazon"
      ],
      "answer": "Google"
    },
    {
      "question": "Which language is used in Flutter?",
      "options": [
        "Java",
        "Python",
        "Dart",
        "C++"
      ],
      "answer": "Dart"
    },
    {
      "question": "Firebase is a?",
      "options": [
        "Database Platform",
        "Programming Language",
        "Operating System",
        "IDE"
      ],
      "answer": "Database Platform"
    },
    {
      "question": "AI stands for?",
      "options": [
        "Artificial Intelligence",
        "Automatic Internet",
        "Advanced Integration",
        "Application Interface"
      ],
      "answer": "Artificial Intelligence"
    },
  ];

  Future<void> saveQuizResult() async {
    try {
      await FirebaseFirestore.instance
          .collection("quiz_results")
          .add({
        "userId":
        FirebaseAuth.instance.currentUser?.uid,
        "score": score,
        "totalQuestions": questions.length,
        "timestamp":
        FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Quiz Save Error: $e");
    }
  }

  Future<void> answerQuestion(
      String selectedAnswer) async {

    if (selectedAnswer ==
        questions[currentQuestion]["answer"]) {
      score++;
    }

    if (currentQuestion <
        questions.length - 1) {

      setState(() {
        currentQuestion++;
      });

    } else {

      await saveQuizResult();

      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20),
          ),
          title: const Text(
            "🎉 Quiz Completed",
          ),
          content: Text(
            "Your Score: $score/${questions.length}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {

                Navigator.pop(context);

                setState(() {
                  currentQuestion = 0;
                  score = 0;
                });
              },
              child: const Text(
                "Restart Quiz",
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final question =
    questions[currentQuestion];

    return Scaffold(
      backgroundColor:
      const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: const Text("Quiz"),
        centerTitle: true,
        backgroundColor:
        const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            LinearProgressIndicator(
              value: (currentQuestion + 1) /
                  questions.length,
              color:
              const Color(0xFF4F46E5),
              backgroundColor:
              Colors.grey.shade300,
            ),

            const SizedBox(height: 20),

            Text(
              "Question ${currentQuestion + 1}/${questions.length}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 4,
              shape:
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(15),
              ),
              child: Padding(
                padding:
                const EdgeInsets.all(20),
                child: Text(
                  question["question"],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: ListView(
                children: question["options"]
                    .map<Widget>(
                      (option) =>
                      Container(
                        margin:
                        const EdgeInsets.only(
                          bottom: 15,
                        ),
                        child:
                        ElevatedButton(
                          onPressed: () =>
                              answerQuestion(
                                  option),

                          style:
                          ElevatedButton
                              .styleFrom(
                            padding:
                            const EdgeInsets
                                .all(18),
                            backgroundColor:
                            Colors.white,
                            foregroundColor:
                            Colors.black,
                            elevation: 3,
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius
                                  .circular(
                                  15),
                            ),
                          ),

                          child: Text(
                            option,
                            style:
                            const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}