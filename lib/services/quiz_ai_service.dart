import 'dart:convert';
import 'package:http/http.dart' as http;

class QuizAIService {

  static const String apiKey =
      "ENTER YOUR API KEY";

  Future<List<dynamic>> generateQuiz(
      String domain) async {

    final response = await http.post(
      Uri.parse(
        "https://api.groq.com/openai/v1/chat/completions",
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization":
        "Bearer $apiKey",
      },
      body: jsonEncode({
        "model":
        "llama-3.3-70b-versatile",
        "messages": [
          {
            "role": "user",
            "content":
            """
Generate exactly 20 MCQ questions about $domain.

Return ONLY valid JSON.

Example:

[
 {
  "question":"What is Flutter?",
  "options":[
   "Framework",
   "Database",
   "OS",
   "Compiler"
  ],
  "answer":"Framework"
 }
]

No explanation.
No markdown.
No extra text.
"""
          }
        ]
      }),
    );

    if (response.statusCode == 200) {

      final data =
      jsonDecode(response.body);

      final content =
      data["choices"][0]
      ["message"]["content"];

      try {
        return jsonDecode(content);
      } catch (_) {
        throw Exception(
          "AI returned invalid JSON",
        );
      }
    }

    throw Exception(
      "Failed to generate quiz",
    );
  }
}