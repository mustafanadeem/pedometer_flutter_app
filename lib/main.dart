import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ActivityCard.dart';
import 'reports.dart'; // Make sure you have this file in your project

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
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff070707),
      appBar: AppBar(
        backgroundColor: Color(0xff070707),
        title: Text(
          'Health Tracker',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ActivityCard(),
          ),
          ReportPage(),
          Center(child: Text('Settings Page')), // Placeholder for Settings page
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}