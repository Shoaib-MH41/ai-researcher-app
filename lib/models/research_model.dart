class ResearchResult {
  final String topic;
  final String summary;
  final String methodology;
  final String findings;
  final DateTime date;
  
  ResearchResult({
    required this.topic,
    required this.summary,
    required this.methodology,
    required this.findings,
    required this.date,
  });
  
  // For future local storage implementation
  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'summary': summary,
      'methodology': methodology,
      'findings': findings,
      'date': date.toIso8601String(),
    };
  }
  
  // For future local storage implementation
  factory ResearchResult.fromJson(Map<String, dynamic> json) {
    return ResearchResult(
      topic: json['topic'],
      summary: json['summary'],
      methodology: json['methodology'],
      findings: json['findings'],
      date: DateTime.parse(json['date']),
    );
  }
}
