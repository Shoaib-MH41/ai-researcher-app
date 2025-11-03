import 'package:flutter/material.dart';
import '../services/scientific_research_service.dart';

class ResearchLabScreen extends StatefulWidget {
  const ResearchLabScreen({super.key});

  @override
  State<ResearchLabScreen> createState() => _ResearchLabScreenState();
}

class _ResearchLabScreenState extends State<ResearchLabScreen> {
  final TextEditingController _researchController = TextEditingController();
  final ScientificResearchService _researchService = ScientificResearchService();
  
  bool _isResearchRunning = false;
  String _currentStatus = '';
  List<String> _progressLog = [];
  ResearchReport? _currentReport;

  void _addToProgressLog(String message) {
    setState(() {
      _progressLog.add('${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second} - $message');
    });
  }

  void _startScientificResearch() async {
    if (_researchController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('براہ کرم تحقیق کا موضوع درج کریں')),
      );
      return;
    }

    setState(() {
      _isResearchRunning = true;
      _progressLog.clear();
      _currentReport = null;
      _currentStatus = 'تحقیق شروع ہو رہی ہے...';
    });

    _addToProgressLog('🚀 سائنسی تحقیق کا آغاز');
    
    try {
      // Step 1: Research AI
      _addToProgressLog('🧠 Research AI: تحقیقی منصوبہ بندی');
      setState(() => _currentStatus = 'Research AI کام کر رہا ہے...');
      await Future.delayed(Duration(seconds: 2));

      // Step 2: Lab AI
      _addToProgressLog('🔬 Lab AI: وائرچوئل تجربات');
      setState(() => _currentStatus = 'لیب میں تجربات چل رہے ہیں...');
      await Future.delayed(Duration(seconds: 3));

      // Step 3: Analysis AI
      _addToProgressLog('📊 Analysis AI: ڈیٹا کا تجزیہ');
      setState(() => _currentStatus = 'نتائج کا تجزیہ ہو رہا ہے...');
      await Future.delayed(Duration(seconds: 2));

      // Final Research Report
      final report = await _researchService.executeFullResearchPipeline(
        _researchController.text
      );

      setState(() {
        _isResearchRunning = false;
        _currentReport = report;
        _currentStatus = 'تحقیق مکمل ہو گئی!';
      });

      _addToProgressLog('✅ تحقیق کامیابی کے ساتھ مکمل ہو گئی');
      _addToProgressLog('📄 رپورٹ تیار ہے: ${report.researchPlan.topic}');

    } catch (e) {
      setState(() {
        _isResearchRunning = false;
        _currentStatus = 'تحقیق میں مسئلہ آیا';
      });
      _addToProgressLog('❌ تحقیق میں خرابی: $e');
    }
  }

  void _showResearchReport() {
    if (_currentReport == null) return;

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
                  'سائنسی تحقیقاتی رپورٹ',
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
                    // Research Topic
                    _buildReportSection(
                      'تحقیق کا موضوع',
                      _currentReport!.researchPlan.topic,
                      Icons.science,
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Hypothesis
                    _buildReportSection(
                      'سائنسی مفروضہ', 
                      _currentReport!.researchPlan.hypothesis,
                      Icons.lightbulb,
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Methodology
                    _buildReportSection(
                      'طریقہ کار',
                      _currentReport!.researchPlan.methodology,
                      Icons.list_alt,
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Lab Results
                    _buildReportSection(
                      'لیب کے نتائج',
                      _currentReport!.labResults.observations,
                      Icons.biotech,
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Analysis
                    _buildReportSection(
                      'شماریاتی تجزیہ',
                      _currentReport!.analysis,
                      Icons.analytics,
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Recommendations
                    _buildReportSection(
                      'تجاویز',
                      _currentReport!.recommendations.join('\n• '),
                      Icons.recommend,
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Save as PDF functionality
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('PDF محفوظ ہو گئی')),
                              );
                            },
                            icon: Icon(Icons.picture_as_pdf),
                            label: Text('PDF محفوظ کریں'),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.share),
                            label: Text('شیئر کریں'),
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
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
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
        title: Text('AI سائنسی لیب'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Research Input Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'سائنسی تحقیق کا موضوع درج کریں',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _researchController,
                      decoration: InputDecoration(
                        hintText: 'مثال: ذیابیطس کا نیا علاج، کینسر کی نئی دوا وغیرہ',
                        border: OutlineInputBorder(),
                        labelText: 'تحقیق کا موضوع',
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'مثالیں:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildExampleChip('ذیابیطس کا علاج'),
                        _buildExampleChip('کینسر کی نئی دوا'),
                        _buildExampleChip('دل کی بیماریوں کا علاج'),
                        _buildExampleChip('ورم کا نیا علاج'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Research Status
            if (_isResearchRunning || _progressLog.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تحقیقی عمل کی صورتحال',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12),
                      if (_isResearchRunning)
                        LinearProgressIndicator(),
                      SizedBox(height: 8),
                      Text(
                        _currentStatus,
                        style: TextStyle(
                          color: _isResearchRunning ? Colors.blue : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 150,
                        child: ListView.builder(
                          itemCount: _progressLog.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Icon(Icons.play_arrow, size: 16),
                              title: Text(_progressLog[index]),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],

            // Research Results
            if (_currentReport != null) ...[
              Card(
                color: Colors.green[50],
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.verified, size: 48, color: Colors.green),
                      SizedBox(height: 8),
                      Text(
                        'تحقیق مکمل ہو گئی!',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('موضوع: ${_currentReport!.researchPlan.topic}'),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _showResearchReport,
                        child: Text('مکمل رپورٹ دیکھیں'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],

            // Start Research Button
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isResearchRunning ? null : _startScientificResearch,
                    icon: Icon(_isResearchRunning ? Icons.hourglass_empty : Icons.play_arrow),
                    label: Text(
                      _isResearchRunning ? 'تحقیق جاری ہے...' : 'سائنسی تحقیق شروع کریں',
                      style: TextStyle(fontSize: 16),
                    ),
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

  Widget _buildExampleChip(String text) {
    return GestureDetector(
      onTap: () {
        _researchController.text = text;
      },
      child: Chip(
        label: Text(text),
        backgroundColor: Colors.blue[100],
      ),
    );
  }
}
