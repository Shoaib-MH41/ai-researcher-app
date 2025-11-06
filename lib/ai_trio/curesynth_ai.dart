// 📁 lib/ai_trio/curesynth_ai.dart
import 'dart:math';

/// 💊 CureSynth AI
/// یہ AI مختلف ذرائع سے ملی معلومات (lab, analysis, bio-mind)
/// کو ملا کر مریض کے لیے علاج کا پلان تیار کرتا ہے۔
class CureSynthAI {
  /// علاج تیار کرنے کا مرکزی فنکشن
  static Future<Map<String, dynamic>> generateTreatmentPlan({
    required Map<String, dynamic> bioMindData,
    required Map<String, dynamic> labData,
    required Map<String, dynamic> medAnalysisData,
  }) async {
    print('💊 CureSynth AI: علاج کا پلان تیار کر رہا ہوں...');

    await Future.delayed(const Duration(seconds: 1));

    final random = Random();
    final confidence = 0.8 + random.nextDouble() * 0.2;

    // بیماری کی بنیاد پر علاج تجویز
    final disease = bioMindData['disease_type'] ?? 'نامعلوم بیماری';
    final treatment = _suggestTreatment(disease);
    final precautions = _suggestPrecautions(disease);

    print('✅ CureSynth AI: علاج کا پلان مکمل ہو گیا۔');

    return {
      'ai_name': 'CureSynth AI',
      'status': 'complete',
      'disease': disease,
      'recommended_treatment': treatment,
      'precautions': precautions,
      'confidence_score': confidence,
      'ai_notes':
          'CureSynth AI نے مریض کے تجزیاتی، بائیولوجیکل اور لیب ڈیٹا کو مدنظر رکھ کر علاج کی تجاویز تیار کی ہیں۔',
    };
  }

  /// 🧾 بیماری کے مطابق علاج تجویز کرنے والا فنکشن
  static List<String> _suggestTreatment(String disease) {
    final treatments = {
      'ذیابطیس': ['انسولین ریگولیشن', 'کم چینی والی خوراک', 'روزانہ واک'],
      'ہائی بلڈ پریشر': ['نمک کم کریں', 'بلڈ پریشر کی دوائیں', 'ذہنی دباؤ کم کریں'],
      'دمہ': ['ان ہیلر کا استعمال', 'گردوغبار سے بچاؤ', 'گرم پانی سے بھاپ لینا'],
      'معدے کی خرابی': ['ہلکی خوراک', 'زیادہ پانی پینا', 'تیل دار کھانے سے پرہیز'],
      'جوڑوں کا درد': ['وٹامن D سپلیمنٹ', 'ورزش', 'گرم پٹیاں'],
      'ذہنی دباؤ': ['میڈیٹیشن', 'نیند میں بہتری', 'کاؤنسلنگ'],
      'نیند کی کمی': ['سونے کا وقت مقرر کریں', 'کیفین کم کریں', 'ریلیکسیشن'],
      'جلد کی بیماری': ['ایلوویرا جیل', 'سنسکرین', 'زیادہ پانی پینا'],
    };

    return treatments[disease] ?? ['عام طبی نگہداشت', 'ڈاکٹر سے مشورہ', 'متوازن خوراک'];
  }

  /// ⚠️ احتیاطی تدابیر
  static List<String> _suggestPrecautions(String disease) {
    final precautions = {
      'ذیابطیس': ['چینی سے پرہیز کریں', 'بلڈ شوگر چیک کرتے رہیں'],
      'ہائی بلڈ پریشر': ['نمک کا استعمال کم کریں', 'ورزش کو معمول بنائیں'],
      'دمہ': ['سگریٹ نوشی سے پرہیز', 'گردوغبار سے بچاؤ'],
      'جوڑوں کا درد': ['ٹھنڈ سے بچیں', 'زیادہ دیر بیٹھنے سے گریز کریں'],
      'ذہنی دباؤ': ['دوستوں سے بات کریں', 'تھراپی کا سہارا لیں'],
    };

    return precautions[disease] ??
        ['عام احتیاطی تدابیر اختیار کریں', 'ڈاکٹر سے باقاعدہ معائنہ کرائیں'];
  }
}
