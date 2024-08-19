import 'package:flutter/material.dart';

class SimpleDropdownTest extends StatefulWidget {
  const SimpleDropdownTest({super.key});

  @override
  State<SimpleDropdownTest> createState() => _SimpleDropdownTestState();
}

class _SimpleDropdownTestState extends State<SimpleDropdownTest> {
  int _selectedStepGoal = 5000; // Default step goal
  final List<int> _stepGoals = [500, 1000, 5000, 7500, 10000, 15000];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // or any color you prefer
      appBar: AppBar(
        title: Text('Dropdown Test'),
        backgroundColor: Colors.grey[900],
      ),
      body: Center(
        child: DropdownButton<int>(
          dropdownColor: Colors.grey[800], // Matches the theme
          value: _selectedStepGoal,
          icon: Icon(Icons.arrow_drop_down, color: Colors.redAccent),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.redAccent),
          underline: Container(
            height: 0,
          ),
          onChanged: (int? newValue) {
            setState(() {
              _selectedStepGoal = newValue!;
            });
          },
          items: _stepGoals.map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child:
                  Text(value.toString(), style: TextStyle(color: Colors.white)),
            );
          }).toList(),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SimpleDropdownTest(),
    theme: ThemeData.dark(),
  ));
}
