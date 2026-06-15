import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../services/ai_service.dart';
// import '../services/firestore_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller =
  TextEditingController();

  final AIService aiService = AIService();

  // final FirestoreService firestoreService =
  // FirestoreService();

  final SpeechToText speechToText =
  SpeechToText();

  final FlutterTts flutterTts =
  FlutterTts();

  String response = "";

  bool loading = false;

  bool isListening = false;

  Future<void> askQuestion() async {
    if (controller.text.trim().isEmpty) return;

    final question = controller.text.trim();

    setState(() {
      loading = true;
      response = "";
    });

    try {
      final result =
      await aiService.askAI(question);

      // await firestoreService.saveChat(
      //   userId:
      //   FirebaseAuth.instance.currentUser!.uid,
      //   question: question,
      //   answer: result,
      // );

      setState(() {
        response = result;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        response = "Error: $e";
      });
    }
  }

  Future<void> startListening() async {
    bool available =
    await speechToText.initialize();

    if (available) {
      setState(() {
        isListening = true;
      });

      speechToText.listen(
        onResult: (result) {
          setState(() {
            controller.text =
                result.recognizedWords;
          });
        },
      );
    }
  }

  Future<void> stopListening() async {
    await speechToText.stop();

    setState(() {
      isListening = false;
    });
  }

  Future<void> speakAnswer() async {
    if (response.isNotEmpty) {
      await flutterTts.setLanguage(
          "en-US");

      await flutterTts.setPitch(1.0);

      await flutterTts.speak(response);
    }
  }

  Future<void> stopSpeaking() async {
    await flutterTts.stop();
  }

  @override
  void dispose() {
    controller.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: const Text(
          "LearnMateAI Chat",
        ),
        backgroundColor:
        const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: controller,
              maxLines: 3,

              decoration: InputDecoration(
                hintText:
                "Ask anything...",

                filled: true,
                fillColor: Colors.white,

                suffixIcon: IconButton(
                  icon: Icon(
                    isListening
                        ? Icons.mic
                        : Icons.mic_none,
                    color: const Color(
                        0xFF4F46E5),
                  ),

                  onPressed: () {
                    if (isListening) {
                      stopListening();
                    } else {
                      startListening();
                    }
                  },
                ),

                border:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(
                      15),
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed:
                loading ? null : askQuestion,

                icon: const Icon(
                  Icons.send,
                ),

                label:
                const Text("Ask AI"),

                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(
                      0xFF4F46E5),
                  foregroundColor:
                  Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (loading)
              const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text(
                    "Thinking...",
                  ),
                ],
              ),

            if (!loading)
              Expanded(
                child: Container(
                  width: double.infinity,

                  padding:
                  const EdgeInsets.all(
                      15),

                  decoration:
                  BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius
                        .circular(
                        15),

                    boxShadow: const [
                      BoxShadow(
                        color:
                        Colors.black12,
                        blurRadius: 6,
                      )
                    ],
                  ),

                  child:
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [

                        const Text(
                          "AI Response",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                            FontWeight
                                .bold,
                          ),
                        ),

                        const SizedBox(
                            height: 10),

                        Text(
                          response.isEmpty
                              ? "Ask a question to get started."
                              : response,
                          style:
                          const TextStyle(
                            fontSize: 16,
                          ),
                        ),

                        if (response
                            .isNotEmpty)
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .end,
                            children: [

                              IconButton(
                                onPressed:
                                speakAnswer,
                                icon:
                                const Icon(
                                  Icons
                                      .volume_up,
                                  color: Color(
                                      0xFF4F46E5),
                                ),
                              ),

                              IconButton(
                                onPressed:
                                stopSpeaking,
                                icon:
                                const Icon(
                                  Icons.stop,
                                  color:
                                  Colors.red,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}