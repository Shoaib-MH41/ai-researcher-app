    import 'package:flutter/material.dart';
import '../models/research_model.dart';
import '../services/local_storage_service.dart';
import 'results_screen.dart';
import '../utils/pdf_generator.dart'; // نیا import

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

  // نیا PDF ڈائیلاگ فنکشن
  void _showPDFLanguageDialog(BuildContext context, MedicalResearch research) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("PDF زبان منتخب کریں", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(context, research, 'english', 'English', '🇺🇸', Colors.blue),
            _buildLanguageOption(context, research, 'urdu', 'اردو', '🇵🇰', Colors.green),
            _buildLanguageOption(context, research, 'arabic', 'عربي', '🇸🇦', Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, MedicalResearch research, 
      String langCode, String language, String flag, Color color) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      child: ListTile(
        leading: Text(flag, style: TextStyle(fontSize: 20)),
        title: Text(language, style: TextStyle(fontWeight: FontWeight.bold)),
        tileColor: color.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onTap: () {
          Navigator.pop(context);
          _generatePDF(context, research, langCode);
        },
      ),
    );
  }

  void _generatePDF(BuildContext context, MedicalResearch research, String language) async {
    try {
      // PDFGenerator utility استعمال کریں
      await PDFGenerator.generatePDF(
        research: research,
        language: language,
        context: context,
      );
      
      // Success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF ڈاؤن لوڈ ہو گیا - ${_getLanguageName(language)}'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
          action: SnackBarAction(
            label: 'کھولیں',
            textColor: Colors.white,
            onPressed: () {
              // PDF open کرنے کا logic
            },
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF ڈاؤن لوڈ میں مسئلہ: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'english': return 'English';
      case 'urdu': return 'اردو';
      case 'arabic': return 'عربي';
      default: return 'English';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تحقیقاتی تاریخ'),
        backgroundColor: Colors.blue[700],
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
                      Text('کوئی تحقیقاتی تاریخ نہیں', 
                          style: TextStyle(fontSize: 18, color: Colors.grey)),
                      SizedBox(height: 8),
                      Text('آپ کی طبی تحقیقات یہاں ظاہر ہوں گی'),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _researchHistory.length,
                  itemBuilder: (context, index) {
                    final research = _researchHistory[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 3,
                      child: ListTile(
                        leading: Icon(Icons.medical_services, color: Colors.blue),
                        title: Text(
                          research.topic,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('${research.createdAt.day}/${research.createdAt.month}/${research.createdAt.year}'),
                        trailing: PopupMenuButton(
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: ListTile(
                                leading: Icon(Icons.visibility, color: Colors.blue),
                                title: Text('مکمل دیکھیں'),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => ResultsScreen(research: research)
                                  ));
                                },
                              ),
                            ),
                            PopupMenuItem(
                              child: ListTile(
                                leading: Icon(Icons.download, color: Colors.green),
                                title: Text('PDF ڈاؤن لوڈ کریں'),
                                onTap: () {
                                  Navigator.pop(context);
                                  _showPDFLanguageDialog(context, research);
                                },
                              ),
                            ),
                            PopupMenuItem(
                              child: ListTile(
                                leading: Icon(Icons.delete, color: Colors.red),
                                title: Text('حذف کریں', style: TextStyle(color: Colors.red)),
                                onTap: () {
                                  Navigator.pop(context);
                                  _deleteResearch(index);
                                },
                              ),
                            ),
                          ],
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
