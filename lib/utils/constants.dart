import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('My Enrolled Courses', style: TextStyle(fontSize: 20)),
            Expanded(
              child: ListView.builder(
                itemCount: courseProvider.courses.length,
                itemBuilder: (context, index) {
                  final course = courseProvider.courses[index];
                  return ListTile(
                    title: Text(course.title),
                    subtitle: Text('Progress: ${course.progress}%'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
