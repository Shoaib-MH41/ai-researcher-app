import 'dart:convert';
import '../models/research_model.dart';

class LocalStorageService {
  static const String _researchKey = 'medical_research_history';
  static List<MedicalResearch> _researchList = [];

  // In real app, use shared_preferences package
  // For now, using in-memory storage
  
  static Future<void> saveResearch(MedicalResearch research) async {
    _researchList.add(research);
    
    // Real implementation would be:
    // final prefs = await SharedPreferences.getInstance();
    // String encodedData = jsonEncode(_researchList.map((r) => r.toJson()).toList());
    // await prefs.setString(_researchKey, encodedData);
  }

  static Future<List<MedicalResearch>> getResearchHistory() async {
    // Real implementation:
    // final prefs = await SharedPreferences.getInstance();
    // String? researchData = prefs.getString(_researchKey);
    // if (researchData != null) {
    //   List<dynamic> decoded = jsonDecode(researchData);
    //   return decoded.map((item) => MedicalResearch.fromJson(item)).toList();
    // }
    
    return _researchList;
  }

  static Future<void> deleteResearch(String researchId) async {
    _researchList.removeWhere((research) => research.id == researchId);
    
    // Save to persistent storage in real implementation
  }

  static Future<void> clearAllResearch() async {
    _researchList.clear();
    
    // Clear from persistent storage in real implementation
  }
}
