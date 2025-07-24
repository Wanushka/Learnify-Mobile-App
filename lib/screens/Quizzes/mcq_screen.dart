// screens/mcq_screen.dart

import 'package:flutter/material.dart';
import 'package:learnifyapp/services/api_service.dart';
import 'package:learnifyapp/models/api_models.dart';

class MCQScreen extends StatefulWidget {
  const MCQScreen({Key? key}) : super(key: key);

  @override
  _MCQScreenState createState() => _MCQScreenState();
}

class _MCQScreenState extends State<MCQScreen> {
  final TextEditingController _textController = TextEditingController();
  List<MCQQuestion> _questions = [];
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _generateQuestions() async {
    if (_textController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter some text';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _questions = [];
    });

    try {
      final response = await ApiService.generateQuestions(_textController.text.trim());
      setState(() {
        _questions = response.questions;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MCQ Generator'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Enter Text for MCQ Generation:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _textController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your text here...',
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _generateQuestions,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: _isLoading
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text('Generating Questions...'),
                              ],
                            )
                          : const Text('Generate Questions'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Error Message
            if (_errorMessage.isNotEmpty)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
              ),

            // Questions List
            if (_questions.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    final question = _questions[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Question ${index + 1}:',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              question.question,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...question.options.asMap().entries.map((entry) {
                              int optionIndex = entry.key;
                              String option = entry.value;
                              bool isCorrect = optionIndex == question.correctAnswer;
                              
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isCorrect 
                                      ? Colors.green.shade50 
                                      : Colors.grey.shade50,
                                  border: Border.all(
                                    color: isCorrect 
                                        ? Colors.green 
                                        : Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '${String.fromCharCode(65 + optionIndex)}. ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isCorrect ? Colors.green : null,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        option,
                                        style: TextStyle(
                                          color: isCorrect ? Colors.green.shade700 : null,
                                        ),
                                      ),
                                    ),
                                    if (isCorrect)
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 20,
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}