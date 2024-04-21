import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void getCurrentUser() async {}

  @override
  Widget build(BuildContext context) {
    return const Text('You are logged in!');
  }
}
