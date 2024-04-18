import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/auth_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MicroMonitor'),
        actions: <Widget>[
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                // User is signed in
                return IconButton(
                  icon: const Icon(Icons.exit_to_app),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  tooltip: 'Sign Out',
                );
              } else {
                // User is signed out
                return const SizedBox(); // Return an empty widget if user is not signed in
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              User? user = snapshot.data;
              if (user == null) {
                return const AuthPage();
              } else {
                return const HomePage();
              }
            } else {
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            }
          }),
    );
  }
}
