import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
<<<<<<< Updated upstream:lib/reports.dart
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
=======
  List<int> weeklyData = [6000, 8000, 6500, 5000, 9000, 7258, 0];
  String selectedPeriod = 'Week';
>>>>>>> Stashed changes:lib/Screens/Reports.dart

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
<<<<<<< Updated upstream:lib/reports.dart
      appBar: AppBar(
        title: Text('Report', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
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
        children: _periods.map((period) => ElevatedButton(
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
        )).toList(),
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
=======
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Report',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ToggleButtonsSection(
                selectedPeriod: selectedPeriod,
                onPeriodChanged: (period) {
                  setState(() {
                    selectedPeriod = period;
                  });
                },
              ),
              SizedBox(height: 20),
              DateRangeSection(),
              SizedBox(height: 20),
              BarChartSection(weeklyData: weeklyData),
              SizedBox(height: 20),
              DataTypeSelectionSection(),
              SizedBox(height: 20),
              StatisticsSummarySection(),
            ],
>>>>>>> Stashed changes:lib/Screens/Reports.dart
          ),
        ),
      ),
    );
  }
}

class ToggleButtonsSection extends StatelessWidget {
  final String selectedPeriod;
  final Function(String) onPeriodChanged;

  ToggleButtonsSection({required this.selectedPeriod, required this.onPeriodChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ['Day', 'Week', 'Month'].map((period) {
          return Expanded(
            child: GestureDetector(
              onTap: () => onPeriodChanged(period),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selectedPeriod == period ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  period,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class DateRangeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
        Text(
          'Jul 30 - Aug 5',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
      ],
    );
  }
}

class BarChartSection extends StatelessWidget {
  final List<int> weeklyData;

  BarChartSection({required this.weeklyData});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 10000,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const style = TextStyle(color: Colors.white, fontSize: 12);
                  final labels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(labels[value.toInt()], style: style),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 2500,
                getTitlesWidget: (double value, TitleMeta meta) {
                  if (value == 0) return Container();
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text('${value ~/ 1000}k', style: TextStyle(color: Colors.white, fontSize: 12)),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(7, (index) =>
              BarChartGroupData(
                x: index,
                barRods: [BarChartRodData(
                  toY: weeklyData[index].toDouble(),
                  color: index == 5 ? Colors.white : Colors.blue,
                  width: 20,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                )],
              )
          ),
        ),
      ),
    );
  }
}

class DataTypeSelectionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDataTypeButton('STEP', true),
        _buildDataTypeButton('CALORIE', false),
        _buildDataTypeButton('TIME', false),
        _buildDataTypeButton('DISTANCE', false),
      ],
    );
  }

  Widget _buildDataTypeButton(String label, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.grey[800],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}

class StatisticsSummarySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('2,324', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              Text('AVG/D', style: TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('9,295', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              Text('TOTAL', style: TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}