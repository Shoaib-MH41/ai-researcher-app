import 'package:flutter/material.dart';
import '../services/medical_research_service.dart';
import '../services/gemini_service.dart'; // GeminiService import کریں
import 'results_screen.dart';

class ResearchScreen extends StatefulWidget {
  const ResearchScreen({super.key});

  @override
  State<ResearchScreen> createState() => _ResearchScreenState();
}

class _ResearchScreenState extends State<ResearchScreen> {
  final TextEditingController _topicController = TextEditingController();
  final MedicalResearchService _researchService = MedicalResearchService();
  final GeminiService _geminiService = GeminiService(); // نیا GeminiService
  bool _isLoading = false;
  bool _isAILoading = false; // نیا AI لوڈنگ اسٹیٹ
  String _selectedCategory = '';

  // میڈیکل کیٹیگریز
  final List<String> _medicalCategories = [
    'diabetes',
    'cancer', 
    'heart disease',
    'covid',
    'arthritis',
    'asthma',
    'blood pressure',
    'cholesterol'
  ];

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('میڈیکل تحقیق'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          // AI سائنسدان کا بٹن
          IconButton(
            icon: Icon(Icons.smart_toy),
            onPressed: _navigateToAILab,
            tooltip: 'AI سائنسدان لیب',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  // ہدایات
                  Card(
                    color: Colors.blue[50],
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info, color: Colors.blue),
                              SizedBox(width: 8),
                              Text(
                                'ہدایات',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text('• میڈیکل تحقیق کا موضوع درج کریں'),
                          Text('• کیٹیگری منتخب کریں (اختیاری)'),
                          Text('• تحقیق شروع کریں'),
                          Text('• AI سائنسدان کے ساتھ جدید تحقیق کریں'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // AI سائنسدان کارڈ - نیا addition
                  Card(
                    color: Colors.purple[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.science, color: Colors.purple),
                              SizedBox(width: 8),
                              Text(
                                'AI سائنسدان',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple[700],
                                  fontSize: 18
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'جدید AI ٹیکنالوجی کے ساتھ مکمل سائنسی تحقیق کریں۔',
                            style: TextStyle(color: Colors.purple[600]),
                          ),
                          SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _isAILoading ? null : _startAIResearch,
                              icon: Icon(_isAILoading ? Icons.hourglass_empty : Icons.psychology),
                              label: Text(
                                _isAILoading ? 
                                'AI سائنسدان کام کر رہا ہے...' : 
                                'AI سائنسدان کے ساتھ تحقیق کریں',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // تحقیقی موضوع
                  const Text(
                    'میڈیکل تحقیق کا موضوع درج کریں',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _topicController,
                    decoration: const InputDecoration(
                      hintText: 'مثال: ذیابیطس کا نیا علاج، کینسر کی نئی دوا وغیرہ',
                      border: OutlineInputBorder(),
                      labelText: 'تحقیق کا موضوع',
                      prefixIcon: Icon(Icons.medical_services),
                    ),
                    maxLines: 3,
                  ),

                  const SizedBox(height: 16),

                  // میڈیکل کیٹیگری ڈراپ ڈاؤن
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'میڈیکل کیٹیگری (اختیاری)',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedCategory.isEmpty ? null : _selectedCategory,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'کیٹیگری منتخب کریں',
                            ),
                            items: _medicalCategories.map((String category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(_getCategoryDisplayName(category)),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedCategory = newValue ?? '';
                                if (newValue != null) {
                                  _topicController.text = _getCategoryExample(newValue);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (_isLoading || _isAILoading)
                    _buildLoadingIndicator()
                  else
                    _buildMedicalExamples(),
                ],
              ),
            ),

            // تحقیق شروع کرنے کا بٹن
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _startResearch,
                icon: Icon(_isLoading ? Icons.hourglass_empty : Icons.play_arrow),
                label: Text(
                  _isLoading ? 'تحقیق جاری ہے...' : 'میڈیکل تحقیق شروع کریں',
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isLoading ? Colors.grey : Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // نیا لوڈنگ انڈیکیٹر
  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        Center(
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                _isAILoading ? 
                '🔬 AI سائنسدان تحقیقی مراحل کر رہا ہے...' : 
                'AI میڈیکل تحقیق کر رہا ہے...',
                style: TextStyle(color: Colors.blue),
                textAlign: TextAlign.center,
              ),
              if (_isAILoading) ...[
                SizedBox(height: 8),
                Text(
                  '• ڈیٹا تجزیہ\n• لیب ٹیسٹنگ\n• شماریاتی انسائٹس\n• طبی سفارشات',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMedicalExamples() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'میڈیکل تحقیق کی مثالیں:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildExampleChip('ذیابیطس کا نیا علاج'),
                _buildExampleChip('کینسر کی نئی دوا'),
                _buildExampleChip('دل کی بیماریوں کا علاج'),
                _buildExampleChip('ورم کا نیا علاج'),
                _buildExampleChip('بلڈ پریشر کنٹرول'),
                _buildExampleChip('کولیسٹرول کم کرنے والی دوا'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleChip(String text) {
    return GestureDetector(
      onTap: () {
        _topicController.text = text;
        setState(() {
          _selectedCategory = ''; // Reset category when manual text entered
        });
      },
      child: Chip(
        label: Text(text),
        backgroundColor: Colors.blue[100],
      ),
    );
  }

  String _getCategoryDisplayName(String category) {
    final names = {
      'diabetes': 'ذیابیطس',
      'cancer': 'کینسر',
      'heart disease': 'دل کی بیماری',
      'covid': 'کوویڈ 19',
      'arthritis': 'گٹھیا',
      'asthma': 'دمہ',
      'blood pressure': 'بلڈ پریشر',
      'cholesterol': 'کولیسٹرول',
    };
    return names[category] ?? category;
  }

  String _getCategoryExample(String category) {
    final examples = {
      'diabetes': 'ذیابیطس کے لیے نیا انسولین علاج',
      'cancer': 'کینسر کی نئی کیموتھراپی',
      'heart disease': 'دل کی بیماریوں کا نیا علاج',
      'covid': 'کوویڈ 19 کی نئی ویکسین',
      'arthritis': 'گٹھیا کے درد کا علاج',
      'asthma': 'دمہ کے لیے نئی دوا',
      'blood pressure': 'بلڈ پریشر کنٹرول کرنے والی دوا',
      'cholesterol': 'کولیسٹرول کم کرنے والی دوا',
    };
    return examples[category] ?? '$category کا نیا علاج';
  }

  // ========== نیا AI سائنسدان فنکشن ==========
  
  Future<void> _startAIResearch() async {
    if (_topicController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('براہ کرم تحقیق کا موضوع درج کریں')),
      );
      return;
    }

    setState(() => _isAILoading = true);

    try {
      // GeminiService کا نیا method استعمال کریں
      final aiResearch = await _geminiService.conductAIScientificResearch(
        _topicController.text,
        'میڈیکل ڈیٹا: ${_topicController.text} - کیٹیگری: $_selectedCategory'
      );
      
      setState(() => _isAILoading = false);

      if (!mounted) return;
      
      // Results screen پر AI research بھیجیں
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(
            research: aiResearch,
            isAIResearch: true, // نیا parameter
          ),
        ),
      );
      
    } catch (e) {
      setState(() => _isAILoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('AI تحقیق میں مسئلہ آیا: $e')),
      );
    }
  }

  // AI لیب اسکرین پر navigate کرنے کا فنکشن
  void _navigateToAILab() {
    // آپ research_lab_screen.dart کو اپ ڈیٹ کریں گے
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => ResearchLabScreen()),
    // );
    
    // فی الحال ایک message دکھائیں
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('AI سائنسدان لیب جلد دستیاب ہوگا')),
    );
  }

  // پرانا research method (تبدیلی کے بغیر)
  Future<void> _startResearch() async {
    if (_topicController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('براہ کرم تحقیق کا موضوع درج کریں')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final research = await _researchService.conductMedicalResearch(_topicController.text);
      
      setState(() => _isLoading = false);

      if (!mounted) return;
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(
            research: research,
            isAIResearch: false, // پرانی تحقیق
          ),
        ),
      );
      
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تحقیق میں مسئلہ آیا: $e')),
      );
    }
  }
}
