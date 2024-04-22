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
  int _selectedIndex = 0;
  // final PageController _pageController = PageController();
  final List<Widget> _pages = [
    const HomePage(),
    const Scaffold(),
    const Scaffold(),
    ProfilePage()
  ];

  // @override
  // void dispose() {
  //   _pageController.dispose();
  //   super.dispose();
  // }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    // _pageController.animateToPage(index,
    //     duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
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
              body: _pages[_selectedIndex],
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
                            icon: const Icon(Icons.house),
                            color:
                                _selectedIndex == 0 ? Colors.greenAccent : null,
                            onPressed: () => _onItemTapped(0),
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings),
                            color:
                                _selectedIndex == 1 ? Colors.greenAccent : null,
                            onPressed: () => _onItemTapped(1),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_horiz),
                            color:
                                _selectedIndex == 2 ? Colors.greenAccent : null,
                            onPressed: () => _onItemTapped(2),
                          ),
                          IconButton(
                            icon: const Icon(Icons.account_circle),
                            color:
                                _selectedIndex == 3 ? Colors.greenAccent : null,
                            onPressed: () => _onItemTapped(3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.miniEndFloat,
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
