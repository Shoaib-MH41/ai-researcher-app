import 'package:flutter/material.dart';
import '../models/research_model.dart';
import '../services/local_storage_service.dart';
import 'results_screen.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<MedicalResearch> _researchHistory = [];
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
    if (index >= 0 && index < _researchHistory.length) {
      final research = _researchHistory[index];
      await LocalStorageService.deleteResearch(research.id);
      _loadHistory(); // Reload the list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Research History')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _researchHistory.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No Research History', 
                          style: TextStyle(fontSize: 18, color: Colors.grey)),
                      SizedBox(height: 8),
                      Text('Your medical research will appear here'),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _researchHistory.length,
                  itemBuilder: (context, index) {
                    final research = _researchHistory[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: Icon(Icons.medical_services, color: Colors.blue),
                        title: Text(research.topic),
                        subtitle: Text('${research.createdAt.day}/${research.createdAt.month}/${research.createdAt.year}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteResearch(index),
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ResultsScreen(research: research)
                          ));
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
