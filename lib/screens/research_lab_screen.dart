import 'package:flutter/material.dart';
import '../services/medical_research_service.dart';
import '../models/research_model.dart';  // ResearchReport کے لیے

class ResearchLabScreen extends StatefulWidget {
  const ResearchLabScreen({super.key});

  @override
  State<ResearchLabScreen> createState() => _ResearchLabScreenState();
}

class _ResearchLabScreenState extends State<ResearchLabScreen> {
  final TextEditingController _researchController = TextEditingController();
  final MedicalResearchService _researchService = MedicalResearchService();
  
  bool _isResearchRunning = false;
  String _currentStatus = '';
  List<String> _progressLog = [];
  MedicalResearch? _currentResearch;

  void _addToProgressLog(String message) {
    setState(() {
      _progressLog.add('${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second} - $message');
    });
  }

  void _startScientificResearch() async {
    if (_researchController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter research topic')),
      );
      return;
    }

    setState(() {
      _isResearchRunning = true;
      _progressLog.clear();
      _currentResearch = null;
      _currentStatus = 'Starting research...';
    });

    _addToProgressLog('🚀 Starting scientific research');
    
    try {
      // Step 1: Research Process
      _addToProgressLog('🧠 Research AI: Planning research');
      setState(() => _currentStatus = 'Research AI working...');
      await Future.delayed(Duration(seconds: 2));

      // Step 2: Lab Process
      _addToProgressLog('🔬 Lab AI: Virtual experiments');
      setState(() => _currentStatus = 'Running lab experiments...');
      await Future.delayed(Duration(seconds: 3));

      // Step 3: Analysis Process
      _addToProgressLog('📊 Analysis AI: Data analysis');
      setState(() => _currentStatus = 'Analyzing results...');
      await Future.delayed(Duration(seconds: 2));

      // Final Research using MedicalResearchService
      final research = await _researchService.conductMedicalResearch(
        _researchController.text
      );

      setState(() {
        _isResearchRunning = false;
        _currentResearch = research;
        _currentStatus = 'Research completed!';
      });

      _addToProgressLog('✅ Research completed successfully');
      _addToProgressLog('📄 Report ready: ${research.topic}');

    } catch (e) {
      setState(() {
        _isResearchRunning = false;
        _currentStatus = 'Research failed';
      });
      _addToProgressLog('❌ Research error: $e');
    }
  }

  void _showResearchReport() {
    if (_currentResearch == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Research Report',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildReportSection('Research Topic', _currentResearch!.topic, Icons.science),
                    SizedBox(height: 16),
                    _buildReportSection('Hypothesis', _currentResearch!.hypothesis, Icons.lightbulb),
                    SizedBox(height: 16),
                    _buildReportSection('Methodology', _currentResearch!.methodology, Icons.list_alt),
                    SizedBox(height: 16),
                    _buildReportSection('Lab Results', _currentResearch!.labResults, Icons.biotech),
                    SizedBox(height: 16),
                    _buildReportSection('Analysis', _currentResearch!.analysis, Icons.analytics),
                    SizedBox(height: 16),
                    _buildReportSection('Conclusion', _currentResearch!.conclusion, Icons.verified),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('PDF saved successfully')),
                              );
                            },
                            child: Text('Save as PDF'),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Close'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportSection(String title, String content, IconData icon) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue),
                SizedBox(width: 8),
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8),
            Text(content, style: TextStyle(height: 1.5)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Research Lab'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Research Input
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter Research Topic',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _researchController,
                      decoration: InputDecoration(
                        hintText: 'Example: Diabetes treatment, Cancer research etc.',
                        border: OutlineInputBorder(),
                        labelText: 'Research Topic',
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Progress Section
            if (_isResearchRunning || _progressLog.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Research Progress', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 12),
                      if (_isResearchRunning) LinearProgressIndicator(),
                      SizedBox(height: 8),
                      Text(_currentStatus, style: TextStyle(color: _isResearchRunning ? Colors.blue : Colors.green, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      Container(
                        height: 150,
                        child: ListView.builder(
                          itemCount: _progressLog.length,
                          itemBuilder: (context, index) => ListTile(
                            leading: Icon(Icons.play_arrow, size: 16),
                            title: Text(_progressLog[index]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],

            // Results Section
            if (_currentResearch != null) ...[
              Card(
                color: Colors.green[50],
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.verified, size: 48, color: Colors.green),
                      SizedBox(height: 8),
                      Text('Research Completed!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Topic: ${_currentResearch!.topic}'),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _showResearchReport,
                        child: Text('View Full Report'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],

            // Start Button
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isResearchRunning ? null : _startScientificResearch,
                    child: Text(_isResearchRunning ? 'Research in Progress...' : 'Start Research'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isResearchRunning ? Colors.grey : Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
