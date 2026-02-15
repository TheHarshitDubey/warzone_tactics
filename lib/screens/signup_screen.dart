import 'package:flutter/material.dart';
import 'package:warzone_tactics/screens/auth_wrapper.dart';
import 'package:warzone_tactics/services/auth_services.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
                    const Text("Signup", style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,
                            color: Color(0xFFFFFFFF))),
                    const SizedBox(height: 20),
              
                    TextField(
                       style: TextStyle(color: Colors.white),
                      controller: emailController,
                      decoration:  InputDecoration(labelText: "Email",labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14))),
                    ),
                    SizedBox(height: 15,),
              
                    TextField(
                       style: TextStyle(color: Colors.white),
                      controller: passwordController,
                      decoration:  InputDecoration(labelText: "Password",labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14))),
                      obscureText: true,
                    ),
              
                    const SizedBox(height: 20),
              
                    ElevatedButton(
                onPressed: () async {
                  try {
              await _authService.signUp(
                emailController.text.trim(),
                passwordController.text.trim(),
              );
              
              
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const AuthWrapper(),
                ),
                (route) => false,
              );
                  } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Signup Error: $e")),
              );
                  }
                },
                child: const Text("Sign Up"),
              ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.65),
          ),
        ],
      ),
      
    );
  }
}