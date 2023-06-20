import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuizDetailScreen extends StatelessWidget {
  final String quizId;

  const QuizDetailScreen({Key? key, required this.quizId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Detail'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('quizzes')
            .doc(quizId)
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
              .doc(quizId)
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
                itemCount: questionDocs.length,
                itemBuilder: (context, index) {
                  final questionData =
                      questionDocs[index].data() as Map<String, dynamic>;
                  final questionText = questionData['question'] as String;
                  final options = questionData['options'] as List<dynamic>;
                  final correctAnswerIndex =
                      questionData['correctAnswerIndex'] as int;

                  final List<Widget> optionTiles = [];
                  for (var i = 0; i < options.length; i++) {
                    final option = options[i] as String;
                    final isCorrect = i == correctAnswerIndex;
                    final optionTile = ListTile(
                      title: Text(option),
                      leading: Radio<int>(
                        value: i,
                        groupValue: correctAnswerIndex,
                        onChanged: (value) {},
                      ),
                      trailing: isCorrect ? const Icon(Icons.check) : null,
                    );
                    optionTiles.add(optionTile);
                  }

                  return ExpansionTile(
                    title: Text(questionText),
                    children: optionTiles,
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
