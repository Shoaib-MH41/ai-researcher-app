import 'package:flutter/material.dart';
import '../models/research_model.dart';
import '../utils/pdf_generator.dart'; // نیا import شامل کریں
import '../utils/language_utils.dart'; // نیا import شامل کریں

class ResultsScreen extends StatelessWidget {
  final MedicalResearch research;
  
  const ResultsScreen({Key? key, required this.research}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تحقیقات کے نتائج'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () => _shareResults(context),
            tooltip: 'نتائج شئیر کریں',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Research Header with ID and Date
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'تحقیقاتی رپورٹ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                          Text(
                            'آئی ڈی: ${research.id.substring(0, 8)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        research.topic,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'تاریخ تخلیق: ${_formatDate(research.createdAt)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 20),
              
              // Research Sections with Icons
              _buildSectionWithIcon(
                'مفروضہ',
                Icons.lightbulb_outline,
                Colors.orange,
                research.hypothesis,
              ),
              
              _buildSectionWithIcon(
                'طریقہ کار', 
                Icons.list_alt,
                Colors.green,
                research.methodology,
              ),
              
              _buildSectionWithIcon(
                'لیب کے نتائج',
                Icons.biotech,
                Colors.purple,
                research.labResults,
              ),
              
              _buildSectionWithIcon(
                'ڈیٹا کا تجزیہ',
                Icons.analytics,
                Colors.blue,
                research.analysis,
              ),
              
              _buildSectionWithIcon(
                'نتیجہ',
                Icons.verified,
                Colors.green,
                research.conclusion,
              ),
              
              SizedBox(height: 24),
              
              // Action Buttons
              _buildActionButtons(context),
              
              SizedBox(height: 16),
              
              // Footer Note
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Text(
                  'یہ رپورٹ AI میڈیکل ریسرچ سسٹم کے ذریعے تیار کی گئی ہے۔ '
                  'طبی مشورے کے لیے براہ کرم ہیلتھ کیئر پروفیشنلز سے رابطہ کریں۔',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
      
      // نیا Floating Action Button for PDF
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPDFLanguageDialog(context),
        child: Icon(Icons.picture_as_pdf, color: Colors.white),
        tooltip: 'PDF ڈاؤن لوڈ کریں',
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
    );
  }
  
  Widget _buildSectionWithIcon(String title, IconData icon, Color color, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.grey[700],
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _showPDFLanguageDialog(context),
            icon: Icon(Icons.picture_as_pdf, size: 20),
            label: Text('PDF محفوظ کریں'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.add, size: 20),
            label: Text('نئی تحقیق'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} کو ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
  
// نیا PDF Language Dialog Function
void _showPDFLanguageDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("PDF زبان منتخب کریں", textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLanguageOption(context, 'english', 'English', '🇺🇸', Colors.blue),
          _buildLanguageOption(context, 'urdu', 'اردو', '🇵🇰', Colors.green),
          _buildLanguageOption(context, 'arabic', 'عربي', '🇸🇦', Colors.orange),
        ],
      ),
    ),
  );
}

Widget _buildLanguageOption(BuildContext context, String langCode, String language, String flag, Color color) {
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
        _generatePDF(context, langCode);
      },
    ),
  );
}

void _generatePDF(BuildContext context, String language) async {
  try {
    await PDFGenerator.generatePDF(
      research: research,
      language: language,
      context: context,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('PDF کامیابی سے ڈاؤن لوڈ ہو گیا'),
            Text(
              'زبان: ${LanguageUtils.getNativeLanguageName(language)}',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 4),
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
