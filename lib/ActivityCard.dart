import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

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
  double _progress = 0.0;
  double _miles = 0.0;
  double _calories = 0.0;
  double _timeMinutes = 0.0;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    var status = await Permission.activityRecognition.request();
    if (status.isGranted) {
      initStepCounter();
    } else {
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
  }

  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _initialSteps = prefs.getInt('initialSteps') ?? -1;
      _steps = prefs.getInt('steps') ?? 0;
    });
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('initialSteps', _initialSteps);
    await prefs.setInt('steps', _steps);
  }

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
      return;
    }
    if (_initialSteps == -1) {
      _initialSteps = event.steps;
    }
    setState(() {
      _steps = event.steps - _initialSteps;
      _progress = _steps / 500.0;
      _miles = (_steps * 2.2) / 5280.0;
      _calories = _steps * 0.04;
      _timeMinutes = _steps / 100.0;
    });
    _saveData(); // Save the step data after updating
  }

  void onStepCountError(dynamic error) {
    print('Failed to receive step counts: $error');
  }

  String formatTime(double minutes) {
    int hours = minutes ~/ 60;
    int remainingMinutes = (minutes % 60).round();
    return '${hours}h ${remainingMinutes}m';
  }

  @override
  Widget build(BuildContext context) {
    double progress = _steps / 500.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$_steps',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF3A82F7),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          _isPaused ? Icons.play_arrow : Icons.pause,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPaused = !_isPaused;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Text(
                  _isPaused ? 'PAUSED' : '',
                  style: TextStyle(
                    color: Color(0xFF3A82F7),
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 10),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[800],
                  valueColor:
                  AlwaysStoppedAnimation<Color>(Color(0xFF3A82F7)),
                  minHeight: 10,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatIcon(Icons.timer, formatTime(_timeMinutes)),
                    _buildStatIcon(Icons.local_fire_department,
                        '${_calories.toStringAsFixed(1)}'),
                    _buildStatIcon(Icons.directions_walk,
                        '${_miles.toStringAsFixed(2)}'),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Card(
          color: Color(0xff1A1B22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Average: 1750',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16), // Increased space here
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Commented out circular progress bars
                    // _buildCircularProgressBar(0.8, "S"),
                    // _buildCircularProgressBar(0.7, "M"),
                    // _buildCircularProgressBar(0.9, "T"),
                    // _buildCircularProgressBar(0.6, "W"),
                    // _buildCircularProgressBar(0.5, "T"),
                    // _buildCircularProgressBar(0.4, "F"),
                    // _buildCircularProgressBar(0.3, "S"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Color(0xFF3A82F7), size: 30),
        Text(label, style: TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildCircularProgressBar(double progress, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 28,
          width: 28,
          child: CircularProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[800],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            strokeWidth: 3,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _stepCountSubscription.cancel();
    super.dispose();
  }
}
