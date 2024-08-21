import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Reports extends StatefulWidget {
  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  String _selectedPeriod = 'Day';
  List<String> _periods = ['Day', 'Week', 'Month'];
  int _steps = 0;
  int _goal = 7400; // Example goal for daily steps
  double _calories = 0.0;
  double _timeMinutes = 0.0;
  double _miles = 0.0;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _steps = prefs.getInt('steps') ?? 0;
      _calories = _steps * 0.04;
      _timeMinutes = _steps / 100.0;
      _miles = (_steps * 2.2) / 5280.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(height: 20),
          _buildPeriodSelector(),
          SizedBox(height: 20),
          _buildStepCounter(),
          SizedBox(height: 20),
          _buildMetricButtons(),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _periods
            .map((period) => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedPeriod == period
                        ? Colors.blue
                        : Colors.grey[800],
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedPeriod = period;
                    });
                  },
                  child: Text(period),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildStepCounter() {
    double percentage = _steps / _goal;
    return CircularPercentIndicator(
      radius: 120.0,
      lineWidth: 13.0,
      animation: true,
      percent: percentage > 1 ? 1 : percentage,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$_steps",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40.0,
                color: Colors.white),
          ),
          Text(
            "Goal: $_goal",
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16.0,
                color: Colors.white70),
          ),
        ],
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: Colors.blue,
      backgroundColor: Colors.grey[800]!,
    );
  }

  Widget _buildMetricButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ['STEP', 'CALORIE', 'TIME', 'DISTANCE'].map((metric) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[800],
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            _handleMetricSelection(metric);
          },
          child: Text(metric),
        );
      }).toList(),
    );
  }

  void _handleMetricSelection(String metric) {
    String metricValue;
    switch (metric) {
      case 'STEP':
        metricValue = '$_steps';
        break;
      case 'CALORIE':
        metricValue = _calories.toStringAsFixed(1);
        break;
      case 'TIME':
        metricValue = '${_timeMinutes.toStringAsFixed(1)} min';
        break;
      case 'DISTANCE':
        metricValue = '${_miles.toStringAsFixed(2)} miles';
        break;
      default:
        metricValue = 'N/A';
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(metric),
        content: Text(metricValue),
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
}
