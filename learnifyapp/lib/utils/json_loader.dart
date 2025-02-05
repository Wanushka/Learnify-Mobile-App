import 'dart:convert';
import 'package:flutter/services.dart';

class JsonLoader {
  static Future<Map<String, dynamic>> loadJson(String path) async {
    try {
      final String response = await rootBundle.loadString(path);
      return await json.decode(response);
    } catch (e) {
      throw Exception('Failed to load json file: $path');
    }
  }

  static Future<List<dynamic>> loadJsonList(String path) async {
    try {
      final String response = await rootBundle.loadString(path);
      return await json.decode(response);
    } catch (e) {
      throw Exception('Failed to load json file: $path');
    }
  }

  static Future<T> loadAndParseJson<T>(
    String path,
    T Function(Map<String, dynamic> json) parser,
  ) async {
    final Map<String, dynamic> json = await loadJson(path);
    return parser(json);
  }

  static Future<List<T>> loadAndParseJsonList<T>(
    String path,
    T Function(Map<String, dynamic> json) parser,
  ) async {
    final List<dynamic> jsonList = await loadJsonList(path);
    return jsonList.map((item) => parser(item as Map<String, dynamic>)).toList();
  }
}