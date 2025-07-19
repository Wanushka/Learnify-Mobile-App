import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/quiz_model.dart';

// lib/services/quiz_service.dart
class QuizService {
  Future<List<QuizSection>> getQuizzes() async {
    try {
      final String response = await rootBundle.loadString('assets/data/quizzes.json');
      final Map<String, dynamic> jsonData = json.decode(response);
      
      return (jsonData['quizzes'] as List)
          .map((quiz) => QuizSection.fromJson(quiz))
          .toList();
    } catch (e) {
      print("Error loading quizzes: $e");
      return [];
    }
  }
}