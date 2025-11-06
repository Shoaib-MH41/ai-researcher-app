import 'package:flutter/foundation.dart';

/// 🧬 MedicalResearch model —
/// AI research pipeline کے تمام مراحل کا ڈیٹا اسٹور کرتا ہے
class MedicalResearch {
  final String id;
  final String topic; // تحقیق کا عنوان
  final String hypothesis; // AI یا انسان کی پیش کردہ مفروضہ
  final String methodology; // تحقیق کا طریقہ کار
  final String labResults; // لیب کے نتائج (formatted text)
  final String analysis; // تجزیہ اور مشاہدات
  final String conclusion; // نتیجہ یا سفارش
  final String pdfReport; // مکمل رپورٹ PDF text version
  final DateTime createdAt;
  final bool isAIResearch; // اگر یہ AI-generated رپورٹ ہے

  /// AI team data — ReportAI, ResearchAI, LabTestingAI وغیرہ
  final Map<String, dynamic>? aiDiscoveryData;

  const MedicalResearch({
    required this.id,
    required this.topic,
    required this.hypothesis,
    required this.methodology,
    required this.labResults,
    required this.analysis,
    required this.conclusion,
    required this.pdfReport,
    required this.createdAt,
    this.isAIResearch = false,
    this.aiDiscoveryData,
  });

  /// 🧾 JSON to Object
  factory MedicalResearch.fromJson(Map<String, dynamic> json) {
    return MedicalResearch(
      id: json['id'] ?? '',
      topic: json['topic'] ?? 'نامعلوم موضوع',
      hypothesis: json['hypothesis'] ?? 'کوئی مفروضہ نہیں',
      methodology: json['methodology'] ?? '',
      labResults: json['labResults'] ?? '',
      analysis: json['analysis'] ?? '',
      conclusion: json['conclusion'] ?? '',
      pdfReport: json['pdfReport'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      isAIResearch: json['isAIResearch'] ?? false,
      aiDiscoveryData: json['aiDiscoveryData'],
    );
  }

  /// 📦 Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topic': topic,
      'hypothesis': hypothesis,
      'methodology': methodology,
      'labResults': labResults,
      'analysis': analysis,
      'conclusion': conclusion,
      'pdfReport': pdfReport,
      'createdAt': createdAt.toIso8601String(),
      'isAIResearch': isAIResearch,
      'aiDiscoveryData': aiDiscoveryData,
    };
  }

  /// 🧠 Debug display
  @override
  String toString() {
    return 'MedicalResearch(id: $id, topic: $topic, AI: $isAIResearch)';
  }
}
