import 'package:flutter/material.dart';
import '../services/medical_research_service.dart';
import '../models/research_model.dart';
import 'results_screen.dart';  // یہ import شامل کریں

class ResearchScreen extends StatefulWidget {
  @override
  _ResearchScreenState createState() => _ResearchScreenState();
}

class _ResearchScreenState extends State<ResearchScreen> {
  final TextEditingController _topicController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Medical Research')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Text(
                    'Enter Medical Research Topic',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _topicController,
                    decoration: InputDecoration(
                      hintText: 'Example: Efficacy of new drug for diabetes...',
                      border: OutlineInputBorder(),
                      labelText: 'Research Topic',
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 20),
                  
                  if (_isLoading)
                    Center(child: CircularProgressIndicator())
                  else
                    _buildMedicalExamples(),
                ],
              ),
            ),
            
            ElevatedButton(
              onPressed: _isLoading ? null : _startResearch,
              child: Text(_isLoading ? 'Research in Progress...' : 'Start Medical Research'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalExamples() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Medical Research Examples:', 
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('• Drug efficacy studies'),
            Text('• Clinical trial analysis'),
            Text('• Medical data interpretation'),
            Text('• Treatment outcome research'),
          ],
        ),
      ),
    );
  }

  void _startResearch() async {
    if (_topicController.text.isEmpty) return;
    
    setState(() => _isLoading = true);
    
    // Medical research service call
    final research = await MedicalResearchService().conductMedicalResearch(
      _topicController.text
    );
    
    setState(() => _isLoading = false);
    
    // Navigate to results
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => ResultsScreen(research: research)
    ));
  }
}
