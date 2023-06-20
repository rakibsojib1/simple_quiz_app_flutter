import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/authUtils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    checkUserLoggedIn();
  }

  Future<void> checkUserLoggedIn() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? currentUser = auth.currentUser;

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });

    if (currentUser != null) {
      try {
        if (mounted) {}
        final String? role = await AuthUtils().getRole();
        if (role == 'teacher') {
          Get.offNamed('/TeacherDashboard');
        } else if (role == 'student') {
          Get.offNamed('/StudentDashboard');
        } else {
          Get.offNamed('/LoginScreen');
        }
      } catch (error) {
        setState(() {
          errorMessage = 'Error occurred while checking user role: $error';
        });
      }
    } else {
      Get.offNamed('/LoginScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // Replace with your desired background color
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/images/logo.jpg',
                  width: 100,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            Column(
              children: [
                if (isLoading)
                  const CircularProgressIndicator(
                    color: Colors.blueGrey,
                  )
                else if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Version 1.0',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
