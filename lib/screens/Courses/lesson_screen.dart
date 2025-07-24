import 'package:flutter/material.dart';
import 'package:learnifyapp/providers/course_provider.dart';
import 'package:provider/provider.dart';
import '../../models/course_model.dart';
import '../../widgets/video_player_widget.dart';
import '../../widgets/pdf_viewer_widget.dart';

class LessonListScreen extends StatefulWidget {
  final Course course;

  const LessonListScreen({required this.course});

  @override
  _LessonListScreenState createState() => _LessonListScreenState();
}

class _LessonListScreenState extends State<LessonListScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildModernProgressIndicator(BuildContext context) {
    int completedLessons = widget.course.lessons.where((lesson) => lesson.completed).length;
    double progress = completedLessons / widget.course.lessons.length;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.95),
            Colors.white.withOpacity(0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 0,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Course Progress',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$completedLessons of ${widget.course.lessons.length} lessons completed',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1976D2), Color(0xFF2196F3)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16),
          
          // Modern Progress Bar with Animation
          Container(
            width: double.infinity,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 1000),
                  curve: Curves.easeOutCubic,
                  width: MediaQuery.of(context).size.width * 0.8 * progress,
                  height: 10,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                    ),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF1976D2).withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1976D2),
              Color(0xFF42A5F5).withOpacity(0.8),
              Color(0xFFE3F2FD).withOpacity(0.4),
              Color(0xFFF8FAFC),
            ],
            stops: [0.0, 0.25, 0.5, 0.8],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Modern Header
              _buildModernHeader(),
              
              // Progress Card
              FadeTransition(
                opacity: _fadeInAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildModernProgressIndicator(context),
                ),
              ),
              
              // Lessons List
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: FadeTransition(
                    opacity: _fadeInAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _buildLessonsList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        children: [
          // Top Navigation
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Course Lessons',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(Icons.more_vert_rounded, color: Colors.white, size: 20),
                  onPressed: () => _showCourseOptions(),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 20),
          
          // Course Title with Icon
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCourseIcon(widget.course.title),
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.course.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'by ${widget.course.instructor}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLessonsList() {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(20, 24, 20, 20),
      physics: BouncingScrollPhysics(),
      itemCount: widget.course.lessons.length + 1, // +1 for header
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildLessonsHeader();
        }
        
        final lesson = widget.course.lessons[index - 1];
        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + (index * 100)),
          curve: Curves.easeOutCubic,
          child: _buildModernLessonCard(lesson, index - 1),
        );
      },
    );
  }

  Widget _buildLessonsHeader() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Icon(
            Icons.play_lesson_rounded,
            color: Color(0xFF1976D2),
            size: 24,
          ),
          SizedBox(width: 12),
          Text(
            'Lessons (${widget.course.lessons.length})',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFF1976D2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'All Levels',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF1976D2),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernLessonCard(Lesson lesson, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            spreadRadius: 0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _navigateToLesson(lesson),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                // Lesson Number & Type Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: lesson.completed
                        ? LinearGradient(colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)])
                        : LinearGradient(colors: [Color(0xFF1976D2), Color(0xFF42A5F5)]),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: (lesson.completed ? Color(0xFF4CAF50) : Color(0xFF1976D2))
                            .withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          lesson.type == 'video' 
                              ? Icons.play_arrow_rounded
                              : Icons.picture_as_pdf_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      if (lesson.completed)
                        Positioned(
                          top: 2,
                          right: 2,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              color: Color(0xFF4CAF50),
                              size: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                
                SizedBox(width: 16),
                
                // Lesson Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: lesson.type == 'video' 
                                  ? Color(0xFFE3F2FD)
                                  : Color(0xFFFFF3E0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Lesson ${index + 1}',
                              style: TextStyle(
                                fontSize: 11,
                                color: lesson.type == 'video' 
                                    ? Color(0xFF1976D2)
                                    : Color(0xFFFF9800),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: lesson.type == 'video' 
                                  ? Color(0xFFE8F5E8)
                                  : Color(0xFFFFF3E0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  lesson.type == 'video' 
                                      ? Icons.videocam_outlined
                                      : Icons.description_outlined,
                                  size: 12,
                                  color: lesson.type == 'video' 
                                      ? Color(0xFF4CAF50)
                                      : Color(0xFFFF9800),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  lesson.type == 'video' ? 'Video' : 'PDF',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: lesson.type == 'video' 
                                        ? Color(0xFF4CAF50)
                                        : Color(0xFFFF9800),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 8),
                      
                      Text(
                        lesson.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      
                      SizedBox(height: 4),
                      
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          SizedBox(width: 4),
                          Text(
                            lesson.type == 'video' ? '12 minutes' : 'Reading material',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (lesson.completed) ...[
                            SizedBox(width: 12),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Color(0xFF4CAF50).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Completed',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF4CAF50),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Action Button
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: lesson.completed 
                        ? Color(0xFF4CAF50).withOpacity(0.1)
                        : Color(0xFF1976D2).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    lesson.completed 
                        ? Icons.replay_rounded
                        : Icons.play_arrow_rounded,
                    color: lesson.completed 
                        ? Color(0xFF4CAF50)
                        : Color(0xFF1976D2),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToLesson(Lesson lesson) {
    if (lesson.type == 'video') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CustomVideoPlayer(
            videoUrl: lesson.url,
          ),
        ),
      ).then((_) {
        // Mark lesson as completed when returning
        if (!lesson.completed) {
          Provider.of<CourseProvider>(context, listen: false)
              .updateLessonStatus(widget.course.id, lesson.title, true);
        }
      });
    } else if (lesson.type == 'pdf') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerWidget(
            pdfUrl: lesson.url,
          ),
        ),
      ).then((_) {
        // Mark lesson as completed when returning
        if (!lesson.completed) {
          Provider.of<CourseProvider>(context, listen: false)
              .updateLessonStatus(widget.course.id, lesson.title, true);
        }
      });
    }
  }

  IconData _getCourseIcon(String courseTitle) {
    final title = courseTitle.toLowerCase();
    if (title.contains('flutter')) return Icons.flutter_dash_rounded;
    if (title.contains('dart')) return Icons.code_rounded;
    if (title.contains('firebase')) return Icons.cloud_rounded;
    if (title.contains('state')) return Icons.settings_rounded;
    if (title.contains('ui') || title.contains('design')) return Icons.palette_rounded;
    return Icons.school_rounded;
  }

  void _showCourseOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Course Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            SizedBox(height: 20),
            _buildOptionItem(Icons.bookmark_outline, 'Save Course', () {}),
            _buildOptionItem(Icons.share_outlined, 'Share Course', () {}),
            _buildOptionItem(Icons.download_outlined, 'Download for Offline', () {}),
            _buildOptionItem(Icons.report_outlined, 'Report Issue', () {}),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFF1976D2).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Color(0xFF1976D2), size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1A1A),
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
      onTap: () {
        Navigator.pop(context);
        _showComingSoon(title);
      },
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.construction, color: Colors.white, size: 16),
            ),
            SizedBox(width: 12),
            Text(
              '$feature coming soon!',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: Color(0xFF03DAC6),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 3),
      ),
    );
  }
}