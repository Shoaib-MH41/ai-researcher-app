import '../models/research_model.dart';
import 'gemini_service.dart';
import 'local_storage_service.dart';

class MedicalResearchService {
  
  Future<MedicalResearch> conductMedicalResearch(String topic) async {
    // Step 1: Generate research plan
    String researchPlan = "Medical research plan for $topic";
    
    // Step 2: Create medical research object
    final research = MedicalResearch(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      topic: topic,
      hypothesis: 'Medical hypothesis for $topic',
      methodology: 'Clinical trial simulation',
      labResults: 'Laboratory analysis completed',
      analysis: 'Statistical analysis completed',
      conclusion: 'Research successfully completed',
      pdfReport: 'PDF report content',
      createdAt: DateTime.now(),
    );
    
    // Step 3: Save to local storage
    await LocalStorageService.saveResearch(research);
    
    return research;
  }
}
  
  String _extractHypothesis(String researchPlan) {
    // Simple extraction - in real app, use better parsing
    if (researchPlan.contains('HYPOTHESIS:')) {
      return researchPlan.split('HYPOTHESIS:')[1].split('METHODOLOGY:')[0].trim();
    }
    return 'Medical hypothesis generated for research topic.';
  }
  
  String _extractMethodology(String researchPlan) {
    // Simple extraction - in real app, use better parsing
    if (researchPlan.contains('METHODOLOGY:')) {
      return researchPlan.split('METHODOLOGY:')[1].split('EXPECTED OUTCOMES:')[0].trim();
    }
    return 'Standard medical research methodology applied.';
  }
}
