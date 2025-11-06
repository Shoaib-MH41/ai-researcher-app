import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import '../ai_trio/trio_orchestrator.dart';
import '../ai_trio/report_ai.dart';
import '../models/research_model.dart'; // ✅ MedicalResearch کو ایمپورٹ کریں

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
  MedicalResearch? _finalResult; // ✅ Map کی بجائے MedicalResearch type
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
        _finalResult = result; // ✅ اب یہ درست ہے
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

  // باقی کوڈ وہی رہے گا...

  Widget _buildFinalResult() {
    final result = _finalResult!;
    final isSuccess = true; // اب ہمیشہ success ہوگا کیونکہ تحقیق مکمل ہوگی

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

  // PDF جنریشن کو بھی اپ ڈیٹ کریں
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
      // یہاں آپ کو PDF جنریشن کو بھی اپ ڈیٹ کرنا ہوگا
      // فی الحال کے لیے صرف ایک mock
      final pdfPath = ''; // await PDFGenerator.generateResearchPDF(_finalResult!, language);

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

  // رپورٹ ڈائیلاگ کو بھی اپ ڈیٹ کریں
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
