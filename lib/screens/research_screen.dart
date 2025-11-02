import 'package:flutter/material.dart';
import '../models/research_model.dart';
import '../services/research_service.dart';
import '../services/local_storage_service.dart';
import '../widgets/result_display.dart';

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
                      labelText: 'Research Topic',
                    ),
                  ),
                  SizedBox(height: 20),
                  if (_isLoading)
                    Center(child: CircularProgressIndicator())
                  else if (_result != null)
                    ResultDisplay(result: _result!)
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

  Widget _buildSampleResearch() {
    return Card(
      color: Colors.grey[100],
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('💡 Sample Research Topics:', 
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            _buildSampleTopic('Climate change impact on biodiversity'),
            _buildSampleTopic('AI in medical diagnosis'),
            _buildSampleTopic('Renewable energy technologies'),
            _buildSampleTopic('Machine learning in agriculture'),
            _buildSampleTopic('Space exploration advancements'),
          ],
        ),
      ),
    );
  }

  Widget _buildSampleTopic(String topic) {
    return GestureDetector(
      onTap: () {
        _researchController.text = topic;
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Text('• $topic', style: TextStyle(color: Colors.blue)),
      ),
    );
  }

  void _startResearch() async {
    if (_researchController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a research topic')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _result = null;
    });

    try {
      final result = await ResearchService().analyzeResearch(
        _researchController.text, 
        context
      );
      
      // Save to local storage
      await LocalStorageService.saveResearch(result);
      
      setState(() {
        _isLoading = false;
        _result = result;
      });
      
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Research analysis completed')),
      );
    }
  }
}
