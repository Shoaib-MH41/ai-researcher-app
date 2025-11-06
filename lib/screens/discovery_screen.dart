import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import '../ai_trio/trio_orchestrator.dart';
import '../ai_trio/report_ai.dart';
import '../models/research_model.dart';

class DiscoveryScreen extends StatefulWidget {
  final String medicalProblem;

  const DiscoveryScreen({super.key, required this.medicalProblem});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  String _currentStatus = 'تحقیقات شروع ہو رہی ہیں...';
  int _currentAttempt = 0;
  final int _totalAttempts = 3;
  bool _isLoading = true;
  bool _isGeneratingPDF = false;
  MedicalResearch? _finalResult;
  List<String> _progressLog = [];

  @override
  void initState() {
    super.initState();
    _startResearchProcess();
  }

  Future<void> _startResearchProcess() async {
    _addToLog('AI ٹرائیو تحقیقاتی عمل شروع کیا جا رہا ہے...');

    try {
      final result = await TrioOrchestrator.conductFullResearch(widget.medicalProblem);

      setState(() {
        _isLoading = false;
        _finalResult = result;
        _currentAttempt = 1;
        _currentStatus = 'تحقیق کامیاب! ${result.topic}';
      });

      _addToLog(_currentStatus);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _currentStatus = 'خطا: $e';
      });
      _addToLog('خطا: $e');
    }
  }

  void _addToLog(String message) {
    setState(() {
      _progressLog.add('${DateTime.now().toString().substring(11, 19)}: $message');
    });
  }

  // ✅ BUILD METHOD واپس شامل کیا
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI ٹرائیو ریسرچ لیب'),
        backgroundColor: Colors.deepPurple[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProblemCard(),
            const SizedBox(height: 16),
            _buildStatusCard(),
            const SizedBox(height: 16),
            _buildAITrioInfo(),
            const SizedBox(height: 16),
            Expanded(child: _buildProgressLog()),
            const SizedBox(height: 16),
            if (_finalResult != null) _buildFinalResult(),
            const SizedBox(height: 16),
            if (!_isLoading) _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProblemCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('مریض کا مسئلہ:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(widget.medicalProblem, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              _currentStatus,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _getStatusColor(),
              ),
            ),
            const SizedBox(height: 10),
            if (_isLoading || _isGeneratingPDF)
              const LinearProgressIndicator(),
            const SizedBox(height: 10),
            Text('تحقیقاتی دور: $_currentAttempt/$_totalAttempts'),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    if (_currentStatus.contains('کامیاب')) return Colors.green;
    if (_currentStatus.contains('خطا') || _currentStatus.contains('مسئلہ')) return Colors.red;
    if (_currentStatus.contains('مکمل')) return Colors.orange;
    return Colors.blue;
  }

  Widget _buildAITrioInfo() {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.groups, color: Colors.blue),
                SizedBox(width: 8),
                Text('AI ٹرائیو ٹیم', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            _buildAIInfo('ریسرچ AI', 'نیا علاج دریافت کرتا ہے', Colors.blue),
            _buildAIInfo('لیب ٹیسٹنگ AI', 'علاج کی جانچ کرتا ہے', Colors.green),
            _buildAIInfo('رپورٹ AI', 'مکمل رپورٹ تیار کرتا ہے', Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildAIInfo(String name, String desc, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6)),
            child: Text(name[0]),
          ),
          const SizedBox(width: 12),
          Expanded(
              flex: 2,
              child:
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              flex: 3,
              child: Text(desc, style: TextStyle(color: Colors.grey[600]))),
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
            const Row(
              children: [
                Icon(Icons.list_alt, color: Colors.grey),
                SizedBox(width: 8),
                Text('تحقیقاتی لاگ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _progressLog.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    _progressLog[index],
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalResult() {
    final result = _finalResult!;

    return Card(
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'تحقیق مکمل!',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('موضوع: ${result.topic}'),
            const SizedBox(height: 10),
            Text('ہائپوتھیسس: ${result.hypothesis}'),
            const SizedBox(height: 10),
            Text('طریقہ کار: ${result.methodology}'),
            if (result.isAIResearch) ...[
              const SizedBox(height: 10),
              Text('🔬 AI تحقیق', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _showReportDialog,
            icon: const Icon(Icons.visibility),
            label: const Text('رپورٹ دیکھیں'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isGeneratingPDF ? null : _showPDFLanguageDialog,
            icon: const Icon(Icons.picture_as_pdf),
            label: Text(_isGeneratingPDF ? 'تیار ہو رہا...' : 'PDF ڈاؤن لوڈ'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  void _showPDFLanguageDialog() {
    if (_finalResult == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('تحقیق کا ڈیٹا دستیاب نہیں ہے')));
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("PDF زبان منتخب کریں", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('english', 'English', '🇺🇸', Colors.blue),
            _buildLanguageOption('urdu', 'اردو', '🇵🇰', Colors.green),
            _buildLanguageOption('arabic', 'عربي', '🇸🇦', Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String code, String name, String flag, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      child: ListTile(
        leading: Text(flag, style: const TextStyle(fontSize: 20)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        tileColor: color.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onTap: () {
          Navigator.pop(context);
          _generateAIPDF(code);
        },
      ),
    );
  }

  Future<void> _generateAIPDF(String language) async {
    if (_finalResult == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('تحقیق کا ڈیٹا دستیاب نہیں ہے')));
      return;
    }

    setState(() {
      _isGeneratingPDF = true;
      _currentStatus = 'PDF تیار ہو رہا ہے ($language)...';
    });

    try {
      // فی الحال mock implementation
      final pdfPath = await ReportAI.generatePDFReport(
        language: language,
        context: context,
      );

      setState(() {
        _isGeneratingPDF = false;
        _currentStatus = 'PDF تیار ہو گیا!';
      });

      if (pdfPath.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('PDF کامیابی سے تیار ہو گیا!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isGeneratingPDF = false;
        _currentStatus = 'PDF بنانے میں مسئلہ';
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('PDF جنریشن میں مسئلہ: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _showReportDialog() {
    if (_finalResult == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('تحقیق کا ڈیٹا دستیاب نہیں ہے')));
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تحقیقاتی رپورٹ'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('تحقیق ID: ${_finalResult!.id}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('موضوع: ${_finalResult!.topic}'),
              const SizedBox(height: 10),
              Text('ہائپوتھیسس: ${_finalResult!.hypothesis}'),
              const SizedBox(height: 10),
              Text('نتیجہ: ${_finalResult!.conclusion}'),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('بند کریں')),
        ],
      ),
    );
  }
}
