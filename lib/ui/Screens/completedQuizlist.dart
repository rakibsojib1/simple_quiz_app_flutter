import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/authUtils.dart';
import 'PerticipateInQuiz.dart';
import 'Quiz_Details_Screen.dart';

class CompletedQuizListScreen extends StatefulWidget {
  const CompletedQuizListScreen({Key? key}) : super(key: key);

  @override
  State<CompletedQuizListScreen> createState() =>
      _CompletedQuizListScreenState();
}

class _CompletedQuizListScreenState extends State<CompletedQuizListScreen> {
  late String userUid; // Store the user ID

  @override
  void initState() {
    super.initState();
    // Retrieve the user ID
    final currentUser = FirebaseAuth.instance.currentUser;
    userUid = currentUser?.uid ?? '';
  }

  void navigateToQuizDetail(String quizId) async {
    Get.to(QuizDetailScreen(quizId: quizId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userUid)
            .collection('completedQuizzes')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error fetching completed quizzes');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          final completedQuizzes = snapshot.data?.docs;

          if (completedQuizzes == null || completedQuizzes.isEmpty) {
            return const Text('No completed quizzes');
          }

          return ListView.builder(
            itemCount: completedQuizzes.length,
            itemBuilder: (context, index) {
              final completedQuizData =
                  completedQuizzes[index].data() as Map<String, dynamic>;
              final quizId = completedQuizData['quizId'] as String;

              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('quizzes')
                    .doc(quizId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error fetching quiz');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  final quizData =
                      snapshot.data?.data() as Map<String, dynamic>?;

                  if (quizData == null) {
                    return const Text('Quiz not found');
                  }

                  final quizTitle = quizData['quizName'] as String;
                  final quizTime = quizData['totalTime'] as String;

                  return GestureDetector(
                    onTap: () => navigateToQuizDetail(quizId),
                    child: Card(
                      child: ListTile(
                        title: Text(quizTitle),
                        subtitle: Text('Time: $quizTime'),
                        trailing: const Text("Click to ans"),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
