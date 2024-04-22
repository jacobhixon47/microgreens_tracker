import 'package:flutter/material.dart';

class PagesWrapper extends StatelessWidget {
  final int index;
  final List<Widget> pages;

  const PagesWrapper({super.key, required this.pages, required this.index});

  @override
  Widget build(BuildContext context) {
    return pages[index];
  }
}
