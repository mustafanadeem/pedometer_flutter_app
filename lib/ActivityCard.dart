import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pedometer/pedometer.dart';

class ActivityCard extends StatefulWidget {
  const ActivityCard({super.key});

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  late Stream<StepCount> _stepCountStream;
  late StreamSubscription<StepCount> _stepCountSubscription;
  int _steps = 0;
  int _initialSteps = -1;
  bool _isPaused = false;
  double _progress = 0.0; // Track whether the pedometer is paused
  double _miles = 0.0; // Variable to store calculated miles
  double _calories = 0.0; // Variable to store calculated calories
  double _timeMinutes = 0.0; // Variable to store estimated time in minutes

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    print("Requesting permissions...");
    var status = await Permission.activityRecognition.request();
    if (status.isGranted) {
      print("Permission granted");
      initStepCounter();
    } else {
      print("Permission denied");
      showError("Permission Denied",
          "This app requires activity recognition permissions to function.");
    }
  }

  void showError(String title, String msg) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  } // This will hold the current step count

  void initStepCounter() {
    if (!mounted) return;
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountSubscription = _stepCountStream.listen(
      onStepCount,
      onError: onStepCountError,
      cancelOnError: true,
    );
  }

  void onStepCount(StepCount event) {
    if (_isPaused) {
      return; // If paused, do not update steps
    }
    if (_initialSteps == -1) {
      _initialSteps = event.steps; // Set initial steps if not already set
    }
    setState(() {
      _steps = event.steps - _initialSteps;
      _progress = _steps / 500.0;
      _miles = (_steps * 2.2) / 5280.0;
      _calories = _steps * 0.04;
      _timeMinutes = _steps / 100.0; // Estimate time in minutes based on steps
    });
  }

  void onStepCountError(dynamic error) {
    print('Failed to receive step counts: $error');
  }

  String formatTime(double minutes) {
    int hours = minutes ~/ 60; // Calculate the number of hours
    int remainingMinutes =
        (minutes % 60).round(); // Calculate the remaining minutes
    return '${hours}h ${remainingMinutes}m';
  }

  @override
  Widget build(BuildContext context) {
    double progress = _steps / 500.0;
    return Card(
      color: Color(0xff1A1B22),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$_steps / 500 Steps',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              _isPaused ? 'PAUSED' : '',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              minHeight: 10,
            ),
            Switch(
              value: _isPaused,
              onChanged: (value) {
                setState(() {
                  _isPaused = value;
                });
              },
              activeColor: Colors.blue,
              inactiveThumbColor: Colors.grey,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatIcon(Icons.location_on,
                    '${_miles.toStringAsFixed(2)} Miles'), // Corrected label
                _buildStatIcon(Icons.local_fire_department,
                    '${_calories.toStringAsFixed(1)} Kcal'),
                _buildStatIcon(Icons.timer, formatTime(_timeMinutes)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildStatIcon(IconData icon, String label) {
  return Column(
    children: [
      Icon(icon, color: Color(0xff007AFF), size: 30),
      Text(label, style: TextStyle(color: Colors.white)),
    ],
  );
}
