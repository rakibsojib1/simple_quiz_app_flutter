import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'Create_Quiz_Screen.dart.dart';
import 'Quiz_List_Screen.dart';
import 'participant_list_Screen.dart';
import 'profile.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({Key? key}) : super(key: key);

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  final CollectionReference quizCollection =
      FirebaseFirestore.instance.collection('quizzes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Get.to(const ProfilePage());
          },
          child: const Icon(
            Icons.person, // Replace with your profile icon
            size: 30,
          ),
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
                width: 300,
                child: Card(
                  color: Colors.amberAccent,
                  child: ListTile(
                    title: StreamBuilder<QuerySnapshot>(
                      stream: quizCollection.snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          final List<DocumentSnapshot> documents =
                              snapshot.data!.docs;
                          return Text(
                            'Total Quiz List Number: ${documents.length}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                    onTap: () {
                      // Navigate to quiz list page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuizListScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 150,
                width: 300,
                child: Card(
                  color: Colors.blueAccent,
                  child: ListTile(
                    title: const Text(
                      'Total Participant Number:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      'Count the total number of participants',
                      textAlign: TextAlign.center,
                    ),
                    onTap: () {
                      // Navigate to participant list page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ParticipantListScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 150,
                width: 300,
                child: Card(
                  elevation: 10,
                  shadowColor: Colors.amber,
                  color: Colors.yellowAccent,
                  child: ListTile(
                    title: const Text(
                      'Create Quiz',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      // Navigate to create quiz page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateQuizScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
