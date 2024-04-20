import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'themes/app_themes.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'services/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: AppThemes.darkTheme,
        home: Scaffold(
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
          body: const AuthWrapper(),
        ));
  }
}
