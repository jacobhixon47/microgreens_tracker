import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  Future<String?> getCurrentUser() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc =
          await _store.collection('users').doc(user.uid).get();
      return userDoc.get('name');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // If the Future is still running, show a loading indicator
          return const Text('');
        } else if (snapshot.hasError) {
          // If we run into an error, display it to the user
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          // If the Future is complete and no errors occurred, display the user's name
          return Text('Hello, ${snapshot.data}!');
        } else {
          // If the Future is complete but no user is found, show a message
          return const Text('No user found');
        }
      },
    );
  }
}
