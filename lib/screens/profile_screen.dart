import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'about_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 30,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF4F46E5),
                    Color(0xFF06B6D4),
                  ],
                ),
              ),

              child: Column(
                children: [

                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Color(0xFF4F46E5),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    user?.email ?? "Student",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    "LearnMateAI User",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Column(
                children: [

                  ListTile(
                    leading: const Icon(
                      Icons.email,
                      color: Color(0xFF4F46E5),
                    ),
                    title: const Text("Email"),
                    subtitle: Text(
                      user?.email ?? "Not Available",
                    ),
                  ),

                  const Divider(),

                  ListTile(
                    leading: const Icon(
                      Icons.info,
                      color: Color(0xFF4F46E5),
                    ),
                    title: const Text("About App"),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const AboutScreen(),
                        ),
                      );
                    },
                  ),

                  const Divider(),

                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    title: const Text("Logout"),
                    onTap: () => logout(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}