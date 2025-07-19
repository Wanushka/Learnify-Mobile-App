import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
import '../services/quiz_service.dart';

class QuizProvider with ChangeNotifier {
  List<QuizSection> _quizSections = [];
  Map<String, Map<String, String>> _selectedAnswers = {};
  Map<String, int> _sectionScores = {};
  bool _isLoading = false;

  QuizProvider() {
    loadQuizzes();
  }

  List<QuizSection> get quizSections => _quizSections;
  bool get isLoading => _isLoading;
  
  int getQuizScore(String sectionId) => _sectionScores[sectionId] ?? 0;
  
  Future<void> loadQuizzes() async {
    _isLoading = true;
    notifyListeners();

    try {
      _quizSections = await QuizService().getQuizzes();
    } catch (e) {
      print("Failed to load quizzes: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  void submitAnswer(String sectionId, String questionId, String selectedAnswer) {
    _selectedAnswers[sectionId] ??= {};
    _selectedAnswers[sectionId]![questionId] = selectedAnswer;
    
    final section = _quizSections.firstWhere((s) => s.id == sectionId);
    int correctAnswers = 0;
    
    for (var question in section.questions) {
      final selected = _selectedAnswers[sectionId]![question.id];
      if (selected == question.correctAnswer) {
        correctAnswers++;
      }
    }
    
    _sectionScores[sectionId] = correctAnswers;
    notifyListeners();
  }

  bool isAnswerSelected(String sectionId, String questionId) {
    return _selectedAnswers[sectionId]?.containsKey(questionId) ?? false;
  }

  String? getSelectedAnswer(String sectionId, String questionId) {
    return _selectedAnswers[sectionId]?[questionId];
  }

  void resetQuiz(String sectionId) {
    _selectedAnswers.remove(sectionId);
    _sectionScores.remove(sectionId);
    notifyListeners();
  }
}