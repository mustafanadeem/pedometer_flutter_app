import "package:flutter/material.dart";
import '../ActivityCard.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.all(16.0), child: ActivityCard());
  }
}
