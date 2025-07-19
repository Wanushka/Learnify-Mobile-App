import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/course_model.dart';

class CourseService {
  Future<List<Course>> getCourses() async {
    try {
      final String response = await rootBundle.loadString('assets/data/courses.json');
      final List<dynamic> data = json.decode(response);
      return data.map((json) => Course.fromJson(json)).toList();
    } catch (e) {
      print("Error loading courses: $e");
      return [];
    }
  }
}