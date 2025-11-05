// models/medical_research.dart

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
  final bool isAIResearch; // نیا: AI سے تحقیق؟
  final Map<String, dynamic>? aiDiscoveryData; // نیا: 3 AI کا مکمل ڈیٹا

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
    this.isAIResearch = false,
    this.aiDiscoveryData,
  });

  // JSON → Object
  factory MedicalResearch.fromJson(Map<String, dynamic> json) {
    return MedicalResearch(
      id: json['id'] as String,
      topic: json['topic'] as String,
      hypothesis: json['hypothesis'] as String,
      methodology: json['methodology'] as String,
      labResults: json['labResults'] as String,
      analysis: json['analysis'] as String,
      conclusion: json['conclusion'] as String,
      pdfReport: json['pdfReport'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isAIResearch: json['isAIResearch'] as bool? ?? false,
      aiDiscoveryData: json['aiDiscoveryData'] as Map<String, dynamic>?,
    );
  }

  // Object → JSON
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

  // Optional: copyWith for immutability
  MedicalResearch copyWith({
    String? id,
    String? topic,
    String? hypothesis,
    String? methodology,
    String? labResults,
    String? analysis,
    String? conclusion,
    String? pdfReport,
    DateTime? createdAt,
    bool? isAIResearch,
    Map<String, dynamic>? aiDiscoveryData,
  }) {
    return MedicalResearch(
      id: id ?? this.id,
      topic: topic ?? this.topic,
      hypothesis: hypothesis ?? this.hypothesis,
      methodology: methodology ?? this.methodology,
      labResults: labResults ?? this.labResults,
      analysis: analysis ?? this.analysis,
      conclusion: conclusion ?? this.conclusion,
      pdfReport: pdfReport ?? this.pdfReport,
      createdAt: createdAt ?? this.createdAt,
      isAIResearch: isAIResearch ?? this.isAIResearch,
      aiDiscoveryData: aiDiscoveryData ?? this.aiDiscoveryData,
    );
  }
}
