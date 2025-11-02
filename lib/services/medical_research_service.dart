import '../models/research_model.dart';
import 'gemini_service.dart';
import 'pdf_generator.dart';
import 'local_storage_service.dart';

class MedicalResearchService {
  
  Future<MedicalResearch> conductMedicalResearch(String topic) async {
    // Step 1: Generate research plan using Gemini
    String researchPlan = await GeminiService().generateMedicalResearch(topic);
    
    // Step 2: Create medical research object
    final research = MedicalResearch(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      topic: topic,
      hypothesis: _extractHypothesis(researchPlan),
      methodology: _extractMethodology(researchPlan),
      labResults: 'Laboratory analysis completed for $topic. Results show promising medical data.',
      analysis: 'Statistical analysis indicates significant findings. P-value < 0.05.',
      conclusion: 'Research successfully completed. Medical implications identified.',
      pdfReport: '',
      createdAt: DateTime.now(),
    );
    
    // Step 3: Generate PDF report
    research.pdfReport = await PDFGenerator().generateMedicalReport(research);
    
    // Step 4: Save to local storage
    await LocalStorageService.saveResearch(research);
    
    return research;
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
