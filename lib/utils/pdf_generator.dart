
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/medical_research.dart';
import 'language_utils.dart';

class PDFGenerator {
  // ========== 1. عام PDF (موجودہ) ==========
  static Future<File> generatePDF({
    required MedicalResearch research,
    required String language,
    required BuildContext context,
  }) async {
    return await _generatePDF(research, language, context, isAISpecific: false);
  }

  // ========== 2. AI-specific PDF (نیا) ==========
  static Future<File> generateAIPDF({
    required MedicalResearch research,
    required String language,
    required BuildContext context,
  }) async {
    if (research.isAIResearch && research.aiDiscoveryData != null) {
      return await _generatePDF(research, language, context, isAISpecific: true);
    } else {
      return await generatePDF(research: research, language: language, context: context);
    }
  }

  // ========== 3. مرکزی PDF جنریشن (دونوں کے لیے) ==========
  static Future<File> _generatePDF(
    MedicalResearch research,
    String language,
    BuildContext context, {
    required bool isAISpecific,
  }) async {
    try {
      final pdf = pw.Document();

      // Load fonts
      final urduFont = pw.Font.ttf(await rootBundle.load("assets/fonts/NotoNastaliqUrdu-VariableFont_wght.ttf"));
      final arabicFont = pw.Font.ttf(await rootBundle.load("assets/fonts/Amiri-Regular.ttf"));
      final englishFont = pw.Font.ttf(await rootBundle.load("assets/fonts/OpenSans-VariableFont_wdth,wght.ttf"));

      final font = switch (language.toLowerCase()) {
        'urdu' => urduFont,
        'arabic' => arabicFont,
        _ => englishFont,
      };

      final headers = LanguageUtils.getPDFHeaders(language);

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(30),
          build: (pw.Context ctx) => [
            // Title
            pw.Center(
              child: pw.Text(
                isAISpecific ? 'AI ٹرائیو تحقیقاتی رپورٹ' : headers['title']!,
                style: pw.TextStyle(font: font, fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800),
              ),
            ),
            pw.SizedBox(height: 20),

            // AI Trio Badge
            if (isAISpecific) _buildAITrioBadge(font),

            // Info Box
            _buildInfoBox(headers, research, font, language),
            pw.SizedBox(height: 20),

            // AI Specific Sections
            if (isAISpecific) ...[
              _buildAISection('ریسرچ AI', research.aiDiscoveryData?['research_ai'], font),
              pw.SizedBox(height: 15),
              _buildAISection('لیب AI', research.aiDiscoveryData?['lab_ai'], font),
              pw.SizedBox(height: 15),
              _buildAISection('رپورٹ AI', research.aiDiscoveryData?['report_ai'], font),
              pw.SizedBox(height: 20),
            ],

            // Standard Sections
            _buildSection(headers['hypothesis']!, research.hypothesis, font),
            pw.SizedBox(height: 15),
            _buildSection(headers['methodology']!, research.methodology, font),
            pw.SizedBox(height: 15),
            _buildSection(headers['labResults']!, research.labResults, font),
            pw.SizedBox(height: 15),
            _buildSection(headers['conclusion']!, research.conclusion, font),
            pw.SizedBox(height: 30),

            // Footer
            pw.Center(
              child: pw.Text(
                headers['footer'] ?? 'End of Report',
                style: pw.TextStyle(font: font, fontSize: 12, fontStyle: pw.FontStyle.italic, color: PdfColors.grey600),
              ),
            ),
          ],
        ),
      );

      // Save
      final dir = await getTemporaryDirectory();
      final fileName = isAISpecific
          ? "AI_Research_${research.id}_$language.pdf"
          : "Medical_Research_${research.id}_$language.pdf";
      final file = File("${dir.path}/$fileName");
      await file.writeAsBytes(await pdf.save());

      _showSuccessMessage(context, language, file.path, fileName);
      return file;
    } catch (e) {
      _showErrorMessage(context, e.toString());
      rethrow;
    }
  }

  // AI Trio Badge
  static pw.Widget _buildAITrioBadge(pw.Font font) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: pw.BoxDecoration(
        color: PdfColors.purple100,
        borderRadius: pw.BorderRadius.circular(20),
      ),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text('AI', style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.purple)),
          pw.Text(' x3 ', style: pw.TextStyle(font: font, fontSize: 10, fontWeight: pw.FontWeight.bold)),
          pw.Text('ٹرائیو', style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.purple)),
        ],
      ),
    );
  }

  // AI Section
  static pw.Widget _buildAISection(String title, dynamic data, pw.Font font) {
    final content = data is Map ? data.toString() : data?.toString() ?? 'کوئی ڈیٹا نہیں';
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: pw.TextStyle(font: font, fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.purple700)),
        pw.SizedBox(height: 6),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.purple300), borderRadius: pw.BorderRadius.circular(6)),
          child: pw.Text(content, style: pw.TextStyle(font: font, fontSize: 12)),
        ),
      ],
    );
  }

  // Info Box
  static pw.Widget _buildInfoBox(Map<String, String> headers, MedicalResearch r, pw.Font font, String lang) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(color: PdfColors.blue50, borderRadius: pw.BorderRadius.circular(8)),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('${headers['topic']}: ${r.topic}', style: pw.TextStyle(font: font, fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 5),
          pw.Text('${headers['date']}: ${LanguageUtils.formatDate(r.createdAt, lang)}', style: pw.TextStyle(font: font, fontSize: 14)),
        ],
      ),
    );
  }

  // Section
  static pw.Widget _buildSection(String title, String content, pw.Font font) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: pw.TextStyle(font: font, fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue700)),
        pw.SizedBox(height: 8),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey300), borderRadius: pw.BorderRadius.circular(6)),
          child: pw.Text(content, style: pw.TextStyle(font: font, fontSize: 14, lineSpacing: 1.5)),
        ),
      ],
    );
  }

  // Success
  static void _showSuccessMessage(BuildContext ctx, String lang, String path, String name) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('PDF کامیابی سے بن گیا'),
            Text('زبان: ${LanguageUtils.getNativeLanguageName(lang)}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'دیکھیں/شیئر کریں',
          textColor: Colors.white,
          onPressed: () => _showFileOptions(ctx, path, name),
        ),
      ),
    );
  }

  // File Options
  static void _showFileOptions(BuildContext ctx, String path, String name) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('PDF فائل'),
        content: Text('محفوظ ہو گئی:\n$name'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.share),
            label: const Text('شیئر کریں'),
            onPressed: () async {
              Navigator.pop(_);
              await Share.shareXFiles([XFile(path)], text: 'میری تحقیقاتی رپورٹ: $name');
            },
          ),
          TextButton(onPressed: () => Navigator.pop(_), child: const Text('بند کریں')),
        ],
      ),
    );
  }

  // Error
  static void _showErrorMessage(BuildContext ctx, String error) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(content: Text('PDF بنانے میں مسئلہ: $error'), backgroundColor: Colors.red, duration: const Duration(seconds: 5)),
    );
  }
}
