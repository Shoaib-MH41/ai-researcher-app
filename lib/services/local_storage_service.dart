import 'dart:convert';
import '../models/research_model.dart';

class LocalStorageService {
  static const String _researchKey = 'research_history';
  
  // In real app, use shared_preferences package
  // For now, using in-memory storage
  
  static List<ResearchResult> _researchHistory = [];
  
  static Future<void> saveResearch(ResearchResult research) async {
    _researchHistory.add(research);
    // In real implementation:
    // final prefs = await SharedPreferences.getInstance();
    // String encodedData = jsonEncode(_researchHistory.map((r) => r.toJson()).toList());
    // await prefs.setString(_researchKey, encodedData);
  }
  
  static Future<List<ResearchResult>> getResearchHistory() async {
    // In real implementation:
    // final prefs = await SharedPreferences.getInstance();
    // String? researchData = prefs.getString(_researchKey);
    // if (researchData != null) {
    //   List<dynamic> decoded = jsonDecode(researchData);
    //   return decoded.map((item) => ResearchResult.fromJson(item)).toList();
    // }
    return _researchHistory;
  }
  
  static Future<void> deleteResearch(int index) async {
    if (index >= 0 && index < _researchHistory.length) {
      _researchHistory.removeAt(index);
      // Save to persistent storage in real implementation
    }
  }
  
  static Future<void> clearAllResearch() async {
    _researchHistory.clear();
    // Clear from persistent storage in real implementation
  }
}
