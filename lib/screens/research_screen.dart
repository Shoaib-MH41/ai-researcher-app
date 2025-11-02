import 'package:flutter/material.dart';
import '../services/medical_research_service.dart';
import 'results_screen.dart';

class ResearchScreen extends StatefulWidget {
  const ResearchScreen({super.key});

  @override
  State<ResearchScreen> createState() => _ResearchScreenState();
}

class _ResearchScreenState extends State<ResearchScreen> {
  final TextEditingController _topicController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medical Research')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const Text(
                    'Enter Medical Research Topic',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _topicController,
                    decoration: const InputDecoration(
                      hintText: 'Example: Efficacy of new drug for diabetes...',
                      border: OutlineInputBorder(),
                      labelText: 'Research Topic',
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    _buildMedicalExamples(),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _startResearch,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                  _isLoading ? 'Research in Progress...' : 'Start Medical Research'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalExamples() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Medical Research Examples:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• Drug efficacy studies'),
            Text('• Clinical trial analysis'),
            Text('• Medical data interpretation'),
            Text('• Treatment outcome research'),
          ],
        ),
      ),
    );
  }

  Future<void> _startResearch() async {
    if (_topicController.text.isEmpty) return;

    setState(() => _isLoading = true);
    final research =
        await MedicalResearchService().conductMedicalResearch(_topicController.text);
    setState(() => _isLoading = false);

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultsScreen(research: research)),
    );
  }
}
