
import 'package:flutter/material.dart';
import 'research_screen.dart';
import 'history_screen.dart';
import 'admin_panel.dart';
import 'research_lab_screen.dart';
import 'discovery_screen.dart'; // نیا import

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Researcher'),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminPanel()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // === 1. ویلکم کارڈ ===
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Icon(Icons.science, size: 64, color: Colors.blue),
                    const SizedBox(height: 16),
                    const Text(
                      'AI Research Assistant',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start your scientific research with AI-powered analysis',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // === 2. نیا AI ٹرائیو ڈسکوری کارڈ (بڑا بینر) ===
            Card(
              color: Colors.purple[50],
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.groups, color: Colors.purple, size: 40),
                title: const Text(
                  'AI ٹرائیو ڈسکوری',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'چار AI مل کر نیا علاج دریافت کریں\n'
                  'BioMind + CureSynth + MedAnalyzer + MedReport',
                  style: TextStyle(fontSize: 13),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.purple),
                contentPadding: const EdgeInsets.all(16),
                onTap: () {
                  Navigator.pushNamed(context, '/discovery');
                },
              ),
            ),

            const SizedBox(height: 20),

            // === 3. فیچرز کا GridView ===
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                _buildFeatureCard(
                  'Research',
                  Icons.article,
                  Colors.green,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ResearchScreen())),
                ),
                _buildFeatureCard(
                  'AI Lab',
                  Icons.biotech,
                  Colors.red,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ResearchLabScreen())),
                ),
                _buildFeatureCard(
                  'History',
                  Icons.history,
                  Colors.orange,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
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
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminPanel())),
                ),
                _buildFeatureCard(
                  'Settings',
                  Icons.settings,
                  Colors.grey,
                  () => _showSettings(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // === فیچر کارڈ ===
  Widget _buildFeatureCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // === ٹیمپلیٹس ڈائیلاگ ===
  void _showTemplates(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Research Templates'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(leading: Icon(Icons.science), title: Text('Scientific Paper Analysis')),
            ListTile(leading: Icon(Icons.eco), title: Text('Biological Study')),
            ListTile(leading: Icon(Icons.psychology), title: Text('Chemical Research')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('بند کریں')),
        ],
      ),
    );
  }

  // === سیٹنگز ڈائیلاگ ===
  void _showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Settings'),
        content: const Text('App configuration options will appear here'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('بند کریں')),
        ],
      ),
    );
  }
}
