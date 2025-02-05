import 'package:flutter/material.dart';
import 'package:learnifyapp/providers/course_provider.dart';
import 'package:provider/provider.dart';
import '../models/course_model.dart';
import '../widgets/video_player_widget.dart';
import '../widgets/pdf_viewer_widget.dart';

class LessonListScreen extends StatelessWidget {
  final Course course;

  const LessonListScreen({required this.course});

  Widget _buildProgressIndicator(BuildContext context) {
    int completedLessons = course.lessons.where((lesson) => lesson.completed).length;
    double progress = completedLessons / course.lessons.length;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Course Progress',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white.withOpacity(0.3),
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2196F3),
              Color(0xFF1976D2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                          course.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    _buildProgressIndicator(context),
                  ],
                ),
              ),
              
              // Lessons List
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: course.lessons.length,
                    itemBuilder: (context, index) {
                      final lesson = course.lessons[index];
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            if (lesson.type == 'video') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CustomVideoPlayer(
                                    videoUrl: lesson.url,
                                  ),
                                ),
                              );
                            } else if (lesson.type == 'pdf') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PDFViewerWidget(
                                    pdfUrl: lesson.url,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // Lesson Type Icon
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF1976D2).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    lesson.type == 'video' 
                                        ? Icons.play_circle_outline
                                        : Icons.picture_as_pdf,
                                    color: Color(0xFF1976D2),
                                    size: 24,
                                  ),
                                ),
                                SizedBox(width: 16),
                                // Lesson Title and Duration
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        lesson.title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        lesson.type == 'video' ? '10 minutes' : 'PDF Document',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Completion Checkbox
                                Transform.scale(
                                  scale: 1.2,
                                  child: Checkbox(
                                    value: lesson.completed,
                                    onChanged: (bool? value) {
                                      if (value != null) {
                                        Provider.of<CourseProvider>(context, listen: false)
                                            .updateLessonStatus(course.id, lesson.title, value);
                                      }
                                    },
                                    activeColor: Color(0xFF1976D2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}