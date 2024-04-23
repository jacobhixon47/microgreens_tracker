import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../pages/home_page.dart';
import '../pages/profile_page.dart';

import '../widgets/add_crop_dialog.dart';
import '../widgets/add_seed_dialog.dart';

class AuthenticatedView extends StatefulWidget {
  const AuthenticatedView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthenticatedViewState createState() => _AuthenticatedViewState();
}

class _AuthenticatedViewState extends State<AuthenticatedView>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  late AnimationController _animationController;
  late Animation<double> _animation;
  OverlayEntry? _overlayEntry;
  bool isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showAddSeedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddSeedDialog();
      },
    );
    debugPrint('Showing AddSeedDialog()');
  }

  void _showAddCropDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddCropDialog();
      },
    );
    debugPrint('Showing AddCropDialog()');
  }

  OverlayEntry _createOverlayEntry() {
    // Get the screen size
    final Size screenSize = MediaQuery.of(context).size;
    // Get the bottom padding (useful for devices with a bottom navigation bar like iPhone X and up)
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    // Get the FAB size and positions (assuming it's a standard FAB for simplicity)
    const double fabSize = 56.0;
    const double fabIconSize = 24.0; // The size of the icon inside the FAB
    const double fabMargin = 16.0; // The standard margin for FAB from the edges

    // Calculate the positions for the buttons
    const double buttonStackHeight = fabSize * 2; // For two buttons
    final double fabYPosition = (fabSize + fabMargin + bottomPadding) * 3.6;
    final double buttonsYStart = fabYPosition - buttonStackHeight;

    return OverlayEntry(
      builder: (context) => Positioned(
        right: fabMargin, // Align with the FAB right margin
        bottom: buttonsYStart,
        child: Material(
          color: Colors.transparent,
          elevation: 0,
          child: Column(
            children: <Widget>[
              FloatingActionButton(
                heroTag: 'add_crop',
                onPressed: () {
                  _showAddCropDialog();
                  _toggleMenu();
                },
                child: const Icon(Icons.grass),
              ),
              const SizedBox(height: fabMargin),
              FloatingActionButton(
                heroTag: 'add_seed',
                onPressed: () {
                  _showAddSeedDialog();
                  _toggleMenu();
                },
                child: const Icon(Icons.spa),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleMenu() {
    if (isMenuOpen) {
      _overlayEntry?.remove();
      _animationController.reverse();
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context)?.insert(_overlayEntry!);
      _animationController.forward();
    }
    isMenuOpen = !isMenuOpen;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MicroMonitor',
          style: TextStyle(fontSize: 30),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: FirebaseAuth.instance.signOut,
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          if (_selectedIndex != index) {
            setState(() => _selectedIndex = index);
          }
        },
        children: [
          const HomePage(),
          const Scaffold(),
          const Scaffold(),
          ProfilePage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        // backgroundColor: Colors.white10,
        // type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.house), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.grass), label: 'Crops'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Data'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.black87,
        onPressed: _toggleMenu,
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animationController,
        ),
      ),
    );
  }
}
