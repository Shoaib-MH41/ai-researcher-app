import 'package:flutter/material.dart';
import '../models/research_model.dart';
import '../services/local_storage_service.dart';
import '../widgets/research_card.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<ResearchResult> _researchHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    final history = await LocalStorageService.getResearchHistory();
    setState(() {
      _researchHistory = history;
      _isLoading = false;
    });
  }

  void _deleteResearch(int index) async {
    await LocalStorageService.deleteResearch(index);
    _loadHistory(); // Reload the list
  }

  void _clearAllResearch() async {
    await LocalStorageService.clearAllResearch();
    _loadHistory(); // Reload the list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Research History'),
        actions: [
          if (_researchHistory.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_sweep),
              onPressed: _clearAllResearch,
              tooltip: 'Clear All History',
            ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _researchHistory.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No Research History',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Your research projects will appear here',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _researchHistory.length,
                  itemBuilder: (context, index) {
                    final research = _researchHistory[index];
                    return ResearchCard(
                      research: research,
                      onTap: () => _showResearchDetails(research),
                      onDelete: () => _deleteResearch(index),
                    );
                  },
                ),
    );
  }

  void _showResearchDetails(ResearchResult research) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Research Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailSection('Research Topic', research.topic),
                    SizedBox(height: 16),
                    _buildDetailSection('Executive Summary', research.summary),
                    SizedBox(height: 16),
                    _buildDetailSection('Methodology', research.methodology),
                    SizedBox(height: 16),
                    _buildDetailSection('Key Findings', research.findings),
                    SizedBox(height: 16),
                    _buildDetailSection('Date', 
                      '${research.date.day}/${research.date.month}/${research.date.year}'
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
        Divider(height: 24),
      ],
    );
  }
}
