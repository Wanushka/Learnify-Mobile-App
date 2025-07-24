// models/api_models.dart

class MCQQuestion {
  final String question;
  final List<String> options;
  final int correctAnswer;

  MCQQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory MCQQuestion.fromJson(Map<String, dynamic> json) {
    return MCQQuestion(
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correct_answer'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'correct_answer': correctAnswer,
    };
  }
}

class MCQResponse {
  final List<MCQQuestion> questions;

  MCQResponse({required this.questions});

  factory MCQResponse.fromJson(Map<String, dynamic> json) {
    var questionsJson = json['questions'] as List;
    List<MCQQuestion> questionsList = questionsJson
        .map((questionJson) => MCQQuestion.fromJson(questionJson))
        .toList();

    return MCQResponse(questions: questionsList);
  }
}

class ChatMessage {
  final String message;

  ChatMessage({required this.message});

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}

class ChatResponse {
  final String response;
  final String status;

  ChatResponse({
    required this.response,
    required this.status,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      response: json['response'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class PromptRequest {
  final String text;

  PromptRequest({required this.text});

  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }
}