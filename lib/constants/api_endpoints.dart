// constants/api_endpoints.dart

class ApiEndpoints {
  // Change this to your FastAPI server URL
  static const String baseUrl = 'http://10.0.2.2:8000'; // For Android emulator
  // static const String baseUrl = 'http://localhost:8000'; // For iOS simulator
  // static const String baseUrl = 'http://YOUR_IP_ADDRESS:8000'; // For physical device

  // Endpoints
  static const String generateQuestions = '/generate-questions';
  static const String chatbot = '/chatbot';
  static const String root = '/';

  // Full URLs
  static String get generateQuestionsUrl => '$baseUrl$generateQuestions';
  static String get chatbotUrl => '$baseUrl$chatbot';
  static String get rootUrl => '$baseUrl$root';
}