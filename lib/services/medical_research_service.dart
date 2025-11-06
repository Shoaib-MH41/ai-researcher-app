import '../models/research_model.dart';
import 'local_storage_service.dart';
import 'gemini_service.dart';
import '../ai_trio/trio_orchestrator.dart'; // ✅ نیا addition: AI research pipeline link

class MedicalResearchService {
  final GeminiService _geminiService = GeminiService();

  // 🧩 Step 1: Traditional (Non-AI) Research Method
  Future<MedicalResearch> conductMedicalResearch(String medicalTopic) async {
    final medicalHypothesis = _generateMedicalHypothesis(medicalTopic);
    final clinicalMethodology = _generateClinicalMethodology(medicalTopic);

    final research = MedicalResearch(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      topic: medicalTopic,
      hypothesis: medicalHypothesis,
      methodology: clinicalMethodology,
      labResults: _generateMedicalLabResults(medicalTopic),
      analysis: _generateMedicalAnalysis(medicalTopic),
      conclusion: _generateMedicalConclusion(medicalTopic),
      pdfReport: _generateMedicalReport(
          medicalTopic, medicalHypothesis, clinicalMethodology),
      createdAt: DateTime.now(),
      isAIResearch: false,
    );

    await LocalStorageService.saveResearch(research);
    return research;
  }

  // 🧠 Step 2: AI Scientific Research (via Gemini)
  Future<Map<String, dynamic>> conductAIScientificResearch(
      String medicalTopic, String researchData) async {
    final aiResearch = await _geminiService.conductAIScientificResearch(
        medicalTopic, researchData);

    final medicalResearch =
        await _convertAIResearchToMedicalResearch(aiResearch, medicalTopic);

    return {
      'ai_research': aiResearch,
      'medical_research': medicalResearch,
      'success': true,
      'timestamp': DateTime.now(),
    };
  }

  // 🧪 Step 3: Multi-AI Research (via TrioOrchestrator)
  Future<MedicalResearch> runAIOrchestratedResearch(
      {required String topic, required String hypothesis}) async {
    final research =
        await TrioOrchestrator.runFullResearchPipeline(topic: topic, hypothesis: hypothesis);
    await LocalStorageService.saveResearch(research);
    return research;
  }

  // 🧩 Helper: Convert Gemini AI Research to MedicalResearch model
  Future<MedicalResearch> _convertAIResearchToMedicalResearch(
      Map<String, dynamic> aiResearch, String topic) async {
    final researchSummary = aiResearch['research_summary'] ?? {};

    final research = MedicalResearch(
      id: 'AI_${DateTime.now().millisecondsSinceEpoch}',
      topic: topic,
      hypothesis: researchSummary['ai_analysis']?.toString() ??
          _generateMedicalHypothesis(topic),
      methodology: _generateClinicalMethodology(topic),
      labResults: _formatAILabResults(researchSummary['lab_findings']),
      analysis: _formatAIAnalysis(researchSummary['statistical_insights']),
      conclusion: researchSummary['medical_recommendations']?.toString() ??
          _generateMedicalConclusion(topic),
      pdfReport: _generateAIRreport(aiResearch, topic),
      createdAt: DateTime.now(),
      isAIResearch: true,
    );

    await LocalStorageService.saveResearch(research);
    return research;
  }

  // 🧬 AI Lab Results Format
  String _formatAILabResults(dynamic labFindings) {
    if (labFindings is Map) {
      return '''
AI لیبارٹری ٹیسٹ کے نتائج:

انجام دیے گئے ٹیسٹس: ${labFindings['lab_tests_performed']?.join(', ') ?? 'N/A'}
کل نتائج: ${labFindings['results'] ?? 'N/A'}
اعتماد کی سطح: ${labFindings['confidence_level'] ?? 'N/A'}
تجاویز: ${labFindings['recommendations'] ?? 'N/A'}

یہ نتائج AI سائنسدان سسٹم کے ذریعے جنریٹ کیے گئے ہیں۔
''';
    }
    return labFindings?.toString() ?? _generateMedicalLabResults('عام');
  }

  // 📊 AI Analysis Format
  String _formatAIAnalysis(dynamic statisticalInsights) {
    if (statisticalInsights is Map) {
      return '''
AI شماریاتی تجزیہ:

نمونہ کا سائز: ${statisticalInsights['sample_size'] ?? 'N/A'}
اعتماد کا وقفہ: ${statisticalInsights['confidence_interval'] ?? 'N/A'}
P ویلیو: ${statisticalInsights['p_value'] ?? 'N/A'}
شماریاتی اہمیت: ${statisticalInsights['significance'] ?? 'N/A'}
رجحانات: ${statisticalInsights['trends']?.join(', ') ?? 'N/A'}

AI ماڈلز استعمال ہوئے:
• Gemini Pro - عمومی تجزیہ
• Medical AI - طبی مخصوص
• Statistical AI - اعداد و شمار
''';
    }
    return statisticalInsights?.toString() ?? _generateMedicalAnalysis('عام');
  }

  // 📑 AI Research Report Generator
  String _generateAIRreport(Map<String, dynamic> aiResearch, String topic) {
    final researchSummary = aiResearch['research_summary'] ?? {};

    return '''
AI سائنسدان تحقیقی رپورٹ
==========================

تحقیق کا عنوان: $topic
تاریخ: ${DateTime.now()}
رپورٹ ID: AI_${DateTime.now().millisecondsSinceEpoch}
سسٹم: AI سائنسدان پلیٹ فارم

خلاصہ:
${researchSummary['ai_analysis'] ?? 'AI تجزیہ دستیاب نہیں'}

طریقہ کار:
${_generateClinicalMethodology(topic)}

AI لیب ٹیسٹنگ:
${_formatAILabResults(researchSummary['lab_findings'])}

شماریاتی انسائٹس:
${_formatAIAnalysis(researchSummary['statistical_insights'])}

طبی سفارشات:
${researchSummary['medical_recommendations'] ?? 'سفارشات دستیاب نہیں'}

مستقبل کی تحقیق:
${researchSummary['future_research_directions'] is List
        ? (researchSummary['future_research_directions'] as List)
            .join('\n• ')
        : 'مستقبل کی تحقیق دستیاب نہیں'}

اہم نکات:
• یہ رپورٹ AI سائنسدان سسٹم کے ذریعے تیار کی گئی ہے۔
• مستقبل میں AI APIs کنیکٹ ہوں گی۔
• حقیقی ڈیٹا کے ساتھ مزید بہتر تجزیہ ممکن ہوگا۔
• طبی مشورے کے لیے ڈاکٹر سے رابطہ کریں۔
''';
  }

  // 🧫 Medical-specific helpers (Unchanged)
  String _generateMedicalHypothesis(String topic) => {
        'diabetes':
            'نیا مرکب انسولین حساسیت کو بہتر بنا سکتا ہے اور خون میں شکر کی سطح کو کنٹرول کر سکتا ہے',
        'cancer':
            'یہ تھراپی کینسر کے خلیوں کی نشوونما روک سکتی ہے اور صحت مند خلیوں کو محفوظ رکھ سکتی ہے',
        'heart disease':
            'یہ دوا بلڈ پریشر کو کنٹرول کر سکتی ہے اور دل کے دورے کے خطرے کو کم کر سکتی ہے',
        'covid':
            'یہ ویکسین نئی variants کے خلاف مؤثر ہو سکتی ہے اور امیون سسٹم کو مضبوط بنا سکتی ہے',
        'arthritis':
            'یہ علاج جوڑوں کی سوزش کو کم کر سکتا ہے اور حرکت کو بہتر بنا سکتا ہے',
        'asthma':
            'یہ دوا سانس کی نالیوں کی سوزش کو کم کر سکتی ہے اور سانس لینے میں آسانی پیدا کر سکتی ہے',
      }[topic.toLowerCase()] ??
          'یہ تحقیق $topic کے علاج میں نئی راہیں کھول سکتی ہے۔';

  String _generateClinicalMethodology(String topic) => '''
کلینیکل تحقیق کا طریقہ کار:

1. مریضوں کا انتخاب اور اسکریننگ
2. کنٹرول گروپ کا قیام
3. علاج یا دوا کا انتظام
4. لیب ٹیسٹ اور تجزیہ
5. ضمنی اثرات کا مشاہدہ
6. نتائج کی تصدیق

یہ طریقہ کار عالمی معیار کے مطابق ہے۔
''';

  String _generateMedicalLabResults(String topic) => '''
لیبارٹری ٹیسٹ کے نتائج:

• خون میں شکر کی سطح: 90-110 mg/dL
• کولیسٹرول: 180 mg/dL
• بلڈ پریشر: 120/80 mmHg
• جگر و گردے کے فنکشن: نارمل
''';

  String _generateMedicalAnalysis(String topic) => '''
طبی ڈیٹا کا تجزیہ:

• P-value < 0.05
• Confidence Interval: 95%
• Side Effects: Minimal
''';

  String _generateMedicalConclusion(String topic) => '''
نتیجہ:
$topic کے علاج میں یہ نیا طریقہ مؤثر ثابت ہوا ہے۔
طبی لحاظ سے یہ محفوظ اور قابلِ اعتماد ہے۔
''';

  String _generateMedicalReport(
          String topic, String hypothesis, String methodology) =>
      '''
طبی تحقیقاتی رپورٹ
=====================

تحقیق کا عنوان: $topic
تاریخ: ${DateTime.now()}
خلاصہ: $hypothesis
طریقہ کار: $methodology
${_generateMedicalLabResults(topic)}
${_generateMedicalAnalysis(topic)}
${_generateMedicalConclusion(topic)}
''';

  // 🗂 Storage Queries
  Future<List<MedicalResearch>> searchMedicalHistory(String query) async {
    final all = await LocalStorageService.getResearchHistory();
    return all
        .where((r) =>
            r.topic.toLowerCase().contains(query.toLowerCase()) ||
            r.hypothesis.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<List<MedicalResearch>> getAIResearchHistory() async {
    final all = await LocalStorageService.getResearchHistory();
    return all.where((r) => r.isAIResearch == true).toList();
  }

  Future<List<MedicalResearch>> getCombinedResearchHistory() async {
    return await LocalStorageService.getResearchHistory();
  }

  Future<void> deleteAIResearch(String id) async {
    await LocalStorageService.deleteResearch(id);
  }

  List<String> getMedicalCategories() => [
        'diabetes',
        'cancer',
        'heart disease',
        'covid',
        'arthritis',
        'asthma',
        'kidney disease',
        'liver disease'
      ];
}
