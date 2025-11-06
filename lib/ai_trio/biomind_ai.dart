// 📁 lib/ai_trio/biomind_ai.dart
import 'dart:math';

/// 🧠 BioMind AI
/// یہ AI مریض کے مسئلے کو سمجھنے، بیماری کی قسم (disease type) معلوم کرنے
/// اور ریسرچ کے لیے keywords تیار کرنے کا کام کرتا ہے۔
class BioMindAI {
  /// 🔍 مریض کے مسئلے کا ابتدائی تجزیہ
  static Future<Map<String, dynamic>> analyzePatientProblem(String problemDescription) async {
    print('🧠 BioMind AI: مسئلے کا تجزیہ کر رہا ہوں...');

    // Simulated delay for AI processing
    await Future.delayed(const Duration(seconds: 1));

    // ممکنہ بیماری کی اقسام
    final List<String> diseaseTypes = [
      'ذیابطیس',
      'ہائی بلڈ پریشر',
      'دمہ',
      'معدے کی خرابی',
      'جوڑوں کا درد',
      'جلد کی بیماری',
      'نیند کی کمی',
      'ذہنی دباؤ',
    ];

    // Random selection (AI simulation)
    final random = Random();
    final diseaseType = diseaseTypes[random.nextInt(diseaseTypes.length)];

    // Keywords نکالنا (بنیادی طور پر natural language processing کی simulation)
    final keywords = _extractKeywords(problemDescription);

    // AI اعتماد کی سطح (confidence)
    final confidence = 0.7 + random.nextDouble() * 0.3; // 70%–100%

    print('✅ BioMind AI: بیماری کا اندازہ => $diseaseType');

    return {
      'ai_name': 'BioMind AI',
      'status': 'analyzed',
      'problem': problemDescription,
      'disease_type': diseaseType,
      'confidence_score': confidence,
      'keywords': keywords,
      'ai_notes': 'BioMind AI نے مریض کی علامات کی بنیاد پر بیماری کی ابتدائی تشخیص کی ہے۔',
    };
  }

  /// 🧩 Keywords extract کرنے کا سادہ طریقہ
  static List<String> _extractKeywords(String text) {
    final words = text
        .replaceAll(RegExp(r'[^\u0600-\u06FFa-zA-Z0-9\s]'), '') // punctuation ہٹائیں
        .split(' ')
        .where((word) => word.trim().length > 3)
        .take(5)
        .toList();

    if (words.isEmpty) return ['علامات', 'بیماری', 'علاج', 'مسئلہ', 'تشخیص'];
    return words;
  }
}
