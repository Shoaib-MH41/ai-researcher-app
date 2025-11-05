import 'package:flutter/material.dart';
import '../ai_trio/trio_orchestrator.dart';
import '../services/report_ai.dart'; // ReportAI کے لیے import شامل کریں
// import 'package:share_plus/share_plus.dart'; // اگر شیئر کرنا ہو تو

class DiscoveryScreen extends StatefulWidget {
  final String medicalProblem;

  const DiscoveryScreen({super.key, required this.medicalProblem});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  String _currentStatus = 'تحقیقات شروع ہو رہی ہیں...';
  int _currentAttempt = 1;
  bool _isLoading = true;
  Map<String, dynamic>? _finalResult;
  List<String> _progressLog = [];

  @override
  void initState() {
    super.initState();
    _startResearchProcess();
  }

  Future<void> _startResearchProcess() async {
    _addToLog('AI ٹرائیو تحقیقاتی عمل شروع کیا جا رہا ہے...');
    
    final result = await TrioOrchestrator.conductFullResearch(widget.medicalProblem);
    
    setState(() {
      _isLoading = false;
      _finalResult = result;
      _currentStatus = result['status'] == 'success' 
          ? 'تحقیق کامیاب!' 
          : 'تحقیق مکمل (مسائل ہیں)';
    });
    
    _addToLog(_currentStatus);
  }

  void _addToLog(String message) {
    setState(() {
      _progressLog.add('${DateTime.now().toString().substring(11, 19)}: $message');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI ٹرائیو ریسرچ لیب'),
        backgroundColor: Colors.deepPurple[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // مریض کا مسئلہ
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('مریض کا مسئلہ:', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(widget.medicalProblem, style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // تحقیقاتی سٹیٹس
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(_currentStatus, 
                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                         color: _getStatusColor())),
                    SizedBox(height: 10),
                    if (_isLoading) LinearProgressIndicator(),
                    SizedBox(height: 10),
                    Text('تحقیقاتی دور: $_currentAttempt/3'),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // AI ٹرائیو کی معلومات
            _buildAITrioInfo(),

            SizedBox(height: 16),

            // تحقیقاتی لاگ
            Expanded(
              child: _buildProgressLog(),
            ),

            SizedBox(height: 16),

            // اگر نتیجہ آگیا ہے
            if (_finalResult != null) 
              _buildFinalResult(),

            SizedBox(height: 16),

            // ایکشن بٹن
            if (!_isLoading)
              _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    if (_currentStatus.contains('کامیاب')) return Colors.green;
    if (_currentStatus.contains('مسائل')) return Colors.orange;
    return Colors.blue;
  }

  Widget _buildAITrioInfo() {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.groups, color: Colors.blue),
                SizedBox(width: 8),
                Text('AI ٹرائیو ٹیم', 
                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 12),
            _buildAIInfo('ریسرچ AI', 'نیا علاج دریافت کرتا ہے', Colors.blue),
            _buildAIInfo('لیب ٹیسٹنگ AI', 'علاج کی جانچ کرتا ہے', Colors.green),
            _buildAIInfo('رپورٹ AI', 'مکمل رپورٹ تیار کرتا ہے', Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildAIInfo(String name, String description, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(name.split(' ')[0]),
          ),
          SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 3,
            child: Text(description, style: TextStyle(color: Colors.grey[600])),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressLog() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.list_alt, color: Colors.grey),
                SizedBox(width: 8),
                Text('تحقیقاتی لاگ', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _progressLog.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      _progressLog[index],
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalResult() {
    final result = _finalResult!;
    final isSuccess = result['status'] == 'success';
    
    return Card(
      color: isSuccess ? Colors.green[50] : Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(isSuccess ? Icons.check_circle : Icons.warning,
                     color: isSuccess ? Colors.green : Colors.orange),
                SizedBox(width: 8),
                Text(
                  isSuccess ? 'علاج دریافت ہو گیا!' : 'مزید تحقیق کی ضرورت',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(result['message']),
            SizedBox(height: 10),
            Text('کل تحقیقاتی دور: ${result['attempts']}'),
            if (isSuccess) ...[
              SizedBox(height: 10),
              Text('دریافت شدہ علاج: ${result['treatment_name']}'),
              Text('اعتماد کی سطح: ${(result['confidence'] * 100).toStringAsFixed(1)}%'),
            ],
          ],
        ),
      ),
    );
  }

  // ========== نیا اپڈیٹڈ ایکشن بٹن ==========
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              _showReportDialog();
            },
            icon: Icon(Icons.visibility),
            label: Text('رپورٹ دیکھیں'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              _showPDFLanguageDialog();
            },
            icon: Icon(Icons.picture_as_pdf),
            label: Text('PDF ڈاؤن لوڈ'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // ========== نیا: PDF زبان ڈائیلاگ ==========
  void _showPDFLanguageDialog() {
    if (_finalResult == null) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("PDF زبان منتخب کریں", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(context, 'english', 'English', 'US', Colors.blue),
            _buildLanguageOption(context, 'urdu', 'اردو', 'PK', Colors.green),
            _buildLanguageOption(context, 'arabic', 'عربي', 'SA', Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String langCode,
    String language,
    String flag,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      child: ListTile(
        leading: Text(flag, style: const TextStyle(fontSize: 20)),
        title: Text(language, style: const TextStyle(fontWeight: FontWeight.bold)),
        tileColor: color.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onTap: () async {
          Navigator.pop(context); // ڈائیلاگ بند کریں
          await _generateAIPDF(langCode);
        },
      ),
    );
  }

  // ========== PDF جنریشن ==========
  Future<void> _generateAIPDF(String language) async {
    if (_finalResult == null) return;
    
    setState(() {
      _isLoading = true;
      _currentStatus = 'PDF تیار ہو رہا ہے ($language)...';
    });

    try {
      final pdfFilePath = await ReportAI.generatePDFReport(
        _finalResult!['final_report'],
        language,
      );

      setState(() {
        _isLoading = false;
        _currentStatus = 'PDF تیار!';
      });

      if (pdfFilePath.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF کامیابی سے تیار! فائل: $pdfFilePath'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'شیئر',
              onPressed: () {
                // await Share.shareXFiles([XFile(pdfFilePath)]);
              },
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _currentStatus = 'PDF میں خرابی';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF بنانے میں مسئلہ: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ========== رپورٹ ڈائیلاگ (پہلے سے موجود) ==========
  void _showReportDialog() {
    if (_finalResult == null) return;
    
    final report = _finalResult!['final_report'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تحقیقاتی رپورٹ'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('رپورٹ ID: ${report['report_id']}', 
                   style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(report['executive_summary']),
              SizedBox(height: 10),
              Text('آخری سفارش: ${report['final_recommendation']}',
                   style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('بند کریں'),
          ),
        ],
      ),
    );
  }
}
