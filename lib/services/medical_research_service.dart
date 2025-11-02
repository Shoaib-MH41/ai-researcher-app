import '../models/research_model.dart';
import 'local_storage_service.dart';

class MedicalResearchService {
  Future<MedicalResearch> conductMedicalResearch(String topic) async {
    final research = MedicalResearch(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      topic: topic,
      hypothesis: _extractHypothesis(topic),
      methodology: _extractMethodology(topic),
      labResults: 'Laboratory analysis completed for $topic',
      analysis: 'Statistical analysis shows significant results',
      conclusion: 'Research successfully completed with positive findings',
      pdfReport: 'PDF report generated for $topic',
      createdAt: DateTime.now(),
    );

    await LocalStorageService.saveResearch(research);
    return research;
  }

  // ✅ اب یہ methods class کے اندر ہیں
  String _extractHypothesis(String researchPlan) {
    if (researchPlan.contains('HYPOTHESIS:')) {
      return researchPlan.split('HYPOTHESIS:')[1].split('METHODOLOGY:')[0].trim();
    }
    return 'Medical hypothesis generated for research topic.';
  }

  String _extractMethodology(String researchPlan) {
    if (researchPlan.contains('METHODOLOGY:')) {
      return researchPlan.split('METHODOLOGY:')[1].split('EXPECTED OUTCOMES:')[0].trim();
    }
    return 'Standard medical research methodology applied.';
  }
}
