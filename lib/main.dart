import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

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
        fontFamily: 'Roboto', // Better for medical app
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
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
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
      // Optional: Add routes for better navigation
      routes: {
        '/home': (context) => HomeScreen(),
        '/research': (context) => ResearchScreen(),
        '/results': (context) => ResultsScreen(research: ModalRoute.of(context)!.settings.arguments as MedicalResearch? ?? MedicalResearch(
          id: '1',
          topic: 'Default Research',
          hypothesis: '',
          methodology: '',
          labResults: '',
          analysis: '',
          conclusion: '',
          pdfReport: '',
          createdAt: DateTime.now(),
        )),
        '/history': (context) => HistoryScreen(),
      },
    );
  }
}
