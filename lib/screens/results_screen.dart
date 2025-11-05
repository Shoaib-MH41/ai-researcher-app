import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart'; // 🔹 For sharing
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../models/research_model.dart';
import '../utils/pdf_generator.dart';
import '../utils/language_utils.dart';

class ResultsScreen extends StatelessWidget {
  final MedicalResearch research;
  final bool isAIResearch; // نیا parameter - AI تحقیق کی نشاندہی
  final Map<String, dynamic>? aiResearchData; // نیا - AI سائنسدان کا ڈیٹا

  const ResultsScreen({
    Key? key, 
    required this.research,
    this.isAIResearch = false, // ڈیفالٹ false
    this.aiResearchData, // optional AI data
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isAIResearch ? 'AI سائنسدان رپورٹ' : 'تحقیقات کے نتائج'),
        backgroundColor: isAIResearch ? Colors.purple[700] : Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareResults(context),
            tooltip: 'نتائج شئیر کریں',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AI سائنسدان انڈیکیٹر - نیا addition
              if (isAIResearch) _buildAIScientistHeader(),

              Card(
                color: isAIResearch ? Colors.purple[50] : Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isAIResearch ? 'AI سائنسی رپورٹ' : 'تحقیقاتی رپورٹ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isAIResearch ? Colors.purple : Colors.blue,
                            ),
                          ),
                          Text(
                            'آئی ڈی: ${research.id.substring(0, 8)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        research.topic,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isAIResearch ? Colors.purpleAccent : Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'تاریخ تخلیق: ${_formatDate(research.createdAt)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      // AI سٹیٹس - نیا addition
                      if (isAIResearch && aiResearchData != null) 
                        _buildAIStatusBadge(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // AI سائنسدان کے اضافی سیکشن - نیا addition
              if (isAIResearch && aiResearchData != null) 
                _buildAIResearchSections(),

              // Research Sections
              _buildSectionWithIcon(
                'مفروضہ',
                Icons.lightbulb_outline,
                Colors.orange,
                research.hypothesis,
              ),
              _buildSectionWithIcon(
                'طریقہ کار',
                Icons.list_alt,
                Colors.green,
                research.methodology,
              ),
              _buildSectionWithIcon(
                'لیب کے نتائج',
                Icons.biotech,
                Colors.purple,
                research.labResults,
              ),
              _buildSectionWithIcon(
                'ڈیٹا کا تجزیہ',
                Icons.analytics,
                Colors.blue,
                research.analysis,
              ),
              _buildSectionWithIcon(
                'نتیجہ',
                Icons.verified,
                Colors.green,
                research.conclusion,
              ),

              const SizedBox(height: 24),
              _buildActionButtons(context),
              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Text(
                  isAIResearch ?
                  'یہ رپورٹ AI سائنسدان سسٹم کے ذریعے تیار کی گئی ہے۔ '
                  'مستقبل میں AI APIs کنیکٹ ہوں گی مزید بہتر تجزیے کے لیے۔'
                  :
                  'یہ رپورٹ AI میڈیکل ریسرچ سسٹم کے ذریعے تیار کی گئی ہے۔ '
                  'طبی مشورے کے لیے براہ کرم ہیلتھ کیئر پروفیشنلز سے رابطہ کریں۔',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPDFLanguageDialog(context),
        backgroundColor: isAIResearch ? Colors.purple : Colors.red,
        tooltip: 'PDF ڈاؤن لوڈ کریں',
        child: const Icon(Icons.picture_as_pdf, color: Colors.white),
      ),
    );
  }

  // ========== نیا AI سائنسدان ویجیٹس ==========

  // AI سائنسدان ہیڈر
  Widget _buildAIScientistHeader() {
    return Card(
      color: Colors.purple[100],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.science, color: Colors.purple[700]),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🔬 AI سائنسدان تحقیقی رپورٹ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[800],
                    ),
                  ),
                  Text(
                    'مستقبل کے لیے تیار - APIs کنیکشن کے منتظر',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.purple[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // AI سٹیٹس بیج
  Widget _buildAIStatusBadge() {
    final source = aiResearchData!['source'] ?? 'mock_data';
    final isMockData = source == 'mock_data' || source == 'ai_scientist_mock';
    
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isMockData ? Colors.orange[100] : Colors.green[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMockData ? Colors.orange : Colors.green,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isMockData ? Icons.schedule : Icons.check_circle,
            size: 14,
            color: isMockData ? Colors.orange : Colors.green,
          ),
          SizedBox(width: 4),
          Text(
            isMockData ? 'Mock ڈیٹا - APIs تیار' : 'AI APIs کنیکٹڈ',
            style: TextStyle(
              fontSize: 12,
              color: isMockData ? Colors.orange[800] : Colors.green[800],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // AI تحقیقی سیکشن
  Widget _buildAIResearchSections() {
    final researchSummary = aiResearchData!['research_summary'] ?? {};
    
    return Column(
      children: [
        // AI تجزیہ
        if (researchSummary['ai_analysis'] != null)
          _buildAISectionWithIcon(
            'AI تجزیہ',
            Icons.psychology,
            Colors.deepPurple,
            researchSummary['ai_analysis'].toString(),
          ),

        // لیب کے نتائج
        if (researchSummary['lab_findings'] != null)
          _buildAISectionWithIcon(
            'AI لیب ٹیسٹنگ',
            Icons.biotech,
            Colors.pink,
            _formatLabFindings(researchSummary['lab_findings']),
          ),

        // شماریاتی انسائٹس
        if (researchSummary['statistical_insights'] != null)
          _buildAISectionWithIcon(
            'شماریاتی انسائٹس',
            Icons.trending_up,
            Colors.teal,
            _formatStatisticalInsights(researchSummary['statistical_insights']),
          ),

        // مستقبل کی تحقیق
        if (researchSummary['future_research_directions'] != null)
          _buildAISectionWithIcon(
            'مستقبل کی تحقیق',
            Icons.arrow_forward,
            Colors.blue,
            _formatFutureResearch(researchSummary['future_research_directions']),
          ),
      ],
    );
  }

  // AI سیکشن بلڈر
  Widget _buildAISectionWithIcon(
    String title,
    IconData icon,
    Color color,
    String content,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          color: color.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.grey[700],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ========== ہیلپر فنکشنز ==========

  String _formatLabFindings(dynamic labFindings) {
    if (labFindings is Map) {
      return '''
لیب ٹیسٹس: ${labFindings['lab_tests_performed']?.join(', ') ?? 'N/A'}
نتائج: ${labFindings['results'] ?? 'N/A'}
اعتماد کی سطح: ${labFindings['confidence_level'] ?? 'N/A'}
تجاویز: ${labFindings['recommendations'] ?? 'N/A'}
''';
    }
    return labFindings.toString();
  }

  String _formatStatisticalInsights(dynamic insights) {
    if (insights is Map) {
      return '''
نمونہ کا سائز: ${insights['sample_size'] ?? 'N/A'}
اعتماد کا وقفہ: ${insights['confidence_interval'] ?? 'N/A'}
P ویلیو: ${insights['p_value'] ?? 'N/A'}
اہمیت: ${insights['significance'] ?? 'N/A'}
رجحانات: ${insights['trends']?.join(', ') ?? 'N/A'}
''';
    }
    return insights.toString();
  }

  String _formatFutureResearch(dynamic futureResearch) {
    if (futureResearch is List) {
      return futureResearch.map((item) => '• $item').join('\n');
    }
    return futureResearch.toString();
  }

  // 🔹 Section Builder (اصل کوڈ)
  Widget _buildSectionWithIcon(
    String title,
    IconData icon,
    Color color,
    String content,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.grey[700],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 🔹 Action Buttons
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _showPDFLanguageDialog(context),
            icon: const Icon(Icons.picture_as_pdf, size: 20),
            label: const Text('PDF محفوظ کریں'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isAIResearch ? Colors.purple : Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.add, size: 20),
            label: const Text('نئی تحقیق'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} کو ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  // 🔹 PDF Language Dialog
  void _showPDFLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isAIResearch ? "AI سائنسی رپورٹ PDF" : "PDF زبان منتخب کریں", 
          textAlign: TextAlign.center
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(context, 'english', 'English', '🇺🇸', Colors.blue),
            _buildLanguageOption(context, 'urdu', 'اردو', '🇵🇰', Colors.green),
            _buildLanguageOption(context, 'arabic', 'عربي', '🇸🇦', Colors.orange),
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
          Navigator.pop(context);
          await _generatePDF(context, langCode);
        },
      ),
    );
  }

  // 🔹 Generate PDF + Auto Share
  Future<void> _generatePDF(BuildContext context, String language) async {
    try {
      // 🔸 اب generatePDF ایک File ریٹرن کرتا ہے
      final File pdfFile = await PDFGenerator.generatePDF(
        research: research,
        language: language,
        context: context,
      );

      if (await pdfFile.exists()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF کامیابی سے ڈاؤن لوڈ ہو گیا!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // 🔥 Auto Share PDF
        await Share.shareXFiles(
          [XFile(pdfFile.path)],
          text: isAIResearch ?
            'AI سائنسدان تحقیقی رپورٹ (${LanguageUtils.getNativeLanguageName(language)})' :
            'AI میڈیکل ریسرچ رپورٹ (${LanguageUtils.getNativeLanguageName(language)})',
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF ڈاؤن لوڈ میں مسئلہ: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // 🔹 Text Share Button
  void _shareResults(BuildContext context) {
    final shareText = isAIResearch ? '''
🔬 AI سائنسدان تحقیقی رپورٹ
موضوع: ${research.topic}
مفروضہ: ${research.hypothesis}
نتیجہ: ${research.conclusion}
📅 تاریخ: ${_formatDate(research.createdAt)}

AI سائنسدان سسٹم کے ذریعے تیار کردہ
''' : '''
🔬 تحقیقاتی رپورٹ
موضوع: ${research.topic}
مفروضہ: ${research.hypothesis}
نتیجہ: ${research.conclusion}
📅 تاریخ: ${_formatDate(research.createdAt)}

AI میڈیکل ریسرچ سسٹم کے ذریعے تیار کردہ
''';
    Share.share(shareText);
  }
}
