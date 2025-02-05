import 'package:flutter/material.dart';
import 'package:learnifyapp/screens/course_detail_screen.dart';
import '../models/course_model.dart';
import '../services/course_service.dart';
import '../widgets/course_card.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({Key? key}) : super(key: key);

  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  late Future<List<Course>> _courses;

  @override
  void initState() {
    super.initState();
    _courses = CourseService().getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
        title: Text(
          "Courses",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: const Color(0xFFFFFFFF),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2196F3),
              Color(0xFF1976D2),
            ],
          ),
        ),
        child: FutureBuilder<List<Course>>(
          future: _courses,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            }
            
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 64,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Error loading courses",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            final courses = snapshot.data!;
            return courses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.school_rounded,
                          size: 64,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No courses available",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CourseCard(
                          id: course.id,
                          title: course.title,
                          instructor: course.instructor,
                          imageUrl: course.thumbnail,
                          progress: course.progress.toDouble(),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CourseDetailScreen(course: course),
                              ),
                            );
                          },
                          onEnroll: () {
                            final courseProvider = Provider.of<CourseProvider>(context, listen: false);
                            courseProvider.enrollInCourse(course.id);
                            print('Enrolled in course: ${course.title}');
                          },
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}