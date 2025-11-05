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
  final bool isAIResearch; // نیا field شامل کریں
  
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
    this.isAIResearch = false, // ڈیفالٹ false رکھیں
  });

  // JSON serialization methods کو اپ ڈیٹ کریں
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
      'isAIResearch': isAIResearch, // نیا field شامل کریں
    };
  }

  factory MedicalResearch.fromJson(Map<String, dynamic> json) {
    return MedicalResearch(
      id: json['id'],
      topic: json['topic'],
      hypothesis: json['hypothesis'],
      methodology: json['methodology'],
      labResults: json['labResults'],
      analysis: json['analysis'],
      conclusion: json['conclusion'],
      pdfReport: json['pdfReport'],
      createdAt: DateTime.parse(json['createdAt']),
      isAIResearch: json['isAIResearch'] ?? false, // نیا field - ڈیفالٹ false
    );
  }

  // Optional: CopyWith method اگر آپ چاہیں تو
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
    );
  }
}
