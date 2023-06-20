import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import '../widgets/For Teacher/add_questions.dart';

class CreateQuizScreen extends StatefulWidget {
  const CreateQuizScreen({Key? key}) : super(key: key);

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  String quizName = '';
  String totalTime = '';
  List<QuestionData> questions = [];

  @override
  void initState() {
    super.initState();
    questions.add(QuestionData());
  }

  void addQuestion() {
    final validQuestions =
        questions.where((question) => question.isValid()).toList();

    if (validQuestions.isEmpty) {
      // No valid questions
      return;
    }

    final quizData = {
      'quizName': quizName,
      'totalTime': totalTime,
    };

    FirebaseFirestore.instance
        .collection('quizzes')
        .add(quizData)
        .then((quizDoc) {
      final quizId = quizDoc.id;

      for (var question in validQuestions) {
        final questionData = {
          'question': question.questionText,
          'options': question.options,
          'correctAnswerIndex': question.correctAnswerIndex,
        };

        FirebaseFirestore.instance
            .collection('quizzes')
            .doc(quizId)
            .collection('questions')
            .add(questionData)
            .catchError((error) {
          // Handle the error appropriately
        });
      }

      Navigator.of(context).pop();
    }).catchError((error) {
      // Error saving the quiz
      // Handle the error appropriately
    });
  }

  void addOption(int questionIndex) {
    setState(() {
      questions[questionIndex].options.add('');
    });
  }

  void removeOption(int questionIndex, int optionIndex) {
    setState(() {
      questions[questionIndex].options.removeAt(optionIndex);
    });
  }

  void addNewQuestion() {
    setState(() {
      questions.add(QuestionData());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Question'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Quiz Name'),
                onChanged: (value) {
                  setState(() {
                    quizName = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Total Time'),
                onChanged: (value) {
                  setState(() {
                    totalTime = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: questions.length,
                itemBuilder: (context, questionIndex) {
                  final currentQuestion = questions[questionIndex];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16.0),
                      Text(
                        'Question ${questionIndex + 1}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Question Text'),
                        onChanged: (value) {
                          setState(() {
                            currentQuestion.questionText = value;
                          });
                        },
                      ),
                      const SizedBox(height: 8.0),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: currentQuestion.options.length,
                        itemBuilder: (context, optionIndex) {
                          return Row(
                            children: [
                              Radio<int>(
                                value: optionIndex,
                                groupValue: currentQuestion.correctAnswerIndex,
                                onChanged: (value) {
                                  setState(() {
                                    currentQuestion.correctAnswerIndex = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Option'),
                                  onChanged: (value) {
                                    currentQuestion.options[optionIndex] =
                                        value;
                                  },
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    removeOption(questionIndex, optionIndex),
                                icon: const Icon(Icons.remove_circle),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 8.0),
                      ElevatedButton(
                        onPressed: () => addOption(questionIndex),
                        child: const Text('Add Option'),
                      ),
                      const Divider(),
                    ],
                  );
                },
              ),
              ElevatedButton(
                onPressed: addNewQuestion,
                child: const Text('Add Another Question'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: addQuestion,
                child: const Text('Save Questions'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
