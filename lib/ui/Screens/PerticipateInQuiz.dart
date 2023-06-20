import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/QuiestionTile.dart';
import 'CongratulationScree.dart';

class ParticipateInQuiz extends StatefulWidget {
  final String quizId;

  const ParticipateInQuiz({Key? key, required this.quizId}) : super(key: key);

  @override
  _ParticipateInQuizState createState() => _ParticipateInQuizState();
}

class _ParticipateInQuizState extends State<ParticipateInQuiz> {
  int score = 0;
  bool alreadyParticipated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Detail'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('quizzes')
            .doc(widget.quizId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error fetching quiz detail');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          final quizData = snapshot.data?.data() as Map<String, dynamic>;
          final quizTitle = quizData['quizName'] as String;
          final quizQuestionsRef = FirebaseFirestore.instance
              .collection('quizzes')
              .doc(widget.quizId)
              .collection('questions');

          return StreamBuilder<QuerySnapshot>(
            stream: quizQuestionsRef.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Error fetching questions');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              final questionDocs = snapshot.data?.docs;

              if (questionDocs == null || questionDocs.isEmpty) {
                return const Text('No questions found for this quiz');
              }

              return ListView.builder(
                itemCount: questionDocs.length + 1,
                itemBuilder: (context, index) {
                  if (index == questionDocs.length) {
                    return ElevatedButton(
                      onPressed: alreadyParticipated
                          ? null
                          : () async {
                              if (alreadyParticipated) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Already Participated'),
                                    content: const Text(
                                      'You have already participated in this quiz.',
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                await FirebaseFirestore.instance
                                    .collection('quizzes')
                                    .doc(widget.quizId)
                                    .collection('results')
                                    .add({'score': score});

                                // Mark the quiz as completed for the current user
                                final currentUser =
                                    FirebaseAuth.instance.currentUser;
                                if (currentUser != null) {
                                  final completedQuizzesCollection =
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(currentUser.uid)
                                          .collection('completedQuizzes');

                                  final completedQuizDocs =
                                      await completedQuizzesCollection
                                          .where('quizId',
                                              isEqualTo: widget.quizId)
                                          .get();

                                  if (completedQuizDocs.docs.isEmpty) {
                                    await completedQuizzesCollection.add({
                                      'quizId': widget.quizId,
                                      'completed': true,
                                    });
                                  } else {
                                    if (mounted) {}
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title:
                                            const Text('Already Participated'),
                                        content: const Text(
                                          'You have already participated in this quiz.',
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                    return;
                                  }
                                }

                                setState(() {
                                  alreadyParticipated = true;
                                });
                                if (mounted) {}
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CongratulationPage(
                                      score: score,
                                    ),
                                  ),
                                  (route) =>
                                      false, // Remove all previous routes
                                );
                              }
                            },
                      child: const Text('Submit Quiz'),
                    );
                  }

                  final questionData =
                      questionDocs[index].data() as Map<String, dynamic>;
                  final question = questionData['question'] as String;
                  final options = questionData['options'] as List<dynamic>;
                  final correctAnswerIndex =
                      questionData['correctAnswerIndex'] as int;

                  return QuestionTile(
                    question: question,
                    options: options,
                    correctAnswerIndex: correctAnswerIndex,
                    onOptionSelected: (selectedOptionIndex) {
                      if (selectedOptionIndex == correctAnswerIndex) {
                        score++;
                      }
                    },
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
