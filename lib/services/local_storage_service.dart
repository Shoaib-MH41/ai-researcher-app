import '../models/research_model.dart';

class LocalStorageService {
  static List<MedicalResearch> _researchList = [];

  static Future<void> saveResearch(MedicalResearch research) async {
    // Check if research with same ID already exists
    _researchList.removeWhere((r) => r.id == research.id);
    
    // Add new research to the beginning of list
    _researchList.insert(0, research);
    
    // Limit to last 50 researches to prevent memory issues
    if (_researchList.length > 50) {
      _researchList = _researchList.sublist(0, 50);
    }
    
    print('Research saved: ${research.topic} (Total: ${_researchList.length})');
  }

  static Future<List<MedicalResearch>> getResearchHistory() async {
    // Return sorted by date (newest first)
    _researchList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return _researchList;
  }

  static Future<MedicalResearch?> getResearchById(String researchId) async {
    try {
      return _researchList.firstWhere((research) => research.id == researchId);
    } catch (e) {
      return null;
    }
  }

  static Future<void> deleteResearch(String researchId) async {
    final initialLength = _researchList.length;
    _researchList.removeWhere((research) => research.id == researchId);
    
    if (initialLength > _researchList.length) {
      print('Research deleted: $researchId');
    } else {
      print('Research not found: $researchId');
    }
  }

  static Future<void> clearAllResearch() async {
    final count = _researchList.length;
    _researchList.clear();
    print('All research cleared ($count items removed)');
  }

  static Future<int> getResearchCount() async {
    return _researchList.length;
  }

  // نیا method: Search research by topic
  static Future<List<MedicalResearch>> searchResearch(String query) async {
    if (query.isEmpty) {
      return await getResearchHistory();
    }
    
    final lowerQuery = query.toLowerCase();
    return _researchList.where((research) =>
      research.topic.toLowerCase().contains(lowerQuery) ||
      research.hypothesis.toLowerCase().contains(lowerQuery) ||
      research.conclusion.toLowerCase().contains(lowerQuery)
    ).toList();
  }
}
