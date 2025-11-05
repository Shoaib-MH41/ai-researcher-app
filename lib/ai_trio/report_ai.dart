
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

import '../models/medical_research.dart'; // MedicalResearch model
import '../utils/pdf_generator.dart';   // آپ کا PDFGenerator (اگر ہے)
import '../utils/language_utils.dart';   // زبانوں کے لیے

class ReportAI {
  // ========== 1. مکمل رپورٹ جنریٹ کریں (simulation + data) ==========
  static Future<Map<String, dynamic>> generateCompleteReport({
    required Map<String, dynamic> researchData,
    required Map<String, dynamic> labResults,
    required String originalProblem,
    required int attempts,
    required String status,
  }) async {
    print('REPORT AI: مکمل رپورٹ تیار کر رہا ہوں...');
    await Future.delayed(Duration(seconds: 1));

    bool isSuccess = status == 'success';
    String diseaseType = researchData['disease_type'] ?? 'عام';

    final report = {
      'generated_by': 'REPORT_AI',
      'report_id': 'RPT${DateTime.now().millisecondsSinceEpoch}',
      'report_title': 'AI ٹرائیو تحقیقاتی رپورٹ',
      'patient_problem': originalProblem,
      'report_date': DateTime.now().toIso8601String(),
      'executive_summary': _generateSummary(isSuccess, diseaseType, attempts),

      'research_findings': {
        'discovered_treatment': researchData['treatment_name'],
        'root_cause': researchData['root_cause'],
        'confidence_level': '${(researchData['confidence_score'] * 100).toStringAsFixed(1)}%',
        'research_ai_notes': 'ریسرچ AI نے بیماری کی بنیادی وجہ دریافت کی ہے'
      },

      'lab_results': {
        'test_status': labResults['success'] ? 'پاس' : 'فیل',
        'efficacy': '${(labResults['efficacy_score'] * 100).toStringAsFixed(1)}%',
        'safety': '${(labResults['safety_score'] * 100).toStringAsFixed(1)}%',
        'bioavailability': '${(labResults['bioavailability'] * 100).toStringAsFixed(1)}%',
        'side_effects': labResults['side_effects'],
        'lab_ai_notes': labResults['lab_notes']
      },

      'treatment_protocol': _generateTreatmentProtocol(researchData, isSuccess),
      'final_recommendation': isSuccess
          ? 'یہ علاج محفوظ اور مؤثر ہے۔ کلینیکل ٹرائلز کے لیے تیار ہے۔'
          : 'علاج میں مزید تحقیق اور بہتری کی ضرورت ہے۔',
      'next_steps': _getNextSteps(isSuccess, attempts),
      'ai_team_notes': '''
AI ٹرائیو ٹیم کی رپورٹ:
• ریسرچ AI: علاج دریافت کرنے میں کامیاب
• لیب ٹیسٹنگ AI: ${labResults['success'] ? 'ٹیسٹ پاس' : 'ٹیسٹ فیل'}  
• رپورٹ AI: مکمل رپورٹ تیار کر دی
کل تحقیقاتی دور: $attempts
'''
    };

    // نیا: PDF تیار کرنے کا آپشن
    return {
      ...report,
      'pdf_ready': true,
      'languages': ['urdu', 'english', 'arabic'],
    };
  }

  // ========== 2. PDF جنریٹ کریں (زبان کے ساتھ) ==========
  static Future<String> generatePDFReport(
    Map<String, dynamic> reportData,
    String language,
  ) async {
    try {
      final pdf = pw.Document();

      // MedicalResearch میں تبدیل کریں
      final researchModel = _convertToResearchModel(reportData);

      // زبان کے مطابق فونٹ
      final font = language == 'urdu'
          ? await PdfGoogleFonts.cairoRegular()
          : await PdfGoogleFonts.robotoRegular();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  LanguageUtils.translate('AI ٹرائیو تحقیقاتی رپورٹ', language),
                  style: pw.TextStyle(font: font, fontSize: 20, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  '${LanguageUtils.translate('مریض کا مسئلہ', language)}: ${reportData['patient_problem']}',
                  style: pw.TextStyle(font: font),
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  LanguageUtils.translate('خلاصہ', language),
                  style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(reportData['executive_summary'], style: pw.TextStyle(font: font)),
                pw.SizedBox(height: 16),
                pw.Text(
                  LanguageUtils.translate('علاج', language),
                  style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  reportData['research_findings']['discovered_treatment'] ?? 'N/A',
                  style: pw.TextStyle(font: font),
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  LanguageUtils.translate('سفارش', language),
                  style: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(reportData['final_recommendation'], style: pw.TextStyle(font: font)),
              ],
            );
          },
        ),
      );

      // فائل سیو کریں
      final dir = await getApplicationDocumentsDirectory();
      final fileName = 'AI_Research_${reportData['report_id']}_$language.pdf';
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(await pdf.save());

      print('PDF محفوظ ہو گیا: ${file.path}');
      return file.path;
    } catch (e) {
      print('PDF جنریشن میں خرابی: $e');
      return '';
    }
  }

  // ========== 3. AI رپورٹ → MedicalResearch ==========
  static MedicalResearch _convertToResearchModel(Map<String, dynamic> aiReport) {
    return MedicalResearch(
      id: aiReport['report_id'] ?? 'AI_${DateTime.now().millisecondsSinceEpoch}',
      topic: aiReport['patient_problem'] ?? 'AI تحقیقاتی رپورٹ',
      hypothesis: aiReport['research_findings']?['root_cause'] ?? 'AI دریافت',
      methodology: 'AI ٹرائیو تحقیقاتی طریقہ کار',
      labResults: _formatLabResults(aiReport['lab_results']),
      analysis: aiReport['executive_summary'] ?? 'AI تجزیہ',
      conclusion: aiReport['final_recommendation'] ?? 'AI سفارش',
      pdfReport: _generateTextReport(aiReport),
      createdAt: DateTime.now(),
      isAIResearch: true,
      aiDiscoveryData: {
        'research_ai': aiReport['research_findings'],
        'lab_ai': aiReport['lab_results'],
        'report_ai': aiReport,
      },
    );
  }

  // ========== 4. مددگار فنکشنز ==========
  static String _formatLabResults(Map<String, dynamic>? lab) {
    if (lab == null) return 'کوئی نتائج نہیں';
    return '''
• کارکردگی: ${lab['efficacy']}
• حفاظت: ${lab['safety']}
• حیاتیاتی دستیابی: ${lab['bioavailability']}
• مضر اثرات: ${lab['side_effects'].join(', ')}
''';
  }

  static String _generateTextReport(Map<String, dynamic> report) {
    return '''
${report['report_title']}

مریض کا مسئلہ: ${report['patient_problem']}
تاریخ: ${report['report_date']}

${report['executive_summary']}

علاج: ${report['research_findings']['discovered_treatment']}
سفارش: ${report['final_recommendation']}
''';
  }

  static String _generateSummary(bool isSuccess, String diseaseType, int attempts) {
    if (isSuccess) {
      return 'AI ٹرائیو سسٹم نے $diseaseType کے لیے کامیابی سے نیا علاج دریافت کر لیا ہے۔ $attempts تحقیقاتی دور کے بعد لیب ٹیسٹنگ پاس ہو گئی ہے۔';
    } else {
      return 'AI ٹرائیو سسٹم $attempts تحقیقاتی دور کے باوجود $diseaseType کے لیے مکمل کامیاب علاج دریافت نہیں کر سکا۔ مزید تحقیق کی ضرورت ہے۔';
    }
  }

  static Map<String, dynamic> _generateTreatmentProtocol(Map<String, dynamic> research, bool isSuccess) {
    if (!isSuccess) {
      return {'status': 'غیر تجویز شدہ', 'reason': 'لیب ٹیسٹنگ ناکام'};
    }

    return {
      'medicine_name': research['treatment_name'],
      'composition': research['medicine_composition'],
      'dosage_instructions': '''
خوراک کی ہدایات:
- صبح: 1 کیپسول ناشتے کے بعد
- شام: 1 کیپسول کھانے کے بعد
- دورانیہ: ${research['medicine_composition']['duration']}
''',
      'expected_results': '''
متوقع نتائج:
- 30 دن: 50% بہتری
- 60 دن: 75% بہتری
- 90 دن: مکمل بحالی
''',
    };
  }

  static List<String> _getNextSteps(bool isSuccess, int attempts) {
    if (isSuccess) {
      return ['کلینیکل ٹرائلز', 'منظوریاں', 'مریضوں پر آزمائش'];
    } else if (attempts >= 3) {
      return ['جدید AI', 'بین الاقوامی مدد', 'مزید تفصیلات'];
    } else {
      return ['بہتری', 'خوراک تبدیل', 'دوبارہ ٹیسٹ'];
    }
  }
}
