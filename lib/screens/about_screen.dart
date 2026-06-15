import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: const Text("About LearnMateAI"),
        centerTitle: true,
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            const Icon(
              Icons.school,
              size: 90,
              color: Color(0xFF4F46E5),
            ),

            const SizedBox(height: 15),

            const Text(
              "LearnMateAI",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Version 1.0",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),

            Card(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Developer",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text("Tushar"),

                    SizedBox(height: 20),

                    Text(
                      "Technologies Used",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text("• Flutter"),
                    Text("• Firebase Authentication"),
                    Text("• Cloud Firestore"),
                    Text("• Groq AI"),
                    Text("• Speech To Text"),
                    Text("• Text To Speech"),

                    SizedBox(height: 20),

                    Text(
                      "Project Description",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "LearnMateAI is an AI-powered learning assistant designed for students. It provides AI chat support, voice interaction, note management, quizzes, and personalized learning assistance.",
                    ),

                    SizedBox(height: 20),

                    Text(
                      "Future Scope",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text("• AI Generated Quizzes"),
                    Text("• Personalized Learning"),
                    Text("• Voice Assistant"),
                    Text("• Mock Interviews"),
                    Text("• Learning Analytics"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}