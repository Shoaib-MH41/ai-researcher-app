import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 🔧 AdminPanel
/// یہ اسکرین مختلف AI ماڈیولز کی API keys کو محفوظ اور مینج کرتی ہے۔
class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final _storage = const FlutterSecureStorage();

  // 🧠 Controllers for each AI key
  final _geminiController = TextEditingController();
  final _huggingfaceController = TextEditingController();
  final _openaiController = TextEditingController();
  final _pdfController = TextEditingController(); // Reserved (future use)

  bool _isSaving = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _loadAllKeys();
  }

  /// تمام محفوظ شدہ API keys لوڈ کرنا
  Future<void> _loadAllKeys() async {
    final geminiKey = await _storage.read(key: 'gemini_api_key');
    final huggingfaceKey = await _storage.read(key: 'huggingface_api_key');
    final openaiKey = await _storage.read(key: 'openai_api_key');

    setState(() {
      _geminiController.text = geminiKey ?? '';
      _huggingfaceController.text = huggingfaceKey ?? '';
      _openaiController.text = openaiKey ?? '';
    });
  }

  /// تمام API keys کو محفوظ کرنا
  Future<void> _saveAllKeys() async {
    if (_geminiController.text.trim().isEmpty) {
      setState(() => _statusMessage = '❌ براہ کرم کم از کم Gemini API Key درج کریں');
      return;
    }

    setState(() {
      _isSaving = true;
      _statusMessage = '';
    });

    try {
      await _storage.write(key: 'gemini_api_key', value: _geminiController.text.trim());
      await _storage.write(key: 'huggingface_api_key', value: _huggingfaceController.text.trim());
      await _storage.write(key: 'openai_api_key', value: _openaiController.text.trim());

      setState(() {
        _isSaving = false;
        _statusMessage = '✅ تمام API Keys کامیابی سے محفوظ ہو گئیں!';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Keys محفوظ کر لی گئیں'), backgroundColor: Colors.green),
      );
    } catch (e) {
      setState(() {
        _isSaving = false;
        _statusMessage = '❌ Keys محفوظ نہیں ہو سکیں: $e';
      });
    }
  }

  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔧 AI سسٹم مینجمنٹ'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAITrioInfo(),
            const SizedBox(height: 20),

            _buildSectionTitle('🧠 BioMind AI - بیماری کی تحقیق'),
            _buildApiField(_geminiController, 'Google Gemini API Key *', 'AIza...', obscure: true),

            const SizedBox(height: 16),
            _buildSectionTitle('💊 CureSynth AI - علاج تخلیق'),
            _buildApiField(_huggingfaceController, 'HuggingFace API Key (اختیاری)', 'hf_...', obscure: true),

            const SizedBox(height: 16),
            _buildSectionTitle('📈 MedAnalyzer AI - ڈیٹا تجزیہ'),
            _buildApiField(_openaiController, 'OpenAI API Key (اختیاری)', 'sk-...', obscure: true),

            const SizedBox(height: 16),
            _buildSectionTitle('📄 MedReport AI - PDF رپورٹ'),
            _buildPDFInfoCard(),

            const SizedBox(height: 30),
            _buildMainButton(
              onPressed: _isSaving ? null : _saveAllKeys,
              label: _isSaving ? 'محفوظ ہو رہا ہے...' : 'تمام Keys محفوظ کریں',
              icon: Icons.save,
              color: Colors.green,
            ),

            const SizedBox(height: 20),
            _buildSystemStatusCard(),

            if (_statusMessage.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildStatusMessage(_statusMessage),
            ],
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 🧱 UI Components

  Widget _buildAITrioInfo() => Card(
        color: Colors.purple[50],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.groups, color: Colors.purple),
                  SizedBox(width: 8),
                  Text('🤖 AI ٹرائیو سسٹم', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 12),
              _buildAIInfo('🧠 BioMind AI', 'بیماری کی تحقیق اور تشخیص', 'Google Gemini'),
              _buildAIInfo('💊 CureSynth AI', 'نیا علاج تخلیق کرنا', 'HuggingFace BioGPT'),
              _buildAIInfo('📈 MedAnalyzer AI', 'ڈیٹا اور symptoms کا تجزیہ', 'OpenAI/Gemini'),
              _buildAIInfo('📄 MedReport AI', 'مکمل رپورٹ تیار کرنا', 'PDF جنریشن'),
              const SizedBox(height: 8),
              Text(
                'چاروں AI مل کر مکمل میڈیکل ریسرچ کرتے ہیں',
                style: TextStyle(color: Colors.purple[600], fontSize: 12),
              ),
            ],
          ),
        ),
      );

  Widget _buildAIInfo(String name, String description, String provider) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(flex: 2, child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold))),
            Expanded(flex: 3, child: Text(description, style: TextStyle(color: Colors.grey[600]))),
            Expanded(flex: 2, child: Text(provider, style: const TextStyle(fontSize: 12, color: Colors.blue))),
          ],
        ),
      );

  Widget _buildPDFInfoCard() => Card(
        color: Colors.green[50],
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PDF رپورٹ سسٹم', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('آٹومیٹک طور پر فعال - کوئی API key درکار نہیں'),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildSystemStatusCard() => Card(
        color: Colors.blue[50],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.psychology, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('AI سسٹم کی صورتحال', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 12),
              _buildStatusItem('BioMind AI (Gemini)', _geminiController.text.isNotEmpty, true),
              _buildStatusItem('CureSynth AI (HuggingFace)', _huggingfaceController.text.isNotEmpty, false),
              _buildStatusItem('MedAnalyzer AI (OpenAI)', _openaiController.text.isNotEmpty, false),
              _buildStatusItem('MedReport AI (PDF)', true, false),
              const Divider(height: 24),
              Text(
                _geminiController.text.isNotEmpty
                    ? '✅ سسٹم چلنے کے لیے تیار ہے'
                    : '❌ BioMind AI (Gemini) API Key درکار ہے',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _geminiController.text.isNotEmpty ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildStatusItem(String service, bool isActive, bool isRequired) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(
              isActive ? Icons.check_circle : Icons.error,
              color: isActive ? Colors.green : (isRequired ? Colors.red : Colors.orange),
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(service)),
            Text(
              isActive ? 'فعال' : (isRequired ? 'ضروری' : 'غیرفعال'),
              style: TextStyle(
                color: isActive ? Colors.green : (isRequired ? Colors.red : Colors.orange),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  Widget _buildSectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
      );

  Widget _buildApiField(TextEditingController controller, String label, String hint,
          {bool obscure = true}) =>
      TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          prefixIcon: const Icon(Icons.vpn_key),
        ),
      );

  Widget _buildStatusMessage(String message) {
    final isSuccess = message.contains('✅');
    final isError = message.contains('❌');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSuccess
            ? Colors.green[50]
            : isError
                ? Colors.red[50]
                : Colors.grey[100],
        border: Border.all(color: isSuccess ? Colors.green : (isError ? Colors.red : Colors.grey)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(message, textAlign: TextAlign.center),
    );
  }

  Widget _buildMainButton({
    required VoidCallback? onPressed,
    required String label,
    required IconData icon,
    required Color color,
  }) =>
      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: Icon(icon),
          label: Text(label),
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      );

  @override
  void dispose() {
    _geminiController.dispose();
    _huggingfaceController.dispose();
    _openaiController.dispose();
    _pdfController.dispose(); // ✅ Added missing dispose
    super.dispose();
  }
}
