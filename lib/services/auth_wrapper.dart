import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui';

import '../pages/home_page.dart';
import '../pages/profile_page.dart';
import '../pages/auth_page.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  // int _selectedIndex = 0;
  final PageController _pageController = PageController();

  // @override
  // void dispose() {
  //   _pageController.dispose();
  //   super.dispose();
  // }

  void _onItemTapped(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('AuthWrapper built');
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return const Scaffold(body: AuthPage());
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text('MicroMonitor'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.exit_to_app),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    tooltip: 'Sign Out',
                  ),
                ],
              ),
              body: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  debugPrint("Page changed to: $index");
                },
                children: const [
                  HomePage(),
                  Scaffold(), // Placeholder for other pages
                  Scaffold(),
                  ProfilePage() // Placeholder for other pages
                ],
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
                            icon: const Icon(Icons.home),
                            onPressed: () => _onItemTapped(0),
                          ),
                          IconButton(
                            icon: const Icon(Icons.account_circle),
                            onPressed: () => _onItemTapped(1),
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings),
                            onPressed: () => _onItemTapped(2),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_horiz),
                            onPressed: () => _onItemTapped(3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed:
                    () {}, // Define your floating action button functionality here
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
