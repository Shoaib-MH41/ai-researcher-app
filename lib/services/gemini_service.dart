class GeminiService {
  static String? _apiKey;
  
  static void setApiKey(String key) {
    _apiKey = key;
  }
  
  Future<String> generateMedicalResearch(String topic) async {
    await Future.delayed(Duration(seconds: 2));
    return 'Medical Research Analysis for: $topic';
  }
  
  // Missing methods شامل کریں
  Future<bool> testConnection() async {
    try {
      await Future.delayed(Duration(seconds: 1));
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<void> saveApiKey(String key) async {
    _apiKey = key;
  }
  
  Future<void> removeApiKey() async {
    _apiKey = null;
  }
}
