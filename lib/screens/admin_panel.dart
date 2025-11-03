import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final _storage = const FlutterSecureStorage();
  
  // تمام AI APIs کے لیے controllers
  final _geminiController = TextEditingController();
  final _deepseekController = TextEditingController();
  final _openaiController = TextEditingController();
  final _wolframController = TextEditingController();
  final _ncbiController = TextEditingController();
  final _exaController = TextEditingController();
  final _biotthingsController = TextEditingController();
  
  bool _isSaving = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _loadAllKeys();
  }

  Future<void> _loadAllKeys() async {
    // تمام APIs کے keys load karen
    final geminiKey = await _storage.read(key: 'gemini_api_key');
    final deepseekKey = await _storage.read(key: 'deepseek_api_key');
    final openaiKey = await _storage.read(key: 'openai_api_key');
    final wolframKey = await _storage.read(key: 'wolfram_api_key');
    final ncbiKey = await _storage.read(key: 'ncbi_api_key');
    final exaKey = await _storage.read(key: 'exa_api_key');
    final biothingsKey = await _storage.read(key: 'biotthings_api_key');

    setState(() {
      _geminiController.text = geminiKey ?? '';
      _deepseekController.text = deepseekKey ?? '';
      _openaiController.text = openaiKey ?? '';
      _wolframController.text = wolframKey ?? '';
      _ncbiController.text = ncbiKey ?? '';
      _exaController.text = exaKey ?? '';
      _biotthingsController.text = biothingsKey ?? '';
    });
  }

  Future<void> _saveAllKeys() async {
    if (_geminiController.text.isEmpty && 
        _deepseekController.text.isEmpty &&
        _openaiController.text.isEmpty) {
      setState(() {
        _statusMessage = '❌ براہ کرم کم از کم ایک AI API key درج کریں';
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _statusMessage = '';
    });

    try {
      // تمام keys save karen
      if (_geminiController.text.isNotEmpty) {
        await _storage.write(key: 'gemini_api_key', value: _geminiController.text.trim());
      }
      if (_deepseekController.text.isNotEmpty) {
        await _storage.write(key: 'deepseek_api_key', value: _deepseekController.text.trim());
      }
      if (_openaiController.text.isNotEmpty) {
        await _storage.write(key: 'openai_api_key', value: _openaiController.text.trim());
      }
      if (_wolframController.text.isNotEmpty) {
        await _storage.write(key: 'wolfram_api_key', value: _wolframController.text.trim());
      }
      if (_ncbiController.text.isNotEmpty) {
        await _storage.write(key: 'ncbi_api_key', value: _ncbiController.text.trim());
      }
      if (_exaController.text.isNotEmpty) {
        await _storage.write(key: 'exa_api_key', value: _exaController.text.trim());
      }
      if (_biotthingsController.text.isNotEmpty) {
        await _storage.write(key: 'biotthings_api_key', value: _biotthingsController.text.trim());
      }

      setState(() {
        _isSaving = false;
        _statusMessage = '✅ تمام API Keys کامیابی سے محفوظ ہو گئیں!';
      });
    } catch (e) {
      setState(() {
        _isSaving = false;
        _statusMessage = '❌ Keys محفوظ نہیں ہو سکیں: $e';
      });
    }
  }

  Future<void> _deleteAllKeys() async {
    bool? shouldDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تمام Keys حذف کریں'),
        content: const Text('کیا آپ واقعی تمام API keys حذف کرنا چاہتے ہیں؟ یہ عمل واپس نہیں ہو سکتا۔'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('منسوخ'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف کریں'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await _storage.delete(key: 'gemini_api_key');
      await _storage.delete(key: 'deepseek_api_key');
      await _storage.delete(key: 'openai_api_key');
      await _storage.delete(key: 'wolfram_api_key');
      await _storage.delete(key: 'ncbi_api_key');
      await _storage.delete(key: 'exa_api_key');
      await _storage.delete(key: 'biotthings_api_key');
      
      setState(() {
        _geminiController.clear();
        _deepseekController.clear();
        _openaiController.clear();
        _wolframController.clear();
        _ncbiController.clear();
        _exaController.clear();
        _biotthingsController.clear();
        _statusMessage = '🗑️ تمام Keys حذف کر دی گئیں۔';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔧 AI سسٹم مینجمنٹ'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🧠 RESEARCH AIs SECTION
            _buildSectionTitle('🧠 تحقیقاتی AI APIs'),
            _buildApiField(_geminiController, 'Google Gemini API Key', 'AIza...'),
            _buildApiField(_deepseekController, 'DeepSeek API Key', 'sk-...'),
            _buildApiField(_openaiController, 'OpenAI API Key', 'sk-...'),
            
            SizedBox(height: 20),
            
            // 🔬 SCIENTIFIC APIs SECTION
            _buildSectionTitle('🔬 سائنسی ڈیٹا APIs'),
            _buildApiField(_wolframController, 'WolframAlpha App ID', 'XXXXXX-XXXXXXXXXX'),
            _buildApiField(_ncbiController, 'NCBI API Key (اختیاری)', ''),
            _buildApiField(_exaController, 'Exa Search API Key', ''),
            _buildApiField(_biotthingsController, 'BioThings API Key (اختیاری)', ''),
            
            SizedBox(height: 30),

            // ACTION BUTTONS
            _buildMainButton(
              onPressed: _isSaving ? null : _saveAllKeys,
              label: _isSaving ? 'محفوظ ہو رہا ہے...' : 'تمام Keys محفوظ کریں',
              icon: Icons.save,
              color: Colors.green,
            ),

            SizedBox(height: 10),

            _buildMainButton(
              onPressed: _deleteAllKeys,
              label: 'تمام Keys حذف کریں',
              icon: Icons.delete_forever,
              color: Colors.red,
            ),

            SizedBox(height: 20),

            // SYSTEM STATUS
            _buildSystemStatusCard(),

            SizedBox(height: 20),

            // INFO CARD
            _buildInfoCard(),

            SizedBox(height: 20),

            if (_statusMessage.isNotEmpty)
              _buildStatusMessage(_statusMessage),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemStatusCard() {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'AI سسٹم کی صورتحال',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 12),
            _buildStatusItem('Google Gemini', _geminiController.text.isNotEmpty),
            _buildStatusItem('DeepSeek AI', _deepseekController.text.isNotEmpty),
            _buildStatusItem('OpenAI', _openaiController.text.isNotEmpty),
            _buildStatusItem('WolframAlpha', _wolframController.text.isNotEmpty),
            _buildStatusItem('NCBI', true), // NCBI generally free
            _buildStatusItem('Exa Search', _exaController.text.isNotEmpty),
            _buildStatusItem('BioThings', true), // BioThings generally free
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String service, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.error,
            color: isActive ? Colors.green : Colors.orange,
            size: 20,
          ),
          SizedBox(width: 8),
          Text(service),
          Spacer(),
          Text(
            isActive ? 'فعال' : 'غیرفعال',
            style: TextStyle(
              color: isActive ? Colors.green : Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: Colors.orange[50],
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'رہنمائی اور لنکس',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('• Gemini: https://aistudio.google.com/'),
            Text('• DeepSeek: https://platform.deepseek.com/'),
            Text('• OpenAI: https://platform.openai.com/'),
            Text('• WolframAlpha: https://developer.wolframalpha.com/'),
            Text('• NCBI: https://www.ncbi.nlm.nih.gov/home/develop/api/'),
            Text('• Exa: https://exa.ai/'),
            Text('• BioThings: https://biothings.io/'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusMessage(String message) {
    Color backgroundColor = Colors.grey[50]!;
    Color borderColor = Colors.grey;
    IconData icon = Icons.info;

    if (message.contains('✅')) {
      backgroundColor = Colors.green[50]!;
      borderColor = Colors.green;
      icon = Icons.check_circle;
    } else if (message.contains('❌')) {
      backgroundColor = Colors.red[50]!;
      borderColor = Colors.red;
      icon = Icons.error;
    } else if (message.contains('🗑️')) {
      backgroundColor = Colors.orange[50]!;
      borderColor = Colors.orange;
      icon = Icons.delete;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: borderColor),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 12, top: 8),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      );

  Widget _buildApiField(TextEditingController controller, String label, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          prefixIcon: Icon(Icons.vpn_key),
        ),
        obscureText: !label.contains('اختیاری'), // Optional fields visible
      ),
    );
  }

  Widget _buildMainButton({
    required VoidCallback? onPressed,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return SizedBox(
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
  }
}
