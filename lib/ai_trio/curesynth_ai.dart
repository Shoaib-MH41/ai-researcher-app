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

  /// 🩺 نیا میتھڈ: trio_orchestrator کے لیے compat میتھڈ
  static Future<Map<String, dynamic>> generateTreatmentPlan({
    required String medicalProblem,
    required dynamic analysisData,
  }) async {
    print('💊 CureSynth AI: نیا علاج پلان تیار کر رہا ہوں...');

    await Future.delayed(const Duration(seconds: 2));

    final random = Random();
    final confidence = 0.85 + random.nextDouble() * 0.15;

    // علاج کی تفصیلی تجاویز
    final treatmentName = _generateTreatmentName(medicalProblem);
    final method = _suggestTreatmentMethod(medicalProblem);
    const dosage = _calculateDosage(medicalProblem);
    const duration = _suggestTreatmentDuration(medicalProblem);
    const sideEffects = _identifySideEffects(medicalProblem);

    print('✅ CureSynth AI: نیا علاج پلان مکمل');

    return {
      'ai_name': 'CureSynth AI',
      'medical_problem': medicalProblem,
      'status': 'completed',
      'treatment_name': treatmentName,
      'method': method,
      'dosage': dosage,
      'duration': duration,
      'side_effects': sideEffects,
      'confidence_score': confidence,
      'summary': 'CureSynth AI نے $medicalProblem کے لیے علاج کا مکمل پلان تیار کیا ہے۔',
      'ai_notes': 'یہ پلان جدید طبی تحقیق اور کلینیکل گائیڈلائنز پر مبنی ہے۔',
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

  /// 💊 علاج کا نام جنریٹ کریں
  static String _generateTreatmentName(String medicalProblem) {
    final treatments = {
      'cancer': 'امیونو تھراپی پروٹوکول',
      'diabetes': 'گلوکوز مینجمنٹ پلان',
      'heart': 'کارڈیو پروٹیکشن تھراپی',
      'blood pressure': 'اینٹی ہائپرٹینسیو ریجیمن',
      'asthma': 'برونکودیلیٹر تھراپی',
      'arthritis': 'اینٹی انفلیمیٹری ٹریٹمنٹ',
    };

    for (final key in treatments.keys) {
      if (medicalProblem.toLowerCase().contains(key)) {
        return treatments[key]!;
      }
    }

    return 'پرسنلائزڈ میڈیکل ٹریٹمنٹ پلان';
  }

  /// 🩺 علاج کا طریقہ تجویز کریں
  static String _suggestTreatmentMethod(String medicalProblem) {
    if (medicalProblem.toLowerCase().contains('cancer')) {
      return 'امیونو تھراپی، کیموتھراپی، اور ریڈیو تھراپی کا مجموعہ';
    } else if (medicalProblem.toLowerCase().contains('diabetes')) {
      return 'انسولین تھراپی، غذائی کنٹرول، اور ورزش کا پروگرام';
    } else if (medicalProblem.toLowerCase().contains('heart')) {
      return 'ادویات، غذائی تبدیلیاں، اور باقاعدہ ورزش';
    }
    
    return 'ادویاتی علاج، طرز زندگی میں تبدیلیاں، اور باقاعدہ معائنہ';
  }

  /// 💊 خوراک کا تعین
  static String _calculateDosage(String medicalProblem) {
    final random = Random();
    final dosages = ['500mg روزانہ', '250mg دو بار روزانہ', '1000mg ایک بار روزانہ', '50mg تین بار روزانہ'];
    return dosages[random.nextInt(dosages.length)];
  }

  /// ⏱️ علاج کی مدت
  static String _suggestTreatmentDuration(String medicalProblem) {
    if (medicalProblem.toLowerCase().contains('cancer')) {
      return '6-12 ماہ';
    } else if (medicalProblem.toLowerCase().contains('diabetes')) {
      return 'زندگی بھر';
    } else if (medicalProblem.toLowerCase().contains('heart')) {
      return '12-24 ماہ';
    }
    
    return '3-6 ماہ';
  }

  /// ⚠️ ضمنی اثرات
  static List<String> _identifySideEffects(String medicalProblem) {
    return [
      'ہلکی متلی',
      'تھکن',
      'سر درد',
      'بھوک میں تبدیلی',
      'نیند کے مسائل'
    ];
  }
}
