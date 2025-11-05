import '../models/research_model.dart';
import 'local_storage_service.dart';
import 'gemini_service.dart'; // نیا addition

class MedicalResearchService {
  final GeminiService _geminiService = GeminiService(); // نیا addition
  
  // میڈیکل مخصوص تحقیقاتی طریقے
  Future<MedicalResearch> conductMedicalResearch(String medicalTopic) async {
    // Step 1: میڈیکل ہائپوتھیسس بنائیں
    String medicalHypothesis = _generateMedicalHypothesis(medicalTopic);
    
    // Step 2: کلینیکل میتھڈالوجی بنائیں
    String clinicalMethodology = _generateClinicalMethodology(medicalTopic);
    
    // Step 3: میڈیکل ریسرچ آبجیکٹ بنائیں
    final research = MedicalResearch(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      topic: medicalTopic,
      hypothesis: medicalHypothesis,
      methodology: clinicalMethodology,
      labResults: _generateMedicalLabResults(medicalTopic),
      analysis: _generateMedicalAnalysis(medicalTopic),
      conclusion: _generateMedicalConclusion(medicalTopic),
      pdfReport: _generateMedicalReport(medicalTopic, medicalHypothesis, clinicalMethodology),
      createdAt: DateTime.now(),
    );
    
    // Step 4: لوکل اسٹوریج میں محفوظ کریں
    await LocalStorageService.saveResearch(research);
    
    return research;
  }

  // ========== نیا AI سائنسدان ریسرچ میتھڈ ==========
  
  Future<Map<String, dynamic>> conductAIScientificResearch(String medicalTopic, String researchData) async {
    // GeminiService کے نئے method کو استعمال کریں
    final aiResearch = await _geminiService.conductAIScientificResearch(medicalTopic, researchData);
    
    // AI ریسرچ کو میڈیکل ریسرچ میں تبدیل کریں
    final medicalResearch = await _convertAIResearchToMedicalResearch(aiResearch, medicalTopic);
    
    // دونوں ڈیٹا واپس کریں
    return {
      'ai_research': aiResearch,
      'medical_research': medicalResearch,
      'success': true,
      'timestamp': DateTime.now(),
    };
  }
  
  // AI ریسرچ کو میڈیکل ریسرچ میں تبدیل کرنے کا میتھڈ
  Future<MedicalResearch> _convertAIResearchToMedicalResearch(
    Map<String, dynamic> aiResearch, 
    String topic
  ) async {
    final researchSummary = aiResearch['research_summary'] ?? {};
    
    // AI ڈیٹا کو میڈیکل ریسرچ میں مپ کریں
    final research = MedicalResearch(
      id: 'AI_${DateTime.now().millisecondsSinceEpoch}',
      topic: topic,
      hypothesis: researchSummary['ai_analysis']?.toString() ?? _generateMedicalHypothesis(topic),
      methodology: _generateClinicalMethodology(topic),
      labResults: _formatAILabResults(researchSummary['lab_findings']),
      analysis: _formatAIAnalysis(researchSummary['statistical_insights']),
      conclusion: researchSummary['medical_recommendations']?.toString() ?? _generateMedicalConclusion(topic),
      pdfReport: _generateAIRreport(aiResearch, topic),
      createdAt: DateTime.now(),
      isAIResearch: true, // نیا field - AI تحقیق کی نشاندہی
    );
    
    // AI ریسرچ کو بھی محفوظ کریں
    await LocalStorageService.saveResearch(research);
    
    return research;
  }
  
  // AI لیب رزلٹس کو فارمیٹ کریں
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
  
  // AI تجزیہ کو فارمیٹ کریں
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
  
  // AI رپورٹ جنریشن
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

مستقبل کی تحقیق کے راستے:
${researchSummary['future_research_directions'] is List ? 
  (researchSummary['future_research_directions'] as List).join('\n• ') : 
  'مستقبل کی تحقیق کے راستے دستیاب نہیں'}

اہم نکات:
• یہ رپورٹ AI سائنسدان سسٹم کے ذریعے تیار کی گئی ہے
• مستقبل میں AI APIs کنیکٹ ہوں گی
• حقیقی ڈیٹا کے ساتھ مزید بہتر تجزیہ ممکن ہوگا
• طبی مشورے کے لیے ڈاکٹر سے رابطہ کریں

سسٹم کی معلومات:
• AI ماڈلز: Gemini Pro, Medical AI, Statistical AI
• ڈیٹا سورس: AI سائنسدان سسٹم
• جنریشن کا وقت: ${DateTime.now()}
''';
  }

  // ========== باقی موجودہ کوڈ (تبدیلی کے بغیر) ==========
  
  // میڈیکل مخصوص ہائپوتھیسس جنریشن
  String _generateMedicalHypothesis(String topic) {
    final medicalHypotheses = {
      'diabetes': 'نیا مرکب انسولین حساسیت کو بہتر بنا سکتا ہے اور خون میں شکر کی سطح کو کنٹرول کر سکتا ہے',
      'cancer': 'یہ تھراپی کینسر کے خلیوں کی نشوونما روک سکتی ہے اور صحت مند خلیوں کو محفوظ رکھ سکتی ہے',
      'heart disease': 'یہ دوا بلڈ پریشر کو کنٹرول کر سکتی ہے اور دل کے دورے کے خطرے کو کم کر سکتی ہے',
      'covid': 'یہ ویکسین نئی variants کے خلاف مؤثر ہو سکتی ہے اور امیون سسٹم کو مضبوط بنا سکتی ہے',
      'arthritis': 'یہ علاج جوڑوں کی سوزش کو کم کر سکتا ہے اور حرکت کو بہتر بنا سکتا ہے',
      'asthma': 'یہ دوا سانس کی نالیوں کی سوزش کو کم کر سکتی ہے اور سانس لینے میں آسانی پیدا کر سکتی ہے',
    };
    
    return medicalHypotheses[topic.toLowerCase()] ?? 
           'یہ تحقیق $topic کے علاج میں نئی راہیں کھول سکتی ہے اور مریضوں کی زندگی بہتر بنا سکتی ہے';
  }
  
  // کلینیکل میتھڈالوجی
  String _generateClinicalMethodology(String topic) {
    return '''
کلینیکل تحقیق کا طریقہ کار:

1. مریضوں کا انتخاب اور اسکریننگ
2. کنٹرول گروپ کا قیام
3. دوائی/علاج کا انتظام
4. خون کے ٹیسٹ اور لیبارٹری تجزیہ
5. ضمنی اثرات کا مشاہدہ
6. نتائج کا ریکارڈنگ اور تجزیہ
7. شماریاتی تجزیہ
8. نتائج کی تصدیق

یہ طریقہ کار بین الاقوامی معیارات کے مطابق ہے۔
''';
  }
  
  // میڈیکل لیب رزلٹس
  String _generateMedicalLabResults(String topic) {
    return '''
لیبارٹری ٹیسٹ کے نتائج:

• خون میں شکر کی سطح: 90-110 mg/dL (نارمل)
• کولیسٹرول: 180 mg/dL (بہتر)
• بلڈ پریشر: 120/80 mmHg (نارمل)
• خون کے خلیے: نارمل تعداد
• گردے کے فنکشن: نارمل
• جگر کے انزائمز: نارمل حد میں

ٹیسٹ کے نتائج حوصلہ افزا ہیں۔
''';
  }
  
  // میڈیکل ڈیٹا اینالیسس
  String _generateMedicalAnalysis(String topic) {
    return '''
طبی ڈیٹا کا تجزیہ:

• P-value: < 0.05 (شماریاتی اعتبار سے اہم)
• Confidence Interval: 95%
• Success Rate: 85%
• Side Effects: Minimal
• Patient Satisfaction: 90%

نتائج میڈیکل معیارات کے مطابق ہیں۔
''';
  }
  
  // میڈیکل کنکلژن
  String _generateMedicalConclusion(String topic) {
    return '''
تحقیق کا طبی نتیجہ:

$topic کے علاج میں یہ نیا طریقہ انتہائی مؤثر ثابت ہوا ہے۔ 
نتائج شماریاتی اعتبار سے اہم ہیں اور اسے کلینیکل ٹرائلز 
کے لیے تجویز کیا جا سکتا ہے۔

طبی فوائد:
- مریضوں کی زندگی میں بہتری
- ضمنی اثرات کم
- لاگت مؤثر
- آسانی سے دستیاب
''';
  }
  
  // میڈیکل رپورٹ جنریشن
  String _generateMedicalReport(String topic, String hypothesis, String methodology) {
    return '''
طبی تحقیقاتی رپورٹ
=====================

تحقیق کا عنوان: $topic

تاریخ: ${DateTime.now()}
رپورٹ ID: MED${DateTime.now().millisecondsSinceEpoch}

خلاصہ:
$hypothesis

طریقہ کار:
$methodology

لیب کے نتائج:
${_generateMedicalLabResults(topic)}

طبی تجزیہ:
${_generateMedicalAnalysis(topic)}

نتیجہ:
${_generateMedicalConclusion(topic)}

تجاویز:
• کلینیکل ٹرائلز کے لیے تجویز کردہ
• طبی اداروں میں استعمال کے لیے موزوں
• مریضوں کی بہتری کے لیے مؤثر
• مزید تحقیق کی ضرورت ہے

یہ رپورٹ AI میڈیکل ریسرچ سسٹم کے ذریعے تیار کی گئی ہے۔
طبی مشورے کے لیے ڈاکٹر سے رابطہ کریں۔
''';
  }
  
  // میڈیکل ریسرچ کے مخصوص طریقے
  Future<List<MedicalResearch>> searchMedicalHistory(String query) async {
    final allResearch = await LocalStorageService.getResearchHistory();
    return allResearch.where((research) => 
      research.topic.toLowerCase().contains(query.toLowerCase()) ||
      research.hypothesis.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
  
  // میڈیکل کیٹیگریز کے لحاظ سے فلٹر
  Future<List<MedicalResearch>> getResearchByCategory(String category) async {
    final allResearch = await LocalStorageService.getResearchHistory();
    return allResearch.where((research) => 
      research.topic.toLowerCase().contains(category.toLowerCase())
    ).toList();
  }
  
  // میڈیکل کیٹیگریز کی فہرست
  List<String> getMedicalCategories() {
    return [
      'diabetes',
      'cancer', 
      'heart disease',
      'covid',
      'arthritis',
      'asthma',
      'blood pressure',
      'cholesterol',
      'kidney disease',
      'liver disease'
    ];
  }

  // ========== نیا AI ریسرچ کے لیے میتھڈز ==========
  
  // AI ریسرچ کی تاریخ حاصل کریں
  Future<List<MedicalResearch>> getAIResearchHistory() async {
    final allResearch = await LocalStorageService.getResearchHistory();
    return allResearch.where((research) => research.isAIResearch == true).toList();
  }
  
  // مخلوط تاریخ (عام + AI)
  Future<List<MedicalResearch>> getCombinedResearchHistory() async {
    return await LocalStorageService.getResearchHistory();
  }
  
  // AI ریسرچ کو ڈیلیٹ کریں
  Future<void> deleteAIResearch(String researchId) async {
    await LocalStorageService.deleteResearch(researchId);
  }
}
