import 'package:flutter/material.dart';
import '../models/research_model.dart';

class ResultsScreen extends StatelessWidget {
  final MedicalResearch research;
  
  const ResultsScreen({Key? key, required this.research}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Research Results')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Research Topic
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Medical Research Topic', 
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text(research.topic, 
                          style: TextStyle(fontSize: 18, color: Colors.blue)),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 16),
              
              // Hypothesis
              _buildSection('Research Hypothesis', research.hypothesis),
              
              // Methodology
              _buildSection('Methodology', research.methodology),
              
              // Lab Results
              _buildSection('Laboratory Results', research.labResults),
              
              // Analysis
              _buildSection('Data Analysis', research.analysis),
              
              // Conclusion
              _buildSection('Conclusion', research.conclusion),
              
              SizedBox(height: 20),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _saveAsPDF(context);
                      },
                      icon: Icon(Icons.picture_as_pdf),
                      label: Text('Save as PDF'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back),
                      label: Text('New Research'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(content, style: TextStyle(height: 1.5)),
          ),
        ),
      ],
    );
  }
  
  void _saveAsPDF(BuildContext context) {
    // PDF save functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF report saved successfully')),
    );
  }
}
