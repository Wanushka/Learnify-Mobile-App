// services/api_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/api_models.dart';
import '../constants/api_endpoints.dart';

class ApiService {
  static const Duration _timeout = Duration(seconds: 30);

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // Generate MCQ Questions
  static Future<MCQResponse> generateQuestions(String text) async {
    try {
      final promptRequest = PromptRequest(text: text);
      
      final response = await http
          .post(
            Uri.parse(ApiEndpoints.generateQuestionsUrl),
            headers: _headers,
            body: json.encode(promptRequest.toJson()),
          )
          .timeout(_timeout);

      print('MCQ Request: ${json.encode(promptRequest.toJson())}');
      print('MCQ Response Status: ${response.statusCode}');
      print('MCQ Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return MCQResponse.fromJson(jsonResponse);
      } else {
        throw ApiException(
          'Failed to generate questions: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on SocketException {
      throw ApiException('No internet connection', 0);
    } on HttpException {
      throw ApiException('HTTP error occurred', 0);
    } on FormatException {
      throw ApiException('Invalid response format', 0);
    } catch (e) {
      throw ApiException('Error generating questions: $e', 0);
    }
  }

  // Chatbot
  static Future<ChatResponse> sendChatMessage(String message) async {
    try {
      final chatMessage = ChatMessage(message: message);
      
      final response = await http
          .post(
            Uri.parse(ApiEndpoints.chatbotUrl),
            headers: _headers,
            body: json.encode(chatMessage.toJson()),
          )
          .timeout(_timeout);

      print('Chat Request: ${json.encode(chatMessage.toJson())}');
      print('Chat Response Status: ${response.statusCode}');
      print('Chat Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return ChatResponse.fromJson(jsonResponse);
      } else {
        throw ApiException(
          'Failed to send message: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on SocketException {
      throw ApiException('No internet connection', 0);
    } on HttpException {
      throw ApiException('HTTP error occurred', 0);
    } on FormatException {
      throw ApiException('Invalid response format', 0);
    } catch (e) {
      throw ApiException('Error sending message: $e', 0);
    }
  }

  // Test connection
  static Future<bool> testConnection() async {
    try {
      final response = await http
          .get(
            Uri.parse(ApiEndpoints.rootUrl),
            headers: _headers,
          )
          .timeout(_timeout);

      return response.statusCode == 200;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }
}

// Custom exception class
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}