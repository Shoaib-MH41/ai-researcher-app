import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io';
import '../models/research_model.dart';

class PDFGenerator {
  static Future<void> generatePDF({
    required MedicalResearch research,
    required String language,
    required BuildContext context,
  }) async {
    try {
      // PDF document بنائیں
      final pdf = pw.Document();
      
      // PDF content language کے مطابق تیار کریں
      Map<String, String> content = _getPDFContent(research, language);
      
      // PDF میں content شامل کریں
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Title
                pw.Center(
                  child: pw.Text(
                    content['title']!,
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),
                
                // Topic
                pw.Text(
                  content['topic']!,
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                
                // Date
                pw.Text(
                  content['date']!,
                  style: pw.TextStyle(fontSize: 14),
                ),
                pw.SizedBox(height: 20),
                
                // Hypothesis
                pw.Text(
                  content['hypothesis']!,
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  research.hypothesis,
                  style: pw.TextStyle(fontSize: 14),
                ),
                pw.SizedBox(height: 20),
                
                // Methodology
                pw.Text(
                  content['methodology']!,
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  research.methodology,
                  style: pw.TextStyle(fontSize: 14),
                ),
                pw.SizedBox(height: 20),
                
                // Lab Results
                pw.Text(
                  content['labResults']!,
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  research.labResults,
                  style: pw.TextStyle(fontSize: 14),
                ),
                pw.SizedBox(height: 20),
                
                // Conclusion
                pw.Text(
                  content['conclusion']!,
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  research.conclusion,
                  style: pw.TextStyle(fontSize: 14),
                ),
                pw.SizedBox(height: 30),
                
                // Footer
                pw.Center(
                  child: pw.Text(
                    content['footer']!,
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontStyle: pw.FontStyle.italic,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );

      // PDF save کریں
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/research_${research.id}_$language.pdf");
      await file.writeAsBytes(await pdf.save());

      // Success message
      _showSuccessMessage(context, language, file.path);
      
    } catch (e) {
      _showErrorMessage(context, e.toString());
    }
  }

  static Map<String, String> _getPDFContent(MedicalResearch research, String language) {
    switch (language) {
      case 'urdu':
        return {
          'title': 'طبی تحقیقاتی رپورٹ',
          'topic': 'موضوع: ${research.topic}',
          'date': 'تاریخ: ${_formatDate(research.createdAt)}',
          'hypothesis': 'مفروضہ:',
          'methodology': 'طریقہ کار:',
          'labResults': 'لیب کے نتائج:',
          'conclusion': 'نتیجہ:',
          'footer': 'AI میڈیکل ریسرچ سسٹم کے ذریعے تیار کردہ'
        };
      
      case 'arabic':
        return {
          'title': 'تقرير البحث الطبي',
          'topic': 'الموضوع: ${research.topic}',
          'date': 'التاريخ: ${_formatDate(research.createdAt)}',
          'hypothesis': 'الفرضية:',
          'methodology': 'المنهجية:',
          'labResults': 'نتائج المختبر:',
          'conclusion': 'الخلاصة:',
          'footer': 'تم إنشاؤها بواسطة نظام البحث الطبي بالذكاء الاصطناعي'
        };
      
      default: // english
        return {
          'title': 'MEDICAL RESEARCH REPORT',
          'topic': 'TOPIC: ${research.topic}',
          'date': 'DATE: ${_formatDate(research.createdAt)}',
          'hypothesis': 'HYPOTHESIS:',
          'methodology': 'METHODOLOGY:',
          'labResults': 'LAB RESULTS:',
          'conclusion': 'CONCLUSION:',
          'footer': 'Generated by AI Medical Research System'
        };
    }
  }

  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  static void _showSuccessMessage(BuildContext context, String language, String filePath) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF کامیابی سے ڈاؤن لوڈ ہو گیا - ${_getLanguageName(language)}'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 4),
        action: SnackBarAction(
          label: 'فائل کھولیں',
          textColor: Colors.white,
          onPressed: () {
            // فائل کھولنے کا logic بعد میں شامل کریں گے
            print('PDF saved at: $filePath');
          },
        ),
      ),
    );
  }

  static void _showErrorMessage(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF بنانے میں مسئلہ: $error'),
        backgroundColor: Colors.red,
      ),
    );
  }

  static String _getLanguageName(String code) {
    switch (code) {
      case 'english': return 'English';
      case 'urdu': return 'اردو';
      case 'arabic': return 'عربي';
      default: return 'English';
    }
  }
}
