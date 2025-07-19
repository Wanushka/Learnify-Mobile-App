import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';

class CourseCard extends StatelessWidget {
  final String id;
  final String title;
  final String instructor;
  final String imageUrl;
  final double progress;
  final VoidCallback onTap;
  final VoidCallback onEnroll;

  const CourseCard({
    Key? key,
    required this.id,
    required this.title,
    required this.instructor,
    required this.imageUrl,
    required this.progress,
    required this.onTap,
    required this.onEnroll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final isEnrolled = courseProvider.enrolledCourses.any((course) => course.id == id);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    instructor,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Progress: ${progress.toStringAsFixed(0)}%'),
                      ElevatedButton(
                        onPressed: isEnrolled ? null : onEnroll,
                        child: Text(isEnrolled ? 'Enrolled' : 'Enroll'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}