import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/authUtils.dart';
import 'PerticipateInQuiz.dart';
import 'Quiz_Details_Screen.dart';

class QuizListScreen extends StatefulWidget {
  const QuizListScreen({Key? key}) : super(key: key);

  @override
  State<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  late Stream<QuerySnapshot> quizStream;
  late String userUid; // Store the user ID

  @override
  void initState() {
    super.initState();
    // Retrieve quizzes from Firestore for the logged-in user
    final currentUser = FirebaseAuth.instance.currentUser;
    userUid = currentUser?.uid ?? ''; // Store the user ID
    quizStream = FirebaseFirestore.instance
        .collection('quizzes')
        //.where('userId', isEqualTo: userUid)
        .snapshots();
  }

  void navigateToQuizDetail(String quizId) async {
    String? role =
        await AuthUtils().getRole(); // Wait for the Future to complete
    if (mounted) {}
    if (role == 'teacher') {
      Get.to(QuizDetailScreen(quizId: quizId));
    } else {
      Get.to(ParticipateInQuiz(quizId: quizId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: quizStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error fetching quizzes');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          final quizDocs = snapshot.data?.docs;

          if (quizDocs == null || quizDocs.isEmpty) {
            return const Text('No quizzes found');
          }

          return ListView.builder(
            itemCount: quizDocs.length,
            itemBuilder: (context, index) {
              final quizData = quizDocs[index].data() as Map<String, dynamic>;
              final quizId = quizDocs[index].id;
              final quizTitle = quizData['quizName'] as String;
              final quizTime = quizData['totalTime'] as String;

              return GestureDetector(
                onTap: () => navigateToQuizDetail(quizId),
                child: Card(
                  child: ListTile(
                    title: Text(quizTitle),
                    subtitle: Text('Time: $quizTime'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
