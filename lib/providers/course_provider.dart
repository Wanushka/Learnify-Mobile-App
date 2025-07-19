import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../services/course_service.dart';

class CourseProvider with ChangeNotifier {
  List<Course> _courses = [];
  List<Course> _enrolledCourses = [];
  bool _isLoading = false;

  List<Course> get courses => _courses;
  List<Course> get enrolledCourses => _enrolledCourses;
  bool get isLoading => _isLoading;

  Future<void> loadCourses() async {
    _isLoading = true;
    notifyListeners();

    try {
      _courses = await CourseService().getCourses();
    } catch (e) {
      print("Failed to load courses: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  void enrollInCourse(String courseId) {
    final courseIndex = _courses.indexWhere((c) => c.id == courseId);
    if (courseIndex != -1) {
      final course = _courses[courseIndex];
      if (!_enrolledCourses.contains(course)) {
        _enrolledCourses.add(course);
        notifyListeners();
      }
    }
  }

  void unenrollFromCourse(String courseId) {
    _enrolledCourses.removeWhere((course) => course.id == courseId);
    notifyListeners();
  }

  void updateLessonStatus(String courseId, String lessonTitle, bool completed) {
    final courseIndex = _enrolledCourses.indexWhere((c) => c.id == courseId);
    if (courseIndex != -1) {
      final course = _enrolledCourses[courseIndex];
      final lessonIndex = course.lessons.indexWhere((l) => l.title == lessonTitle);
      
      if (lessonIndex != -1) {
        course.lessons[lessonIndex].completed = completed;
        
        // Update course progress
        final completedLessons = course.lessons.where((l) => l.completed).length;
        final progress = (completedLessons / course.lessons.length * 100).round();
        
        _enrolledCourses[courseIndex] = Course(
          id: course.id,
          title: course.title,
          description: course.description,
          instructor: course.instructor,
          thumbnail: course.thumbnail,
          progress: progress,
          lessons: course.lessons,
        );
        
        notifyListeners();
      }
    }
  }
}