import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/research_model.dart';
import 'language_utils.dart';

class PDFGenerator {
  // ========== 1️⃣ عام PDF ==========
  static Future<File> generatePDF({
    required MedicalResearch research,
    required String language,
    required BuildContext context,
  }) async {
    return await _generatePDF(
      research,
      language,
      context,
      isAISpecific: research.isAIResearch,
    );
  }

  // ========== 2️⃣ مرکزی فنکشن (AI + نارمل دونوں کے لیے) ==========
  static Future<File> _generatePDF(
    MedicalResearch research,
    String language,
    BuildContext context, {
    required bool isAISpecific,
  }) async {
    try {
      final pdf = pw.Document();

      // Fonts
      final urduFont = pw.Font.ttf(
        await rootBundle.load("assets/fonts/NotoNastaliqUrdu-VariableFont_wght.ttf"),
      );
      final arabicFont = pw.Font.ttf(
        await rootBundle.load("assets/fonts/Amiri-Regular.ttf"),
      );
      final englishFont = pw.Font.ttf(
        await rootBundle.load("assets/fonts/OpenSans-VariableFont_wdth,wght.ttf"),
      );

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
                isAISpecific ? 'AI ریسرچ رپورٹ' : headers['title']!,
                style: pw.TextStyle(
                  font: font,
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue800,
                ),
              ),
            ),
            pw.SizedBox(height: 20),

            if (isAISpecific) _buildAITrioBadge(font),

            _buildInfoBox(headers, research, font, language),
            pw.SizedBox(height: 20),

            if (isAISpecific && research.aiDiscoveryData != null) ...[
              _buildAISection('🔹 Research AI', research.aiDiscoveryData?['ResearchAI'], font),
              pw.SizedBox(height: 10),
              _buildAISection('🔹 Lab Testing AI', research.aiDiscoveryData?['LabTestingAI'], font),
              pw.SizedBox(height: 10),
              _buildAISection('🔹 MedAnalyzer AI', research.aiDiscoveryData?['MedAnalyzerAI'], font),
              pw.SizedBox(height: 10),
              _buildAISection('🔹 CureSynth AI', research.aiDiscoveryData?['CureSynthAI'], font),
              pw.SizedBox(height: 10),
              _buildAISection('🔹 BioMind AI', research.aiDiscoveryData?['BioMindAI'], font),
              pw.SizedBox(height: 20),
            ],

            _buildSection(headers['hypothesis']!, research.hypothesis, font),
            pw.SizedBox(height: 15),
            _buildSection(headers['methodology']!, research.methodology, font),
            pw.SizedBox(height: 15),
            _buildSection(headers['labResults']!, research.labResults, font),
            pw.SizedBox(height: 15),
            _buildSection(headers['conclusion']!, research.conclusion, font),

            pw.SizedBox(height: 25),
            pw.Divider(color: PdfColors.grey400),
            pw.Center(
              child: pw.Text(
                headers['footer'] ?? 'End of Report',
                style: pw.TextStyle(
                  font: font,
                  fontSize: 12,
                  fontStyle: pw.FontStyle.italic,
                  color: PdfColors.grey700,
                ),
              ),
            ),
          ],
        ),
      );

      // Save File
      final dir = await getTemporaryDirectory();
      final fileName = isAISpecific
          ? "AI_Research_${research.id}_$language.pdf"
          : "Research_${research.id}_$language.pdf";
      final file = File("${dir.path}/$fileName");
      await file.writeAsBytes(await pdf.save());

      _showSuccessMessage(context, language, file.path, fileName);
      return file;
    } catch (e) {
      _showErrorMessage(context, e.toString());
      rethrow;
    }
  }

  // ========== 3️⃣ AI Trio Badge ==========
  static pw.Widget _buildAITrioBadge(pw.Font font) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: pw.BoxDecoration(
        color: PdfColors.purple100,
        borderRadius: pw.BorderRadius.circular(20),
      ),
      child: pw.Text(
        '🤖 AI Trio Research Mode',
        style: pw.TextStyle(font: font, fontSize: 12, color: PdfColors.purple800),
      ),
    );
  }

  // ========== 4️⃣ Info Box ==========
  static pw.Widget _buildInfoBox(
      Map<String, String> headers, MedicalResearch r, pw.Font font, String lang) {
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
          pw.Text('${headers['topic']}: ${r.topic}',
              style: pw.TextStyle(font: font, fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 5),
          pw.Text('${headers['date']}: ${LanguageUtils.formatDate(r.createdAt, lang)}',
              style: pw.TextStyle(font: font, fontSize: 13)),
        ],
      ),
    );
  }

  // ========== 5️⃣ Section ==========
  static pw.Widget _buildSection(String title, String content, pw.Font font) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title,
            style: pw.TextStyle(
                font: font,
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue800)),
        pw.SizedBox(height: 8),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Text(
            content.isNotEmpty ? content : 'کوئی مواد نہیں ملا۔',
            style: pw.TextStyle(font: font, fontSize: 14, lineSpacing: 1.4),
          ),
        ),
      ],
    );
  }

  // ========== 6️⃣ AI Section ==========
  static pw.Widget _buildAISection(String title, dynamic data, pw.Font font) {
    final content = data == null
        ? 'کوئی ڈیٹا موجود نہیں۔'
        : (data is Map ? data.toString() : data.toString());
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title,
            style: pw.TextStyle(
                font: font,
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.purple700)),
        pw.SizedBox(height: 6),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.purple300),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Text(content, style: pw.TextStyle(font: font, fontSize: 12)),
        ),
      ],
    );
  }

  // ========== 7️⃣ Success Message ==========
  static void _showSuccessMessage(
      BuildContext ctx, String lang, String path, String name) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('✅ PDF کامیابی سے بن گیا'),
            Text(
              'زبان: ${LanguageUtils.getNativeLanguageName(lang)}',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'دیکھیں/شیئر کریں',
          textColor: Colors.white,
          onPressed: () => _showFileOptions(ctx, path, name),
        ),
      ),
    );
  }

  // ========== 8️⃣ Share Dialog ==========
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
              await Share.shareXFiles(
                [XFile(path)],
                text: 'میری تحقیقاتی رپورٹ: $name',
              );
            },
          ),
          TextButton(onPressed: () => Navigator.pop(_), child: const Text('بند کریں')),
        ],
      ),
    );
  }

  // ========== 9️⃣ Error Message ==========
  static void _showErrorMessage(BuildContext ctx, String error) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text('⚠️ PDF بنانے میں مسئلہ: $error'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
