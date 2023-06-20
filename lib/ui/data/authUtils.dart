import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Screens/Student_Dashboard.dart';
import '../Screens/Teacher_dashboard.dart';
import '../widgets/alart_dialog.dart';

class AuthUtils {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  BuildContext? context;

  AuthUtils({this.context});

  Future<void> signInWithGoogle({required String role}) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final String userEmail = googleUser.email;
        final userQuery = await _getUserData(userEmail);

        if (userQuery.docs.isNotEmpty) {
          final userData = userQuery.docs.first.data() as Map<String, dynamic>;
          final existingRole = userData['role'];

          if (existingRole == role) {
            showLoadingIndicator();

            final UserCredential userCredential =
                await _signInWithGoogleCredential(googleUser);

            performRoleSpecificActions(role, userCredential);
          } else {
            showDifferentRoleError();
          }
        } else {
          final uid = await _createNewUser(userEmail, role);
          final UserCredential userCredential =
              await _signInWithGoogleCredential(googleUser);

          performRoleSpecificActions(role, userCredential);
        }
      }
    } catch (e) {
      handleLoginError(e);
    }
  }

  Future<QuerySnapshot> _getUserData(String userEmail) {
    return _firestore
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .get();
  }

  void showDifferentRoleError() {
    if (context != null) {
      showAlertDialog(
        context!,
        'Error',
        'You are already signed up with a different role using this email. Please choose a different email or role. Please Clear App data to use different mail if you are facing a problem.',
      );
    }
  }

  Future<String> _createNewUser(String userEmail, String role) async {
    final docRef = await _firestore.collection('users').add({
      'email': userEmail,
      'role': role,
    });
    return docRef.id;
  }

  Future<UserCredential> _signInWithGoogleCredential(
      GoogleSignInAccount googleUser) async {
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    return userCredential;
  }

  void performRoleSpecificActions(String role, UserCredential userCredential) {
    switch (role) {
      case 'teacher':
        if (context != null) {
          Navigator.pushReplacement(
            context!,
            MaterialPageRoute(
              builder: (context) => const TeacherDashboardScreen(),
            ),
          );
        }
        break;
      case 'student':
        if (context != null) {
          Navigator.pushReplacement(
            context!,
            MaterialPageRoute(
              builder: (context) => const StudentDashboardScreen(),
            ),
          );
        }
        break;
      default:
        print('Invalid role: $role');
    }
  }

  void handleLoginError(dynamic e) {
    print('Login error: $e');
    // Handle any errors that occur during login
  }

  Future<String?> getRole() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user!.email)
        .get();
    if (userData.docs.isNotEmpty) {
      final role = userData.docs[0].data()['role'];
      return role;
    }
    return null;
  }

  void showLoadingIndicator() {
    if (context != null) {
      showDialog(
        context: context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
    }
  }
}
