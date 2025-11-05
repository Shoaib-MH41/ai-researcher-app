import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/research_screen.dart';
import 'screens/history_screen.dart';
import 'screens/admin_panel.dart';
import 'screens/research_lab_screen.dart';
import 'screens/discovery_screen.dart'; // نیا ڈسکوری اسکرین import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Research AI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[800],
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue[800],
          foregroundColor: Colors.white,
          elevation: 4,
        ),
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomeScreen(),
        '/research': (context) => ResearchScreen(),
        '/history': (context) => HistoryScreen(),
        '/admin': (context) => AdminPanel(),
        '/research_lab': (context) => ResearchLabScreen(),
        '/discovery': (context) => DiscoveryScreen(medicalProblem: ''), // نیا ڈسکوری روٹ
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
