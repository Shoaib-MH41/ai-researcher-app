import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final _geminiController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  bool _isLoading = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _loadKey();
  }

  Future<void> _loadKey() async {
    final geminiKey = await _storage.read(key: 'gemini_api_key');
    setState(() {
      _geminiController.text = geminiKey ?? '';
    });
  }

  Future<void> _saveKey() async {
    if (_geminiController.text.isEmpty) return;
    
    setState(() {
      _isLoading = true;
      _statusMessage = '';
    });

    try {
      await _storage.write(key: 'gemini_api_key', value: _geminiController.text.trim());
      setState(() {
        _isLoading = false;
        _statusMessage = '✅ API key محفوظ ہو گئی';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = '❌ Key محفوظ نہیں ہو سکی';
      });
    }
  }

  Future<void> _deleteKey() async {
    await _storage.delete(key: 'gemini_api_key');
    setState(() {
      _geminiController.clear();
      _statusMessage = '🗑️ Key حذف ہو گئی';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ایڈمن پینل')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _geminiController,
              decoration: InputDecoration(
                labelText: 'Gemini API Key',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveKey,
                    child: Text(_isLoading ? 'سےونگ...' : 'محفوظ کریں'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _deleteKey,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text('حذف کریں'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (_statusMessage.isNotEmpty)
              Text(_statusMessage),
          ],
        ),
      ),
    );
  }
}
