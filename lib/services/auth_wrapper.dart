import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/auth_page.dart';
import 'dart:ui';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return const AuthPage();
          } else {
            return Scaffold(
              body: const HomePage(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {},
              ),
              bottomNavigationBar: BottomAppBar(
                shape: const CircularNotchedRectangle(),
                notchMargin: 6.0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: SizedBox(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          IconButton(
                              icon: const Icon(Icons.grass_outlined),
                              onPressed: () {}),
                          IconButton(
                              icon: const Icon(Icons.bar_chart_outlined),
                              onPressed: () {}),
                          // const SizedBox(), // Space for the FAB
                          IconButton(
                              icon: const Icon(Icons.schedule_outlined),
                              onPressed: () {}),
                          IconButton(
                              icon: const Icon(Icons.account_circle),
                              onPressed: () {}),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        } else {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}
