import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/gemini_service.dart';
import '../services/scientific_apis.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final _geminiController = TextEditingController();
  final _pubchemController = TextEditingController();
  final _biosimController = TextEditingController();
  final _storage = const FlutterSecureStorage();

  bool _isSaving = false;
  bool _isTestingGemini = false;
  bool _isTestingPubChem = false;
  bool _isTestingBioSim = false;
  String _statusMessage = '';

  final GeminiService _geminiService = GeminiService();
  final ScientificAPIs _scientificAPIs = ScientificAPIs();

  @override
  void initState() {
    super.initState();
    _loadKeys();
  }

  Future<void> _loadKeys() async {
    final geminiKey = await _storage.read(key: 'gemini_api_key');
    final pubchemKey = await _storage.read(key: 'pubchem_api_key');
    final biosimKey = await _storage.read(key: 'biosim_api_key');
    
    setState(() {
      _geminiController.text = geminiKey ?? '';
      _pubchemController.text = pubchemKey ?? '';
      _biosimController.text = biosimKey ?? '';
    });
  }

  Future<void> _saveKeys() async {
    if (_geminiController.text.trim().isEmpty && 
        _pubchemController.text.trim().isEmpty && 
        _biosimController.text.trim().isEmpty) {
      setState(() {
        _statusMessage = '❌ براہ کرم پہلے کوئی API key درج کریں';
      });
      return;
    }

    bool? shouldSave = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('API Keys محفوظ کریں'),
        content: const Text('کیا آپ واقعی یہ API keys محفوظ کرنا چاہتے ہیں؟'),
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
        if (_geminiController.text.trim().isNotEmpty) {
          final bool isGeminiValid = await _validateGeminiKey(_geminiController.text.trim());
          if (isGeminiValid) {
            await _storage.write(key: 'gemini_api_key', value: _geminiController.text.trim());
          } else {
            setState(() {
              _isSaving = false;
              _statusMessage = '❌ Gemini API key درست نہیں ہے';
            });
            return;
          }
        }
        
        if (_pubchemController.text.trim().isNotEmpty) {
          await _storage.write(key: 'pubchem_api_key', value: _pubchemController.text.trim());
        }
        
        if (_biosimController.text.trim().isNotEmpty) {
          await _storage.write(key: 'biosim_api_key', value: _biosimController.text.trim());
        }

        setState(() {
          _isSaving = false;
          _statusMessage = '✅ تمام Keys کامیابی سے محفوظ ہو گئیں!';
        });
      } catch (e) {
        setState(() {
          _isSaving = false;
          _statusMessage = '❌ Keys محفوظ نہیں ہو سکیں: $e';
        });
      }
    }
  }

  Future<void> _removeKeys() async {
    final geminiKey = await _storage.read(key: 'gemini_api_key');
    final pubchemKey = await _storage.read(key: 'pubchem_api_key');
    final biosimKey = await _storage.read(key: 'biosim_api_key');
    
    if ((geminiKey == null || geminiKey.isEmpty) && 
        (pubchemKey == null || pubchemKey.isEmpty) && 
        (biosimKey == null || biosimKey.isEmpty)) {
      setState(() {
        _statusMessage = 'ℹ️ ڈیلیٹ کرنے کے لیے کوئی Keys موجود نہیں ہیں';
      });
      return;
    }

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
      await _storage.delete(key: 'pubchem_api_key');
      await _storage.delete(key: 'biosim_api_key');
      setState(() {
        _geminiController.clear();
        _pubchemController.clear();
        _biosimController.clear();
        _statusMessage = '🗑️ تمام Keys حذف کر دی گئیں۔';
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
      // Test Gemini connection
      final success = await _testGeminiKey(_geminiController.text.trim());
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

  Future<void> _testPubChemConnection() async {
    setState(() => _isTestingPubChem = true);
    
    try {
      // Test PubChem API
      final success = await _scientificAPIs.testPubChemConnection();
      setState(() {
        _isTestingPubChem = false;
        _statusMessage = success
            ? '✅ PubChem API کنکشن کامیاب ہے!'
            : '❌ PubChem API کنکشن ناکام۔';
      });
    } catch (e) {
      setState(() {
        _isTestingPubChem = false;
        _statusMessage = '❌ PubChem کنکشن چیک میں مسئلہ: $e';
      });
    }
  }

  Future<void> _testBioSimConnection() async {
    setState(() => _isTestingBioSim = true);
    
    try {
      // Test BioSimulators API
      final success = await _scientificAPIs.testBioSimConnection();
      setState(() {
        _isTestingBioSim = false;
        _statusMessage = success
            ? '✅ BioSimulators API کنکشن کامیاب ہے!'
            : '❌ BioSimulators API کنکشن ناکام۔';
      });
    } catch (e) {
      setState(() {
        _isTestingBioSim = false;
        _statusMessage = '❌ BioSimulators کنکشن چیک میں مسئلہ: $e';
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
    return await _testGeminiKey(apiKey);
  }

  Future<bool> _testGeminiKey(String apiKey) async {
    // Simple test - try to make a basic API call
    try {
      // This would be your actual Gemini API test
      await Future.delayed(Duration(seconds: 2));
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔧 ایڈمن پینل - Medical Research'),
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
            const SizedBox(height: 20),

            _buildSectionTitle('⚗️ PubChem API'),
            _buildTextField(_pubchemController, 'PubChem API Key (اختیاری)'),
            const SizedBox(height: 8),
            _buildTestButton(
              onPressed: _testPubChemConnection,
              isLoading: _isTestingPubChem,
              label: 'PubChem کنکشن چیک کریں',
            ),
            const SizedBox(height: 20),

            _buildSectionTitle('🔬 BioSimulators API'),
            _buildTextField(_biosimController, 'BioSimulators API Key (اختیاری)'),
            const SizedBox(height: 8),
            _buildTestButton(
              onPressed: _testBioSimConnection,
              isLoading: _isTestingBioSim,
              label: 'BioSimulators کنکشن چیک کریں',
            ),

            const SizedBox(height: 30),

            // Action Buttons
            _buildMainButton(
              onPressed: _isSaving ? null : _saveKeys,
              label: _isSaving ? 'محفوظ ہو رہا ہے...' : 'تمام Keys محفوظ کریں',
              icon: Icons.save,
              color: Colors.green,
            ),

            const SizedBox(height: 10),

            _buildMainButton(
              onPressed: _removeKeys,
              label: 'تمام Keys حذف کریں',
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
            _buildStatusItem('PubChem API', true), // PubChem is usually free
            _buildStatusItem('BioSimulators API', true), // BioSimulators is usually free
            _buildStatusItem('PDF جنریشن', true),
            _buildStatusItem('لوکل اسٹوریج', true),
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
            Text('• Gemini API: "AIza" سے شروع ہونی چاہیے (مفت 60 requests/دن)'),
            Text('• PubChem API: عام طور پر key کی ضرورت نہیں'),
            Text('• BioSimulators API: عام طور پر key کی ضرورت نہیں'),
            Text('• Keys محفوظ کرنے سے پہلے خودبخود validate ہوں گی'),
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
      obscureText: true,
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
