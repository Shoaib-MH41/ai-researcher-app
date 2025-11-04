import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import '../models/research_model.dart';
import 'language_utils.dart';

class PDFGenerator {
  static Future<File> generatePDF({
    required MedicalResearch research,
    required String language,
    required BuildContext context,
  }) async {
    try {
      final pdf = pw.Document();

      // ✅ Load fonts dynamically
      final urduFont = pw.Font.ttf(await rootBundle.load("assets/fonts/NotoNastaliqUrdu-VariableFont_wght.ttf"));
      final arabicFont = pw.Font.ttf(await rootBundle.load("assets/fonts/Amiri-Regular.ttf"));
      final englishFont = pw.Font.ttf(await rootBundle.load("assets/fonts/OpenSans-VariableFont_wdth,wght.ttf"));

      pw.Font selectedFont;

      switch (language.toLowerCase()) {
        case 'urdu':
          selectedFont = urduFont;
          break;
        case 'arabic':
          selectedFont = arabicFont;
          break;
        default:
          selectedFont = englishFont;
      }

      Map<String, String> headers = LanguageUtils.getPDFHeaders(language);

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(30),
          build: (pw.Context context) => [
            pw.Center(
              child: pw.Text(
                headers['title'] ?? 'Medical Research Report',
                style: pw.TextStyle(
                  font: selectedFont,
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue800,
                ),
              ),
            ),
            pw.SizedBox(height: 25),

            _buildInfoBox(headers, research, selectedFont, language),

            pw.SizedBox(height: 20),
            _buildSection(headers['hypothesis']!, research.hypothesis, selectedFont),
            pw.SizedBox(height: 20),
            _buildSection(headers['methodology']!, research.methodology, selectedFont),
            pw.SizedBox(height: 20),
            _buildSection(headers['labResults']!, research.labResults, selectedFont),
            pw.SizedBox(height: 20),
            _buildSection(headers['conclusion']!, research.conclusion, selectedFont),
            pw.SizedBox(height: 30),

            pw.Center(
              child: pw.Text(
                headers['footer'] ?? 'End of Report',
                style: pw.TextStyle(
                  font: selectedFont,
                  fontSize: 12,
                  fontStyle: pw.FontStyle.italic,
                  color: PdfColors.grey600,
                ),
              ),
            ),
          ],
        ),
      );

      // 📂 Save PDF
      final output = await getTemporaryDirectory();
      final fileName = "medical_research_${research.id}_$language.pdf";
      final file = File("${output.path}/$fileName");
      await file.writeAsBytes(await pdf.save());

      // ✅ Show success with Share
      _showSuccessMessage(context, language, file.path, fileName);

      return file;
    } catch (e) {
      _showErrorMessage(context, e.toString());
      rethrow;
    }
  }

  // ℹ️ Info Box
  static pw.Widget _buildInfoBox(Map<String, String> headers, MedicalResearch research, pw.Font font, String language) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '${headers['topic']}: ${research.topic}',
            style: pw.TextStyle(font: font, fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            '${headers['date']}: ${LanguageUtils.formatDate(research.createdAt, language)}',
            style: pw.TextStyle(font: font, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // 📖 Section layout
  static pw.Widget _buildSection(String title, String content, pw.Font font) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            font: font,
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue700,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Text(
            content,
            style: pw.TextStyle(font: font, fontSize: 14, lineSpacing: 1.5),
          ),
        ),
      ],
    );
  }

  // ✅ Success Message
  static void _showSuccessMessage(BuildContext context, String language, String filePath, String fileName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('📄 PDF کامیابی سے بن گیا'),
            Text(
              'زبان: ${LanguageUtils.getNativeLanguageName(language)}',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'دیکھیں/شیئر کریں',
          textColor: Colors.white,
          onPressed: () => _showFileOptions(context, filePath, fileName),
        ),
      ),
    );
  }

  // 📤 File Options
  static void _showFileOptions(BuildContext context, String filePath, String fileName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('PDF فائل'),
        content: Text('فائل محفوظ ہو گئی:\n$fileName'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.share),
            label: const Text('شیئر کریں'),
            onPressed: () async {
              Navigator.pop(ctx);
              await Share.shareXFiles([XFile(filePath)], text: 'میری میڈیکل ریسرچ رپورٹ: $fileName');
            },
          ),
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('بند کریں')),
        ],
      ),
    );
  }

  // ❌ Error
  static void _showErrorMessage(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('⚠️ PDF بنانے میں مسئلہ: $error'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
