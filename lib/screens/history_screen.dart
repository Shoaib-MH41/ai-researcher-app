import 'package:flutter/material.dart';
import '../models/research_model.dart';
import '../services/research_service.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<ResearchResult> _researchHistory = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    final history = await ResearchService().getResearchHistory();
    setState(() {
      _researchHistory = history;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Research History')),
      body: _researchHistory.isEmpty
          ? Center(child: Text('No research history yet'))
          : ListView.builder(
              itemCount: _researchHistory.length,
              itemBuilder: (context, index) {
                final research = _researchHistory[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(research.topic),
                    subtitle: Text(research.date.toString()),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () => _showResearchDetails(research),
                  ),
                );
              },
            ),
    );
  }

  void _showResearchDetails(ResearchResult research) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(research.topic),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Summary: ${research.summary}'),
              SizedBox(height: 16),
              Text('Methodology: ${research.methodology}'),
              SizedBox(height: 8),
              Text('Findings: ${research.findings}'),
            ],
          ),
        ),
      ),
    );
  }
}
