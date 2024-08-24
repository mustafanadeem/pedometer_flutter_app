// import 'package:flutter/material.dart';
// import 'package:pedometer/pedometer.dart';
// import 'dart:async';
// import 'package:intl/intl.dart';
// import 'Screens/Reports.dart';
// import 'Screens/week.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Pedometer',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: Colors.black,
//         textTheme: Theme.of(context).textTheme.apply(
//           bodyColor: Colors.white,
//           displayColor: Colors.white,
//         ),
//       ),
//       home: HomePage(),
//     );
//   }
// }
//
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   late Stream<StepCount> _stepCountStream;
//   late Stream<PedestrianStatus> _pedestrianStatusStream;
//   String _status = '?', _steps = '?';
//   int _currentIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//   }
//
//   void onStepCount(StepCount event) {
//     print(event);
//     setState(() {
//       _steps = event.steps.toString();
//     });
//   }
//
//   void onPedestrianStatusChanged(PedestrianStatus event) {
//     print(event);
//     setState(() {
//       _status = event.status;
//     });
//   }
//
//   void onPedestrianStatusError(error) {
//     print('onPedestrianStatusError: $error');
//     setState(() {
//       _status = 'Pedestrian Status not available';
//     });
//     print(_status);
//   }
//
//   void onStepCountError(error) {
//     print('onStepCountError: $error');
//     setState(() {
//       _steps = 'Step Count not available';
//     });
//   }
//
//   void initPlatformState() {
//     _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
//     _pedestrianStatusStream
//         .listen(onPedestrianStatusChanged)
//         .onError(onPedestrianStatusError);
//
//     _stepCountStream = Pedometer.stepCountStream;
//     _stepCountStream.listen(onStepCount).onError(onStepCountError);
//
//     if (!mounted) return;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: _currentIndex,
//         children: <Widget>[
//           _buildHomeContent(),
//           ReportPage(),
//           _buildSettingsContent(),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.show_chart),
//             label: 'Reports',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: 'Settings',
//           ),
//         ],
//         backgroundColor: Colors.black,
//         selectedItemColor: Colors.white,
//         unselectedItemColor: Colors.grey,
//       ),
//     );
//   }
//
//   Widget _buildHomeContent() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Text(
//             'Steps taken:',
//             style: TextStyle(fontSize: 30),
//           ),
//           Text(
//             _steps,
//             style: TextStyle(fontSize: 60),
//           ),
//           Divider(
//             height: 100,
//             thickness: 0,
//             color: Colors.white,
//           ),
//           Text(
//             'Pedestrian status:',
//             style: TextStyle(fontSize: 30),
//           ),
//           Icon(
//             _status == 'walking'
//                 ? Icons.directions_walk
//                 : _status == 'stopped'
//                 ? Icons.accessibility_new
//                 : Icons.error,
//             size: 100,
//             color: Colors.white,
//           ),
//           Center(
//             child: Text(
//               _status,
//               style: _status == 'walking' || _status == 'stopped'
//                   ? TextStyle(fontSize: 30)
//                   : TextStyle(fontSize: 20, color: Colors.red),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSettingsContent() {
//     return Center(
//       child: Text('Settings Page', style: TextStyle(fontSize: 24)),
//     );
//   }
// }