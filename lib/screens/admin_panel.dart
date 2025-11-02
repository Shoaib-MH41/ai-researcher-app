import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/gemini_service.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final _geminiController = TextEditingController();
  final _storage = const FlutterSecureStorage();

  bool _isSaving = false;
  bool _isTestingGemini = false;
  String _statusMessage = '';

  final GeminiService _geminiService = GeminiService();

  @override
  void initState() {
    super.initState();
    _loadKeys();
  }

  Future<void> _loadKeys() async {
    final geminiKey = await _storage.read(key: 'gemini_api_key');
    setState(() {
      _geminiController.text = geminiKey ?? '';
    });
  }

  Future<void> _saveKeys() async {
    if (_geminiController.text.trim().isEmpty) {
      setState(() {
        _statusMessage = '❌ براہ کرم پہلے Gemini API key درج کریں';
      });
      return;
    }

    bool? shouldSave = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('API Key محفوظ کریں'),
        content: const Text('کیا آپ واقعی یہ API key محفوظ کرنا چاہتے ہیں؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('منسوخ'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('محفوظ کریں'),
          ),
        ],
      ),
    );

    if (shouldSave == true) {
      setState(() {
        _isSaving = true;
        _statusMessage = '';
      });

      try {
        final bool isGeminiValid = await _validateGeminiKey(_geminiController.text.trim());
        if (isGeminiValid) {
          await _geminiService.saveApiKey(_geminiController.text.trim());
          await _storage.write(key: 'gemini_api_key', value: _geminiController.text.trim());
          
          setState(() {
            _isSaving = false;
            _statusMessage = '✅ Gemini API key کامیابی سے محفوظ ہو گئی!';
          });
        } else {
          setState(() {
            _isSaving = false;
            _statusMessage = '❌ Gemini API key درست نہیں ہے';
          });
        }
      } catch (e) {
        setState(() {
          _isSaving = false;
          _statusMessage = '❌ Key محفوظ نہیں ہو سکی: $e';
        });
      }
    }
  }

  Future<void> _removeKeys() async {
    final geminiKey = await _storage.read(key: 'gemini_api_key');
    
    if (geminiKey == null || geminiKey.isEmpty) {
      setState(() {
        _statusMessage = 'ℹ️ ڈیلیٹ کرنے کے لیے کوئی Key موجود نہیں ہے';
      });
      return;
    }

    bool? shouldDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('API Key حذف کریں'),
        content: const Text('کیا آپ واقعی Gemini API key حذف کرنا چاہتے ہیں؟ یہ عمل واپس نہیں ہو سکتا۔'),
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
      await _geminiService.removeApiKey();
      await _storage.delete(key: 'gemini_api_key');
      setState(() {
        _geminiController.clear();
        _statusMessage = '🗑️ Gemini API key حذف کر دی گئی۔';
      });
    }
  }

  Future<void> _testGeminiConnection() async {
    if (_geminiController.text.trim().isEmpty) {
      setState(() {
        _statusMessage = '❌ براہ کرم پہلے Gemini API key درج کریں';
      });
      return;
    }

    final bool isValidFormat = _validateGeminiFormat(_geminiController.text.trim());
    if (!isValidFormat) {
      setState(() {
        _statusMessage = '❌ Gemini API key کا فارمیٹ غلط ہے';
      });
      return;
    }

    setState(() => _isTestingGemini = true);
    
    try {
      final success = await _geminiService.testConnection();
      setState(() {
        _isTestingGemini = false;
        _statusMessage = success
            ? '✅ Gemini کنکشن کامیاب ہے! API key درست ہے'
            : '❌ Gemini کنکشن ناکام۔ براہ کرم اپنی API key چیک کریں۔';
      });
    } catch (e) {
      setState(() {
        _isTestingGemini = false;
        _statusMessage = '❌ Gemini کنکشن چیک میں مسئلہ: $e';
      });
    }
  }

  bool _validateGeminiFormat(String apiKey) {
    if (apiKey.length < 20) return false;
    if (!apiKey.startsWith('AIza')) return false;
    return true;
  }

  Future<bool> _validateGeminiKey(String apiKey) async {
    if (!_validateGeminiFormat(apiKey)) return false;
    return await _geminiService.testConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔧 ایڈمن پینل'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('🧠 Gemini AI API'),
            _buildTextField(_geminiController, 'Gemini API Key درج کریں'),
            const SizedBox(height: 8),
            _buildTestButton(
              onPressed: _testGeminiConnection,
              isLoading: _isTestingGemini,
              label: 'Gemini کنکشن چیک کریں',
            ),
            const SizedBox(height: 30),

            // Action Buttons
            _buildMainButton(
              onPressed: _isSaving ? null : _saveKeys,
              label: _isSaving ? 'محفوظ ہو رہا ہے...' : 'Key محفوظ کریں',
              icon: Icons.save,
              color: Colors.green,
            ),

            const SizedBox(height: 10),

            _buildMainButton(
              onPressed: _removeKeys,
              label: 'Key حذف کریں',
              icon: Icons.delete_forever,
              color: Colors.red,
            ),

            const SizedBox(height: 20),

            // System Status
            _buildSystemStatusCard(),

            const SizedBox(height: 20),

            // Info Card
            _buildInfoCard(),

            const SizedBox(height: 20),

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
                Icon(Icons.medical_services, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'سسٹم کی صورتحال',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 12),
            _buildStatusItem('Gemini AI API', _geminiController.text.isNotEmpty),
            _buildStatusItem('PDF جنریشن', true),
            _buildStatusItem('لوکل اسٹوریج', true),
            _buildStatusItem('میڈیکل ریسرچ', true),
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
                  'رہنمائی',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('• Gemini API: "AIza" سے شروع ہونی چاہیے'),
            Text('• مفت ورژن: 60 requests فی دن'),
            Text('• Key محفوظ کرنے سے پہلے خودبخود validate ہوگی'),
            Text('• تمام ڈیٹا لوکل ڈیوائس پر محفوظ ہوگا'),
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
    } else if (message.contains('ℹ️')) {
      backgroundColor = Colors.blue[50]!;
      borderColor = Colors.blue;
      icon = Icons.info;
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
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      );

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: const Icon(Icons.vpn_key),
      ),
      obscureText: false, // Changed to false for easier testing
    );
  }

  Widget _buildTestButton({
    required VoidCallback onPressed,
    required bool isLoading,
    required String label,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.wifi_tethering),
        label: Text(isLoading ? 'چیک ہو رہا ہے...' : label),
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
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
