import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuestionData {
  String questionText = '';
  List<String> options = [];
  int correctAnswerIndex = -1;

  bool isValid() {
    return questionText.isNotEmpty &&
        options.isNotEmpty &&
        correctAnswerIndex != -1;
  }
}

class AddQuestion {
  static void addQuestion(
    String quizId,
    QuestionData currentQuestion,
    BuildContext context,
  ) {
    if (currentQuestion.questionText.isNotEmpty &&
        currentQuestion.options.isNotEmpty &&
        currentQuestion.correctAnswerIndex != -1) {
      final questionData = {
        'question': currentQuestion.questionText,
        'options': currentQuestion.options,
        'correctAnswerIndex': currentQuestion.correctAnswerIndex,
      };

      FirebaseFirestore.instance
          .collection('quizzes')
          .doc(quizId)
          .collection('questions')
          .add(questionData)
          .then((value) {
        currentQuestion.questionText = '';
        currentQuestion.options = [];
        currentQuestion.correctAnswerIndex = -1;
        Navigator.of(context).pop();
      }).catchError((error) {
        // Handle the error appropriately
      });
    }
  }
}
