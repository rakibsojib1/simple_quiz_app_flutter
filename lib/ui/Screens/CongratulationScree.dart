import 'package:flutter/material.dart';

import 'Student_Dashboard.dart';

class CongratulationPage extends StatelessWidget {
  final int score;

  const CongratulationPage({Key? key, required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Congratulations'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Quiz submitted successfully!'),
            const SizedBox(height: 20),
            Text('Total Score: $score'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StudentDashboardScreen(),
                  ),
                  (route) => false, // Remove all previous routes
                );
              },
              child: const Text('Go Back to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
