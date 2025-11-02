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
  });

  // JSON serialization methods
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
    );
  }
}
