// lib/ai_trio/trio_orchestrator.dart
import 'research_ai.dart';
import 'lab_testing_ai.dart';
import 'report_ai.dart';

class TrioOrchestrator {
  static Future<Map<String, dynamic>> conductFullResearch(String medicalProblem) async {
    print('🚀 TRIO ORCHESTRATOR: تحقیقاتی عمل شروع کر رہا ہوں...');
    print('مریض کا مسئلہ: $medicalProblem');
    
    int maxAttempts = 3;
    int currentAttempt = 1;
    List<Map<String, dynamic>> researchHistory = [];
    
    while (currentAttempt <= maxAttempts) {
      print('\n=== 🔄 تحقیقاتی دور $currentAttempt/$maxAttempts ===');
      
      // 1. پہلا AI: ریسرچ کرے
      print('⏳ RESEARCH AI کام کر رہا ہے...');
      final research = await ResearchAI.discoverNovelTreatment(medicalProblem);
      researchHistory.add({
        'attempt': currentAttempt,
        'research': research,
        'timestamp': DateTime.now()
      });
      
      // 2. دوسرا AI: لیب ٹیسٹنگ کرے
      print('⏳ LAB TESTING AI کام کر رہا ہے...');
      final labTest = await LabTestingAI.testTreatment(research);
      
      // 3. اگر لیب ٹیسٹ کامیاب ہو
      if (labTest['success'] == true) {
        print('✅ لیب ٹیسٹ کامیاب! رپورٹ تیار کی جا رہی ہے...');
        
        // 4. تیسرا AI: رپورٹ بنائے
        final report = await ReportAI.generateCompleteReport(
          researchData: research,
          labResults: labTest,
          originalProblem: medicalProblem,
          attempts: currentAttempt,
          status: 'success',
        );
        
        return {
          'status': 'success',
          'attempts': currentAttempt,
          'final_report': report,
          'research_history': researchHistory,
          'message': '🎉 کامیابی! نیا علاج دریافت ہو گیا۔',
          'treatment_name': research['treatment_name'],
          'confidence': research['confidence_score'],
        };
      } else {
        print('❌ لیب ٹیسٹ ناکام۔ دوبارہ کوشش کر رہا ہوں...');
        print('مسائل: ${labTest['issues_found']}');
        
        currentAttempt++;
        
        if (currentAttempt > maxAttempts) {
          // آخری دور میں بھی ناکامی پر رپورٹ بنائیں
          print('⚠️ زیادہ سے زیادہ کوششوں کے باوجود ناکامی');
          final report = await ReportAI.generateCompleteReport(
            researchData: research,
            labResults: labTest,
            originalProblem: medicalProblem,
            attempts: maxAttempts,
            status: 'failed',
          );
          
          return {
            'status': 'failed',
            'attempts': maxAttempts,
            'final_report': report,
            'research_history': researchHistory,
            'message': '❌ زیادہ سے زیادہ تحقیقات کے باوجود کامیاب علاج دریافت نہیں ہو سکا۔',
            'last_treatment': research['treatment_name'],
            'issues': labTest['issues_found'],
          };
        }
        
        // اگلے دور کے لیے تھوڑا انتظار
        await Future.delayed(Duration(seconds: 1));
      }
    }
    
    return {
      'status': 'error', 
      'message': 'غیر متوقع مسئلہ پیش آیا',
      'attempts': 0,
    };
  }
}
