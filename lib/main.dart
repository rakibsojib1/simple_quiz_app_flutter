import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'ui/Screens/Create_Quiz_Screen.dart.dart';
import 'ui/Screens/Quiz_List_Screen.dart';
import 'ui/Screens/Student_Dashboard.dart';
import 'ui/Screens/Teacher_dashboard.dart';
import 'ui/Screens/loginScreen.dart';
import 'ui/Screens/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/QuizListScreen', page: () => const QuizListScreen()),
        GetPage(
            name: '/CreateQuizScreen', page: () => const CreateQuizScreen()),
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(
            name: '/Studentdashboard',
            page: () => const StudentDashboardScreen()),
        GetPage(name: '/LoginScreen', page: () => const LoginScreen()),
        GetPage(
            name: '/TeacherDashboardScreen',
            page: () => const TeacherDashboardScreen()),
      ],
    );
  }
}
