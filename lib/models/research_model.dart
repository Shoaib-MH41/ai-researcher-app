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
}
