// lib/models/quiz_model.dart
class QuizSection {
  final String id;
  final String title;
  final String description;
  final String category;
  final int duration;
  final List<Quiz> questions;

  QuizSection({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
    required this.questions,
  });

  factory QuizSection.fromJson(Map<String, dynamic> json) {
    return QuizSection(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      duration: json['duration'],
      questions: (json['questions'] as List)
          .map((q) => Quiz.fromJson(q))
          .toList(),
    );
  }
}

class Quiz {
  final String id;
  final String question;
  final List<QuizOption> options;
  final String correctAnswer;
  final String explanation;

  Quiz({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      question: json['question'],
      options: (json['options'] as List)
          .map((o) => QuizOption.fromJson(o))
          .toList(),
      correctAnswer: json['correctAnswer'],
      explanation: json['explanation'],
    );
  }
}

class QuizOption {
  final String id;
  final String text;

  QuizOption({required this.id, required this.text});

  factory QuizOption.fromJson(Map<String, dynamic> json) {
    return QuizOption(
      id: json['id'],
      text: json['text'],
    );
  }
}