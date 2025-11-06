// lib/models/research_model.dart

import 'dart:convert';

/// MedicalResearch ماڈل کلاس —
/// یہ AI یا انسان دونوں کی ریسرچ رپورٹس کو سنبھالنے کے لیے استعمال ہوتی ہے۔
class MedicalResearch {
  final String id;
  final String topic;
  final String hypothesis;
  final String methodology;
  final String labResults;
  final String analysis;
  final String conclusion;
  final String pdfReport;
  final DateTime createdAt;
  final bool isAIResearch;
  final Map<String, dynamic> aiDiscoveryData;

  MedicalResearch({
    required this.id,
    required this.topic,
    required this.hypothesis,
    required this.methodology,
    required this.labResults,
    required this.analysis,
    required this.conclusion,
    required this.pdfReport,
    required this.createdAt,
    required this.isAIResearch,
    required this.aiDiscoveryData,
  });

  Map<String, dynamic> toMap() {
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

  factory MedicalResearch.fromMap(Map<String, dynamic> map) {
    return MedicalResearch(
      id: map['id'] ?? '',
      topic: map['topic'] ?? '',
      hypothesis: map['hypothesis'] ?? '',
      methodology: map['methodology'] ?? '',
      labResults: map['labResults'] ?? '',
      analysis: map['analysis'] ?? '',
      conclusion: map['conclusion'] ?? '',
      pdfReport: map['pdfReport'] ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      isAIResearch: map['isAIResearch'] ?? false,
      aiDiscoveryData: Map<String, dynamic>.from(map['aiDiscoveryData'] ?? {}),
    );
  }

  String toJson() => json.encode(toMap());

  factory MedicalResearch.fromJson(String source) =>
      MedicalResearch.fromMap(json.decode(source));
}
