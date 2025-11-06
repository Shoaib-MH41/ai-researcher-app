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

  /// 🧬 نیا میتھڈ: trio_orchestrator کے لیے compat میتھڈ
  static Future<Map<String, dynamic>> runBiologicalResearch({
    required String topic,
    required dynamic medicalData,
  }) async {
    print('🧬 BioMind AI: بائیولوجیکل ریسرچ شروع کر رہا ہوں...');

    await Future.delayed(const Duration(seconds: 2));

    final random = Random();
    final confidence = 0.8 + random.nextDouble() * 0.2; // 80%–100%

    // بائیولوجیکل فیکٹرز کی شناخت
    final biologicalFactors = _identifyBiologicalFactors(topic);
    final geneticMarkers = _generateGeneticMarkers(topic);
    final cellularProcesses = _analyzeCellularProcesses(topic);

    print('✅ BioMind AI: بائیولوجیکل ریسرچ مکمل');

    return {
      'ai_name': 'BioMind AI',
      'topic': topic,
      'status': 'completed',
      'biological_factors': biologicalFactors,
      'genetic_markers': geneticMarkers,
      'cellular_processes': cellularProcesses,
      'confidence_score': confidence,
      'summary': 'BioMind AI نے $topic کے بائیولوجیکل پہلوؤں کا تجزیہ کیا ہے۔',
      'ai_notes': 'یہ تجزیہ بیماری کے بائیولوجیکل میکانزمز پر مرکوز ہے۔',
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

  /// 🔬 بائیولوجیکل فیکٹرز کی شناخت
  static List<String> _identifyBiologicalFactors(String topic) {
    final factors = {
      'cancer': ['خلیاتی تقسیم', 'جینیاتی تغیرات', 'امیون سسٹم', 'خلیاتی موت'],
      'diabetes': ['انسولین', 'گلوکوز میٹابولزم', 'لبلبہ', 'خلیاتی حساسیت'],
      'heart': ['دل کے پٹھے', 'خون کی شریانیں', 'کولیسٹرول', 'بلڈ پریشر'],
      'default': ['خلیاتی عمل', 'جینیاتی اظہار', 'میٹابولک راستے', 'امیون ردعمل'],
    };

    if (topic.toLowerCase().contains('cancer')) return factors['cancer']!;
    if (topic.toLowerCase().contains('diabetes')) return factors['diabetes']!;
    if (topic.toLowerCase().contains('heart')) return factors['heart']!;
    
    return factors['default']!;
  }

  /// 🧬 جینیاتی مارکرز جنریٹ کریں
  static List<String> _generateGeneticMarkers(String topic) {
    final markers = [
      'BRCA1/BRCA2',
      'TP53',
      'APOE',
      'CFTR',
      'HLA',
      'ACE',
      'FTO',
      'MTHFR'
    ];

    final random = Random();
    return markers.sublist(0, 3 + random.nextInt(2)); // 3-4 markers
  }

  /// 🔍 سیلولر پروسیسز کا تجزیہ
  static List<String> _analyzeCellularProcesses(String topic) {
    return [
      'خلیاتی تقسیم اور نمو',
      'پروٹین سنتھیس',
      'توانائی کا استعمال',
      'خلیاتی موت ( apoptosis )',
      'سگنل ٹرانسمیشن',
      'ڈی این اے مرمت'
    ];
  }
}
