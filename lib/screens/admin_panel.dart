import 'package:flutter/material.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isAuthenticated = false;

  void _authenticate() {
    if (_passwordController.text == 'admin123') {
      setState(() {
        _isAuthenticated = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Incorrect password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Panel')),
      body: _isAuthenticated ? _buildAdminContent() : _buildLoginForm(),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Admin Login', style: TextStyle(fontSize: 24)),
          SizedBox(height: 20),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _authenticate,
            child: Text('Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminContent() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('API Configuration', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Gemini API Key:', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(decoration: InputDecoration(hintText: 'Enter API key here')),
                  SizedBox(height: 16),
                  Text('HuggingFace API Key:', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(decoration: InputDecoration(hintText: 'Enter API key here')),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Text('System Status', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• Gemini API: Ready for integration'),
                  Text('• HuggingFace: Ready for integration'),
                  Text('• Firebase: Ready for integration'),
                  Text('• Scientific APIs: Configuration ready'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
