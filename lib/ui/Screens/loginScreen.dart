// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:path_provider/path_provider.dart';
import '../data/authUtils.dart';
import '../widgets/animated logo.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);
  }

  // Future<void> clearStoredData() async {
  //   // Clear user authentication data
  //   await _auth.signOut();

  //   // Clear stored data in SharedPreferences
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.clear();

  //   // Clear all data from the device storage
  //   final Directory directory = await getApplicationDocumentsDirectory();
  //   await directory.delete(recursive: true);

  //   // Show a snackbar indicating data has been cleared
  //   if (mounted) {}
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Data cleared')),
  //   );
  // }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedLogo(
            animationController: _animationController,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  isLoading = true;
                  AuthUtils(context: context).signInWithGoogle(role: 'teacher');
                  
                },
                icon: const Icon(Icons.login),
                label: const Text('Login as a Teacher with Google'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  AuthUtils(context: context).signInWithGoogle(role: 'student');
                },
                icon: const Icon(Icons.login),
                label: const Text('Login as a Student with Google'),
              ),
              // ElevatedButton(
              //   onPressed: clearStoredData,
              //   child: const Text('Clear Data'),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
