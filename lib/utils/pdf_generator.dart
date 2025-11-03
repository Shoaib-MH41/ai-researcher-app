import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import '../models/research_model.dart';
import 'language_utils.dart';

class PDFGenerator {
  static Future<File?> generatePDF({
    required MedicalResearch research,
    required String language,
    required BuildContext context,
  }) async {
    try {
      final pdf = pw.Document();

      // 🔹 Get localized strings
      final loc = LanguageUtils.getLocalizedStrings(language);

      // 🔹 Custom fonts for each language
      final ttf = await _getFontForLanguage(language);

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(24),
          build: (pw.Context context) {
            return [
              pw.Center(
                child: pw.Text(
                  loc['reportTitle']!,
                  style: pw.TextStyle(
                    font: ttf,
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue900,
                  ),
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Center(
                child: pw.Text(
                  '${loc['topic']!}: ${research.topic}',
                  style: pw.TextStyle(font: ttf, fontSize: 16),
                ),
              ),
              pw.SizedBox(height: 20),
              _buildSection(loc['hypothesis']!, research.hypothesis, ttf),
              _buildSection(loc['methodology']!, research.methodology, ttf),
              _buildSection(loc['labResults']!, research.labResults, ttf),
              _buildSection(loc['analysis']!, research.analysis, ttf),
              _buildSection(loc['conclusion']!, research.conclusion, ttf),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Text(
                loc['disclaimer']!,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  font: ttf,
                  fontSize: 10,
                  color: PdfColors.grey700,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ];
          },
        ),
      );

      // 🔹 Save file
      final outputDir = await getApplicationDocumentsDirectory();
      final filePath =
          '${outputDir.path}/medical_research_${research.id.substring(0, 6)}.pdf';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      return file;
    } catch (e) {
      debugPrint('PDF Generate Error: $e');
      return null;
    }
  }

  // 🔹 Section Builder
  static pw.Widget _buildSection(String title, String content, pw.Font ttf) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 10),
        pw.Text(
          title,
          style: pw.TextStyle(
            font: ttf,
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue700,
          ),
        ),
        pw.SizedBox(height: 6),
        pw.Text(
          content,
          style: pw.TextStyle(
            font: ttf,
            fontSize: 12,
            lineSpacing: 4,
          ),
        ),
        pw.SizedBox(height: 10),
      ],
    );
  }

  // 🔹 Load Fonts for each language
  static Future<pw.Font> _getFontForLanguage(String language) async {
    final fontData = switch (language) {
      'urdu' => await rootBundle.load('assets/fonts/NotoNaskhArabic-Regular.ttf'),
      'arabic' => await rootBundle.load('assets/fonts/Amiri-Regular.ttf'),
      _ => await rootBundle.load('assets/fonts/Roboto-Regular.ttf'),
    };
    return pw.Font.ttf(fontData);
  }
}

