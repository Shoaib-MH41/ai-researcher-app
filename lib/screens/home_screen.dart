import 'package:flutter/material.dart';
import 'research_screen.dart';
import 'history_screen.dart';
import 'admin_panel.dart';
import 'research_lab_screen.dart';  // Naya import add karen

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Researcher'),
        actions: [
          IconButton(
            icon: Icon(Icons.admin_panel_settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminPanel()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(Icons.science, size: 64, color: Colors.blue),
                    SizedBox(height: 16),
                    Text(
                      'AI Research Assistant',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Start your scientific research with AI-powered analysis',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  _buildFeatureCard(
                    'Research',
                    Icons.article,
                    Colors.green,
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => ResearchScreen())),
                  ),
                  _buildFeatureCard(
                    'AI Lab',  // Naya button - AI Lab
                    Icons.biotech,  // Naya icon
                    Colors.red,  // Naya color
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => ResearchLabScreen())),
                  ),
                  _buildFeatureCard(
                    'History', 
                    Icons.history,
                    Colors.orange,
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryScreen())),
                  ),
                  _buildFeatureCard(
                    'Templates',
                    Icons.description,
                    Colors.purple,
                    () => _showTemplates(context),
                  ),
                  _buildFeatureCard(
                    'Admin',
                    Icons.admin_panel_settings,
                    Colors.blue,
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPanel())),
                  ),
                  _buildFeatureCard(
                    'Settings',
                    Icons.settings,
                    Colors.grey,
                    () => _showSettings(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(String title, IconData icon, Color color, Function onTap) {
    return Card(
      child: InkWell(
        onTap: onTap as void Function()?,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            SizedBox(height: 8),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _showTemplates(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Research Templates'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(leading: Icon(Icons.science), title: Text('Scientific Paper Analysis')),
            ListTile(leading: Icon(Icons.eco), title: Text('Biological Study')),
            ListTile(leading: Icon(Icons.psychology), title: Text('Chemical Research')),
          ],
        ),
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Settings'),
        content: Text('App configuration options will appear here'),
      ),
    );
  }
}
