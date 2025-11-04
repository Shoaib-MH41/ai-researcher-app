import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import '../models/research_model.dart';
import 'language_utils.dart';

class PDFGenerator {
  // ✅ اب یہ Future<File> واپس کرے گا
  static Future<File> generatePDF({
    required MedicalResearch research,
    required String language,
    required BuildContext context,
  }) async {
    try {
      // 📘 PDF بنائیں
      final pdf = pw.Document();
      Map<String, String> headers = LanguageUtils.getPDFHeaders(language);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(30),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Center(
                    child: pw.Text(
                      headers['title'] ?? 'Medical Research Report',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue800,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 25),

                  _buildInfoBox(headers, research, language),

                  pw.SizedBox(height: 20),
                  _buildSection(title: headers['hypothesis']!, content: research.hypothesis),
                  pw.SizedBox(height: 20),
                  _buildSection(title: headers['methodology']!, content: research.methodology),
                  pw.SizedBox(height: 20),
                  _buildSection(title: headers['labResults']!, content: research.labResults),
                  pw.SizedBox(height: 20),
                  _buildSection(title: headers['conclusion']!, content: research.conclusion),
                  pw.SizedBox(height: 30),

                  pw.Center(
                    child: pw.Text(
                      headers['footer'] ?? 'End of Report',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontStyle: pw.FontStyle.italic,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );

      // 📂 PDF save کریں
      final output = await getTemporaryDirectory();
      final fileName = "medical_research_${research.id}_$language.pdf";
      final file = File("${output.path}/$fileName");
      await file.writeAsBytes(await pdf.save());

      // ✅ Success message with Share option
      _showSuccessMessage(context, language, file.path, fileName);

      return file; // ✅ PDF فائل واپس کریں
    } catch (e) {
      _showErrorMessage(context, e.toString());
      rethrow; // ⚠️ اگر error آئے تو آگے بھیج دو
    }
  }

  // ℹ️ Info box
  static pw.Widget _buildInfoBox(Map<String, String> headers, MedicalResearch research, String language) {
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
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            '${headers['date']}: ${LanguageUtils.formatDate(research.createdAt, language)}',
            style: pw.TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  // 📖 Section layout
  static pw.Widget _buildSection({required String title, required String content}) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
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
            style: const pw.TextStyle(fontSize: 14, lineSpacing: 1.5),
          ),
        ),
      ],
    );
  }

  // ✅ Show success with SHARE option
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
          onPressed: () {
            _showFileOptions(context, filePath, fileName);
          },
        ),
      ),
    );
  }

  // 📤 File Options Dialog
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
              await Share.shareXFiles(
                [XFile(filePath)],
                text: 'میری میڈیکل ریسرچ رپورٹ: $fileName',
              );
            },
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('بند کریں'),
          ),
        ],
      ),
    );
  }

  // ❌ Error Message
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
