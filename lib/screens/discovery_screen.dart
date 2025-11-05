
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import '../ai_trio/trio_orchestrator.dart';
import '../services/report_ai.dart';

class DiscoveryScreen extends StatefulWidget {
  final String medicalProblem;

  const DiscoveryScreen({super.key, required this.medicalProblem});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  String _currentStatus = 'تحقیقات شروع ہو رہی ہیں...';
  int _currentAttempt = 0;
  int _totalAttempts = 3;
  bool _isLoading = true;
  bool _isGeneratingPDF = false; // نیا: PDF کے لیے
  Map<String, dynamic>? _finalResult;
  List<String> _progressLog = [];

  @override
  void initState() {
    super.initState();
    _startResearchProcess();
  }

  // ========== تحقیق شروع کریں ==========
  Future<void> _startResearchProcess() async {
    _addToLog('AI ٹرائیو تحقیقاتی عمل شروع کیا جا رہا ہے...');

    try {
      final result = await TrioOrchestrator.conductFullResearch(widget.medicalProblem);

      setState(() {
        _isLoading = false;
        _finalResult = result;
        _currentAttempt = result['attempts'] ?? 1;
        _currentStatus = result['status'] == 'success'
            ? 'تحقیق کامیاب!'
            : 'تحقیق مکمل (مزید کوشش درکار)';
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
            // مریض کا مسئلہ
            _buildProblemCard(),

            const SizedBox(height: 16),

            // تحقیقاتی سٹیٹس
            _buildStatusCard(),

            const SizedBox(height: 16),

            // AI ٹرائیو ٹیم
            _buildAITrioInfo(),

            const SizedBox(height: 16),

            // لاگ
            Expanded(child: _buildProgressLog()),

            const SizedBox(height: 16),

            // نتیجہ
            if (_finalResult != null) _buildFinalResult(),

            const SizedBox(height: 16),

            // ایکشن بٹن
            if (!_isLoading) _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  // ========== UI Widgets ==========
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
            decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
            child: Text(name[0]),
          ),
          const SizedBox(width: 12),
          Expanded(flex: 2, child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text(desc, style: TextStyle(color: Colors.grey[600]))),
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
                Text('تحقیقاتی لاگ', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _progressLog.length,
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(_progressLog[i], style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalResult() {
    final r = _finalResult!;
    final success = r['status'] == 'success';

    return Card(
      color: success ? Colors.green[50] : Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(success ? Icons.check_circle : Icons.warning, color: success ? Colors.green : Colors.orange),
                const SizedBox(width: 8),
                Text(
                  success ? 'علاج دریافت ہو گیا!' : 'مزید تحقیق کی ضرورت',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(r['message'] ?? ''),
            const SizedBox(height: 10),
            Text('کل تحقیقاتی دور: ${r['attempts']}'),
            if (success) ...[
              const SizedBox(height: 10),
              Text('دریافت شدہ علاج: ${r['treatment_name']}'),
              Text('اعتماد کی سطح: ${(r['confidence'] * 100).toStringAsFixed(1)}%'),
            ],
          ],
        ),
      ),
    );
  }

  // ========== ایکشن بٹن ==========
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _showReportDialog,
            icon: const Icon(Icons.visibility),
            label: const Text('رپورٹ دیکھیں'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isGeneratingPDF ? null : _showPDFLanguageDialog,
            icon: const Icon(Icons.picture_as_pdf),
            label: Text(_isGeneratingPDF ? 'تیار ہو رہا...' : 'PDF ڈاؤن لوڈ'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
          ),
        ),
      ],
    );
  }

  // ========== PDF زبان کا انتخاب ==========
  void _showPDFLanguageDialog() {
    if (_finalResult?['final_report'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('رپورٹ نہیں ملی')));
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("PDF زبان منتخب کریں", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLangOption('english', 'English', 'US', Colors.blue),
            _buildLangOption('urdu', 'اردو', 'PK', Colors.green),
            _buildLangOption('arabic', 'عربي', 'SA', Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildLangOption(String code, String name, String flag, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
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

  // ========== PDF جنریشن + شیئر ==========
  Future<void> _generateAIPDF(String language) async {
    setState(() {
      _isGeneratingPDF = true;
      _currentStatus = 'PDF تیار ہو رہا ہے ($language)...';
    });

    try {
      final report = _finalResult!['final_report'];
      final pdfPath = await ReportAI.generatePDFReport(report, language);

      setState(() {
        _isGeneratingPDF = false;
        _currentStatus = 'PDF تیار!';
      });

      if (pdfPath.isNotEmpty && await File(pdfPath).exists()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('PDF تیار ہو گیا!'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'شیئر',
              onPressed: () async {
                await Share.shareXFiles(
                  [XFile(pdfPath)],
                  text: 'AI ٹرائیو رپورٹ: ${report['patient_problem']}',
                );
              },
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isGeneratingPDF = false;
        _currentStatus = 'PDF میں خرابی';
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطا: $e'), backgroundColor: Colors.red));
    }
  }

  // ========== رپورٹ ڈائیلاگ ==========
  void _showReportDialog() {
    final report = _finalResult!['final_report'];
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تحقیقاتی رپورٹ'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('رپورٹ ID: ${report['report_id']}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(report['executive_summary'] ?? ''),
              const SizedBox(height: 10),
              Text('سفارش: ${report['final_recommendation']}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('بند کریں')),
        ],
      ),
    );
  }
}
