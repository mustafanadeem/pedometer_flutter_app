import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ActivityCard.dart';
// This will be needed for stream subscription

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        backgroundColor: Color(0xff070707),
        appBar: AppBar(
          backgroundColor: Color(0xff070707),
          title: Text(
            'Health Tracker',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ActivityCard(),
        ),
      ),
    );
  }
}
