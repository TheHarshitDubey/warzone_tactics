import 'package:flutter/material.dart';
import 'package:warzone_tactics/services/auth_services.dart';

import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/war_bg.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Login",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFFFFF))),
                    const SizedBox(height: 20),
                    TextField(
                      style: TextStyle(color: Colors.white),
                      controller: emailController,
                      decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14))),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      style: TextStyle(color: Colors.white),
                      controller: passwordController,
                      decoration: InputDecoration(
                          labelText: "Password",
                          
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14))),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await _authService.login(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Login Error: $e")),
                          );
                        }
                      },
                      child: const Text("Login"),
                    ),
                    SizedBox(height: 8,),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignupScreen(),
                          ),
                        );
                      },
                      child: const Text("Create Account"),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.85),
          ),
        ],
      ),
    );
  }
}
