import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../pages/authenticated_view.dart';
import '../pages/auth_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          return user != null
              ? const AuthenticatedView()
              : const Scaffold(body: AuthPage());
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
