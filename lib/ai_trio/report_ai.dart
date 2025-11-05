
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/research_model.dart';
import '../utils/pdf_generator.dart';

class ReportAI {
  static Future<Map<String, dynamic>> generateCompleteReport({
    required Map<String, dynamic> researchData,
    required Map<String, dynamic> labResults,
    required String originalProblem,
    required int attempts,
    required String status,
  }) async {
    print('📊 REPORT AI: مکمل رپورٹ تیار کر رہا ہوں...');
    
    // رپورٹ جنریشن simulation
    await Future.delayed(Duration(seconds: 1));
    
    bool isSuccess = status == 'success';
    String diseaseType = researchData['disease_type'] ?? 'عام';
    
    Map<String, dynamic> report = {
      'generated_by': 'REPORT_AI',
      'report_id': 'AI_RPT${DateTime.now().millisecondsSinceEpoch}',
      'report_title': 'AI ٹرائیو تحقیقاتی رپورٹ',
      'patient_problem': originalProblem,
      'report_date': DateTime.now().toString(),
      'executive_summary': _generateSummary(isSuccess, diseaseType, attempts),
      
      'research_findings': {
        'discovered_treatment': researchData['treatment_name'],
        'root_cause': researchData['root_cause'],
        'confidence_level': '${(researchData['confidence_score'] * 100).toStringAsFixed(1)}%',
        'research_ai_notes': 'ریسرچ AI نے بیماری کی بنیادی وجہ دریافت کی ہے',
        'medicine_composition': researchData['medicine_composition'],
      },
      
      'lab_results': {
        'test_status': labResults['success'] ? 'پاس' : 'فیل',
        'efficacy': '${(labResults['efficacy_score'] * 100).toStringAsFixed(1)}%',
        'safety': '${(labResults['safety_score'] * 100).toStringAsFixed(1)}%',
        'bioavailability': '${(labResults['bioavailability'] * 100).toStringAsFixed(1)}%',
        'side_effects': labResults['side_effects'],
        'issues_found': labResults['issues_found'],
        'lab_ai_notes': labResults['lab_notes']
      },
      
      'treatment_protocol': _generateTreatmentProtocol(researchData, isSuccess),
      
      'final_recommendation': isSuccess ? 
          '✅ یہ علاج محفوظ اور مؤثر ہے۔ کلینیکل ٹرائلز کے لیے تیار ہے۔' : 
          '⚠️ علاج میں مزید تحقیق اور بہتری کی ضرورت ہے۔',
      
      'next_steps': _getNextSteps(isSuccess, attempts),
      
      'ai_team_notes': '''
🤖 AI ٹرائیو ٹیم کی رپورٹ:
• ریسرچ AI: علاج دریافت کرنے میں کامیاب
• لیب ٹیسٹنگ AI: ${labResults['success'] ? 'ٹیسٹ پاس' : 'ٹیسٹ فیل'}  
• رپورٹ AI: مکمل رپورٹ تیار کر دی
کل تحقیقاتی دور: $attempts
''',
      
      // نیا: PDF کے لیے خصوصی ڈیٹا
      'pdf_metadata': {
        'is_ai_research': true,
        'ai_team_used': true,
        'research_iterations': attempts,
        'success_status': isSuccess,
        'generated_timestamp': DateTime.now().millisecondsSinceEpoch,
      }
    };

    // نیا: MedicalResearch object بھی بنائیں PDF کے لیے
    final medicalResearch = _convertToResearchModel(report, researchData, labResults);
    report['medical_research_object'] = medicalResearch;

    return report;
  }

  // نیا method: AI رپورٹ کو MedicalResearch میں تبدیل کریں
  static MedicalResearch _convertToResearchModel(
    Map<String, dynamic> aiReport, 
    Map<String, dynamic> researchData,
    Map<String, dynamic> labResults
  ) {
    return MedicalResearch(
      id: aiReport['report_id'] ?? 'AI_${DateTime.now().millisecondsSinceEpoch}',
      topic: aiReport['patient_problem'] ?? 'AI تحقیقاتی رپورٹ',
      hypothesis: aiReport['research_findings']?['root_cause'] ?? 'AI دریافت کردہ بنیادی وجہ',
      methodology: _generateMethodologyText(aiReport, researchData),
      labResults: _formatLabResults(aiReport['lab_results']),
      analysis: _generateAnalysisText(aiReport, labResults),
      conclusion: aiReport['final_recommendation'] ?? 'AI سفارش',
      pdfReport: _generateTextReport(aiReport),
      createdAt: DateTime.now(),
      isAIResearch: true,
      aiDiscoveryData: aiReport, // مکمل AI ڈیٹا محفوظ کریں
    );
  }

  static String _generateMethodologyText(Map<String, dynamic> aiReport, Map<String, dynamic> researchData) {
    return '''
AI ٹرائیو تحقیقاتی طریقہ کار:

1. ریسرچ AI: بیماری کی بنیادی وجہ دریافت کرنا
2. لیب ٹیسٹنگ AI: علاج کی جانچ اور تصدیق
3. رپورٹ AI: مکمل رپورٹ تیار کرنا

دریافت شدہ علاج: ${researchData['treatment_name']}
اعتماد کی سطح: ${(researchData['confidence_score'] * 100).toStringAsFixed(1)}%
''';
  }

  static String _generateAnalysisText(Map<String, dynamic> aiReport, Map<String, dynamic> labResults) {
    return '''
AI تجزیہ کے نتائج:

لیب ٹیسٹنگ نتائج:
- تاثیر: ${(labResults['efficacy_score'] * 100).toStringAsFixed(1)}%
- حفاظت: ${(labResults['safety_score'] * 100).toStringAsFixed(1)}%
- حیاتیاتی دستیابی: ${(labResults['bioavailability'] * 100).toStringAsFixed(1)}%

ضمنی اثرات: ${labResults['side_effects'].join(', ')}
''';
  }

  static String _formatLabResults(Map<String, dynamic> labResults) {
    return '''
لیبارٹری ٹیسٹنگ کے نتائج:

ٹیسٹ کی حیثیت: ${labResults['test_status']}
تاثیر کا اسکور: ${labResults['efficacy']}
حفاظت کا اسکور: ${labResults['safety']}
حیاتیاتی دستیابی: ${labResults['bioavailability']}

مسائل: ${labResults['issues_found']?.join(', ') ?? 'کوئی مسئلہ نہیں'}
تجاویز: ${labResults['lab_ai_notes']}
''';
  }

  static String _generateTextReport(Map<String, dynamic> aiReport) {
    return '''
AI ٹرائیو تحقیقاتی رپورٹ
========================

مریض کا مسئلہ: ${aiReport['patient_problem']}

خلاصہ:
${aiReport['executive_summary']}

تحقیقی نتائج:
- دریافت شدہ علاج: ${aiReport['research_findings']?['discovered_treatment']}
- بنیادی وجہ: ${aiReport['research_findings']?['root_cause']}
- اعتماد: ${aiReport['research_findings']?['confidence_level']}

لیب نتائج:
- ٹیسٹ حیثیت: ${aiReport['lab_results']?['test_status']}
- تاثیر: ${aiReport['lab_results']?['efficacy']}
- حفاظت: ${aiReport['lab_results']?['safety']}

آخری سفارش:
${aiReport['final_recommendation']}

اگلے اقدامات:
${aiReport['next_steps']?.join('\n')}

تاریخ: ${aiReport['report_date']}
''';
  }

  // نیا method: PDF جنریشن کے لیے
  static Future<String> generatePDFReport({
    required Map<String, dynamic> aiReport,
    required String language,
    required BuildContext context,
  }) async {
    try {
      print('📄 PDF جنریشن شروع کر رہا ہوں... زبان: $language');
      
      // AI رپورٹ سے MedicalResearch object حاصل کریں
      final MedicalResearch research = aiReport['medical_research_object'];
      
      // آپ کے موجودہ PDFGenerator کو استعمال کریں
      final pdfFile = await PDFGenerator.generatePDF(
        research: research,
        language: language,
        context: context,
      );
      
      print('✅ PDF کامیابی سے تیار ہو گیا: ${pdfFile.path}');
      return pdfFile.path;
      
    } catch (e) {
      print('❌ PDF جنریشن میں مسئلہ: $e');
      rethrow;
    }
  }

  // Helper methods
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
📋 خوراک کی ہدایات:
- صبح: 1 کیپسول ناشتے کے بعد
- شام: 1 کیپسول کھانے کے بعد
- دورانیہ: ${research['medicine_composition']['duration']}
- احتیاط: دوائیں ڈاکٹر کے مشورے سے استعمال کریں
''',
      'expected_results': '''
📈 متوقع نتائج:
- 30 دن: بنیادی علامات میں 50% بہتری
- 60 دن: 75% تک بہتری
- 90 دن: مکمل بحالی کا امکان
''',
      'precautions': 'حاملہ خواتین اور چھوٹے بچے ڈاکٹر کے مشورے سے استعمال کریں۔'
    };
  }

  static List<String> _getNextSteps(bool isSuccess, int attempts) {
    if (isSuccess) {
      return [
        'کلینیکل ٹرائلز کے لیے تیار کریں',
        'ضروری منظوریاں حاصل کریں',
        'مریضوں پر آزمائیں',
        'تجاویز کو حتمی شکل دیں'
      ];
    } else if (attempts >= 3) {
      return [
        'مزید جدید AI ماڈلز استعمال کریں',
        'انٹرنیشنل ریسرچ سے مدد لیں',
        'مریض کی مزید تفصیلات حاصل کریں',
        'مختلف زاویوں سے تحقیق کریں'
      ];
    } else {
      return [
        'علاج میں بہتری کریں',
        'خوراک میں تبدیلی کریں',
        'متبادل اجزاء آزمائیں',
        'دوبارہ لیب ٹیسٹنگ کریں'
      ];
    }
  }
}
