
import 'biomind_ai.dart';
import 'curesynth_ai.dart';
import 'medanalyzer_ai.dart';
import 'report_ai.dart';

class TrioOrchestrator {
  static Future<Map<String, dynamic>> conductMedicalResearch(String patientProblem) async {
    print('🚀 AI ٹرائیو: مکمل میڈیکل ریسرچ شروع کر رہا ہوں...');
    
    // 1. BioMind AI: بیماری کی تحقیق
    print('⏳ BioMind AI کام کر رہا ہے...');
    final diseaseResearch = await BioMindAI.researchDisease(patientProblem);
    
    // 2. CureSynth AI: علاج تخلیق
    print('⏳ CureSynth AI کام کر رہا ہے...');
    final treatment = await CureSynthAI.createTreatment(diseaseResearch);
    
    // 3. MedAnalyzer AI: ڈیٹا تجزیہ
    print('⏳ MedAnalyzer AI کام کر رہا ہے...');
    final analysis = await MedAnalyzerAI.analyzeMedicalData(patientProblem, diseaseResearch);
    
    // 4. MedReport AI: رپورٹ تیار
    print('⏳ MedReport AI کام کر رہا ہے...');
    final report = await ReportAI.generateCompleteReport(
      diseaseResearch: diseaseResearch,
      treatment: treatment,
      analysis: analysis,
      originalProblem: patientProblem,
    );
    
    return {
      'status': 'success',
      'ai_team_used': ['BioMind AI', 'CureSynth AI', 'MedAnalyzer AI', 'MedReport AI'],
      'final_report': report,
      'message': '🎉 چاروں AI نے مل کر مکمل میڈیکل ریسرچ مکمل کر لی!'
    };
  }
}
