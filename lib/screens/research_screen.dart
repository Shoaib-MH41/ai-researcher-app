import 'package:flutter/material.dart';
import '../models/research_model.dart';
import '../services/research_service.dart';

class ResearchScreen extends StatefulWidget {
  @override
  _ResearchScreenState createState() => _ResearchScreenState();
}

class _ResearchScreenState extends State<ResearchScreen> {
  final TextEditingController _researchController = TextEditingController();
  bool _isLoading = false;
  ResearchResult? _result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Research')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Text(
                    'Enter Your Research Topic',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _researchController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Example: Analyze the effects of climate change on marine biodiversity...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  if (_isLoading)
                    Center(child: CircularProgressIndicator())
                  else if (_result != null)
                    _buildResultCard()
                  else
                    _buildSampleResearch(),
                ],
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _startResearch,
              child: Text('Start Research Analysis'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Research Results', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text(_result!.summary),
            SizedBox(height: 16),
            Text('Methodology: ${_result!.methodology}'),
            SizedBox(height: 8),
            Text('Findings: ${_result!.findings}'),
          ],
        ),
      ),
    );
  }

  Widget _buildSampleResearch() {
    return Card(
      color: Colors.grey[100],
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sample Research Topics:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('• Climate change impact on biodiversity'),
            Text('• AI in medical diagnosis'),
            Text('• Renewable energy technologies'),
          ],
        ),
      ),
    );
  }

  void _startResearch() async {
    if (_researchController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _result = null;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    final result = await ResearchService().analyzeResearch(_researchController.text);

    setState(() {
      _isLoading = false;
      _result = result;
    });
  }
}
