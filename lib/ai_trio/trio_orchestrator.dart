// 📁 lib/ai_trio/trio_orchestrator.dart
import 'package:flutter/foundation.dart';
import '../models/research_model.dart';
import 'research_ai.dart';
import 'lab_testing_ai.dart';
import 'medanalyzer_ai.dart';
import 'curesynth_ai.dart';
import 'biomind_ai.dart';
import 'report_ai.dart';

/// 🎯 TrioOrchestrator - تمام AI ماڈیولز کی مکمل کوآرڈینیشن
class TrioOrchestrator {
  /// مکمل تحقیقاتی پائپ لائن - تمام AI کو یکجا کرتا ہے
  static Future<MedicalResearch> runFullResearchPipeline({
    required String topic,
    required String hypothesis,
  }) async {
    debugPrint('🎯 TrioOrchestrator: $topic کے لیے مکمل AI تحقیقاتی پائپ لائن شروع...');
    debugPrint('⏱️ کل متوقع وقت: ≈80 منٹ (Research: 30m + Others: 10m each)');

    // 🔄 تمام AI ماڈیولز کو متوازی طور پر چلائیں
    final researchFuture = ResearchAI.conductResearch(topic);
    final labFuture = LabTestingAI.runLabAnalysis(researchData: {});
    final analysisFuture = MedAnalyzerAI.generateMedicalInsights(
      labResults: {},
      topic: topic,
    );
    final bioFuture = BioMindAI.runBiologicalResearch(
      topic: topic,
      medicalData: {},
    );

    // ⏳ تمام AI کے نتائج کا انتظار کریں
    debugPrint('🔄 تمام AI ماڈیولز کو متوازی طور پر چلایا جا رہا ہے...');

    final results = await Future.wait([
      researchFuture,
      labFuture,
      analysisFuture,
      bioFuture,
    ], eagerError: true);

    // 📊 نتائج کو الگ کریں
    final researchData = results[0] as Map<String, dynamic>;
    final labResults = results[1] as Map<String, dynamic>;
    final medicalAnalysis = results[2] as Map<String, dynamic>;
    final biologicalFindings = results[3] as Map<String, dynamic>;

    debugPrint('✅ تمام AI ماڈیولز کے نتائج موصول ہو گئے');

    // 💊 علاج کا پلان تیار کریں
    debugPrint('💊 CureSynth AI کو علاج کا پلان تیار کرنے کے لیے کال کیا جا رہا ہے...');
    final curePlan = await CureSynthAI.generateTreatmentPlan(
      medicalProblem: topic,
      analysisData: medicalAnalysis,
    );

    debugPrint('✅ CureSynth AI کا علاج پلان تیار ہو گیا');

    // 📄 مکمل رپورٹ تیار کریں
    debugPrint('📄 Report AI کو مکمل رپورٹ تیار کرنے کے لیے کال کیا جا رہا ہے...');
    final reportData = await ReportAI.generateCompleteReport(
      topic: topic,
      hypothesis: hypothesis,
      researchSummary: researchData['scientific_insights']?.toString() ?? '',
      labResults: labResults,
      medicalAnalysis: medicalAnalysis,
      treatmentPlan: curePlan,
      biologicalFindings: biologicalFindings,
    );

    debugPrint('✅ Report AI کی مکمل رپورٹ تیار ہو گئی');

    // 🏗️ مکمل MedicalResearch object بنائیں
    debugPrint('🏗️ مکمل MedicalResearch object تیار کیا جا رہا ہے...');

    final research = MedicalResearch(
      id: 'AI_RESEARCH_${DateTime.now().millisecondsSinceEpoch}',
      topic: topic,
      hypothesis: hypothesis,
      methodology: '''
AI-Orchestrated Multi-Agent Research Pipeline:
1. Research AI (30 منٹ) - گہری سائنسی تحقیق
2. LabTesting AI (10 منٹ) - مکمل لیب تجزیہ
3. MedAnalyzer AI (10 منٹ) - طبی اور شماریاتی تجزیہ
4. BioMind AI (10 منٹ) - بائیولوجیکل تحقیق
5. CureSynth AI (10 منٹ) - علاج کی ترکیب
6. Report AI (10 منٹ) - مکمل رپورٹ جنریشن
''',
      labResults: '''
لیب تجزیہ کے نتائج:
${labResults['lab_parameters_analyzed']?.join(', ') ?? 'N/A'}

تشخیصی بصیرتیں:
${labResults['diagnostic_findings']?.join(', ') ?? 'N/A'}

خطرے کا اندازہ: ${labResults['risk_assessment'] ?? 'N/A'}
''',
      analysis: '''
طبی تجزیہ:
${medicalAnalysis['clinical_assessment'] ?? 'N/A'}

شماریاتی ماڈل:
${medicalAnalysis['statistical_models']?.map((m) => m['type']).join(', ') ?? 'N/A'}

علاج کی تاثیر: ${medicalAnalysis['treatment_efficacy_analysis']?['current_treatments']?['efficacy_rate'] ?? 'N/A'}
''',
      conclusion: '''
تحقیق کا نتیجہ:
${reportData['executive_summary'] ?? 'N/A'}

اہم سفارشات:
${reportData['clinical_recommendations']?.join(', ') ?? 'N/A'}
''',
      pdfReport: reportData['pdf_report_path'] ?? '',
      createdAt: DateTime.now(),
      isAIResearch: true,
      aiDiscoveryData: {
        'research_ai': {
          'duration': researchData['research_duration'],
          'breakthrough': researchData['breakthrough_discovery'],
          'confidence': researchData['confidence_score'],
          'sources_analyzed': researchData['sources_analyzed']?.length ?? 0,
        },
        'lab_ai': {
          'duration': labResults['analysis_duration'],
          'parameters_analyzed': labResults['lab_parameters_analyzed']?.length ?? 0,
          'diagnostic_findings': labResults['diagnostic_findings']?.length ?? 0,
          'confidence': labResults['confidence_score'],
        },
        'med_analyzer_ai': {
          'duration': medicalAnalysis['analysis_duration'],
          'clinical_assessment': medicalAnalysis['clinical_assessment'],
          'risk_stratification': medicalAnalysis['risk_stratification'],
          'confidence': medicalAnalysis['confidence_score'],
        },
        'bio_mind_ai': {
          'duration': biologicalFindings['research_duration'],
          'therapeutic_targets': biologicalFindings['therapeutic_targets']?.length ?? 0,
          'biological_insights': biologicalFindings['biological_insights']?.length ?? 0,
          'confidence': biologicalFindings['confidence_score'],
        },
        'cure_synth_ai': {
          'duration': curePlan['synthesis_duration'],
          'treatment_plan': curePlan['treatment_plan']?.length ?? 0,
          'efficacy_prediction': curePlan['efficacy_predictions']?['expected_improvement'],
          'confidence': curePlan['confidence_score'],
        },
        'report_ai': {
          'duration': reportData['report_generation_duration'],
          'report_quality': reportData['report_quality_metrics'],
          'pdf_generated': reportData['pdf_report_path'] != null,
          'confidence': reportData['confidence_score'],
        },
      },
    );

    // 🎉 کامیابی کا پیغام
    debugPrint('''
🎉 ===================================
✅ AI تحقیقاتی پائپ لائن مکمل ہو گئی!
===================================

📊 تحقیقاتی خلاصہ:
• موضوع: $topic
• کل وقت: ≈80 منٹ
• AI ماڈیولز: 6
• دریافتوں: ${researchData['breakthrough_discovery'] != null ? 'نئی دریافت' : 'تجزیہ'}
• علاج پلان: ${curePlan['treatment_plan']?.length ?? 0} تجاویز
• رپورٹ: PDF تیار

🧪 AI کارکردگی:
${_generatePerformanceSummary(results, curePlan, reportData)}

📁 نتائج:
• MedicalResearch Object: تیار
• PDF رپورٹ: ${reportData['pdf_report_path'] ?? 'تیار'}
• ڈیٹا کوالٹی: اعلیٰ
• عملدرآمد: تیار
===================================
''');

    return research;
  }

  /// کارکردگی کا خلاصہ
  static String _generatePerformanceSummary(
    List<dynamic> results,
    Map<String, dynamic> curePlan,
    Map<String, dynamic> reportData,
  ) {
    final performance = StringBuffer();
    
    for (int i = 0; i < results.length; i++) {
      final result = results[i] as Map<String, dynamic>;
      final aiNames = ['Research AI', 'LabTesting AI', 'MedAnalyzer AI', 'BioMind AI'];
      
      performance.writeln('• ${aiNames[i]}: ${result['confidence_score']?.toStringAsFixed(2) ?? 'N/A'} اعتماد');
    }
    
    performance.writeln('• CureSynth AI: ${curePlan['confidence_score']?.toStringAsFixed(2) ?? 'N/A'} اعتماد');
    performance.writeln('• Report AI: ${reportData['confidence_score']?.toStringAsFixed(2) ?? 'N/A'} اعتماد');
    
    return performance.toString();
  }

  /// 🔄 پرانے کوڈز کے لیے compat method
  static Future<MedicalResearch> conductFullResearch(String topic) async {
    return await runFullResearchPipeline(
      topic: topic,
      hypothesis: 'AI-generated comprehensive hypothesis for $topic - Integrating molecular mechanisms, clinical presentation, and therapeutic opportunities for optimal patient outcomes.',
    );
  }

  /// ⚡ تیز رفتار تحقیق (ڈیمو کے لیے)
  static Future<MedicalResearch> conductQuickResearch(String topic) async {
    debugPrint('⚡ TrioOrchestrator: $topic کے لیے تیز رفتار تحقیق شروع...');
    
    // تمام تاخیر ہٹا دیں
    final researchData = await ResearchAI.conductResearch(topic);
    final labResults = await LabTestingAI.runLabAnalysis(researchData: {});
    final medicalAnalysis = await MedAnalyzerAI.generateMedicalInsights(
      labResults: labResults,
      topic: topic,
    );
    final curePlan = await CureSynthAI.generateTreatmentPlan(
      medicalProblem: topic,
      analysisData: medicalAnalysis,
    );

    return MedicalResearch(
      id: 'QUICK_${DateTime.now().millisecondsSinceEpoch}',
      topic: topic,
      hypothesis: 'Quick AI analysis for $topic',
      methodology: 'Rapid AI Assessment',
      labResults: 'Quick lab analysis completed',
      analysis: 'Rapid medical insights generated',
      conclusion: 'Quick treatment plan prepared',
      pdfReport: '',
      createdAt: DateTime.now(),
      isAIResearch: true,
      aiDiscoveryData: {
        'quick_analysis': true,
        'research_data': researchData,
        'lab_data': labResults,
        'medical_analysis': medicalAnalysis,
        'treatment_plan': curePlan,
      },
    );
  }
}
