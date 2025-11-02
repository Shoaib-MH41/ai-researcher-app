import 'package:flutter/material.dart';
import '../models/research_model.dart';
import '../utils/helpers.dart';

class ResearchService {
  static final List<ResearchResult> _researchHistory = [];
  
  Future<ResearchResult> analyzeResearch(String topic, BuildContext context) async {
    // Show loading
    await Helpers.showLoadingDialog(context, 'Analyzing Research...');
    
    // Simulate API processing
    await Future.delayed(Duration(seconds: 3));
    
    // Create research result
    final result = ResearchResult(
      topic: topic,
      summary: 'This research analyzes $topic. The findings suggest significant implications in the field. Future AI integration will provide more detailed analysis.',
      methodology: 'Comprehensive literature review and data analysis. AI-powered research methodology will be implemented when APIs are integrated.',
      findings: '1. Key finding one related to $topic.\\n2. Important discovery in the field.\\n3. Potential applications and future research directions.',
      date: DateTime.now(),
    );
    
    // Save to local storage
    _researchHistory.add(result);
    
    // Close loading dialog
    Navigator.of(context).pop();
    
    return result;
  }
  
  Future<List<ResearchResult>> getResearchHistory() async {
    // Return local storage data
    return _researchHistory;
  }
  
  Future<void> deleteResearch(int index) async {
    if (index >= 0 && index < _researchHistory.length) {
      _researchHistory.removeAt(index);
    }
  }
  
  Future<void> saveResearchToLocal(ResearchResult research) async {
    // Save to local storage (in real app, use shared_preferences)
    _researchHistory.add(research);
  }
}
