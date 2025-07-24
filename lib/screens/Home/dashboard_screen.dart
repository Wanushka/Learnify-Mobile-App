import 'package:flutter/material.dart';
import 'package:learnifyapp/screens/Courses/course_detail_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/course_provider.dart';
import '../../widgets/course_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(() {
      setState(() {
        _isScrolled = _scrollController.offset > 10;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1976D2),
              Color(0xFF42A5F5),
              Color(0xFFE3F2FD),
              Color(0xFFF8FAFC),
            ],
            stops: [0.0, 0.2, 0.5, 0.8],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar with animated background
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _isScrolled 
                      ? Colors.white.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: _isScrolled 
                      ? const BorderRadius.vertical(bottom: Radius.circular(20))
                      : null,
                ),
                child: Column(
                  children: [
                    // Header with profile and notifications
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good Morning! 👋',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Text(
                              'Ready to Learn?',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Stack(
                                children: [
                                  const Icon(
                                    Icons.notifications_outlined,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 40,
                              height: 40,
                              child: const Icon(
                                Icons.account_circle_rounded,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Search Bar
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search courses, topics...',
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF1976D2), Color(0xFF2196F3)],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.tune, color: Colors.white),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Statistics Cards
              Container(
                height: 120,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Courses Enrolled',
                        '${courseProvider.enrolledCourses.length}',
                        Icons.school_rounded,
                        const Color(0xFF4CAF50),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        'Hours Learned',
                        '0h',
                        Icons.access_time,
                        const Color(0xFF1976D2),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        'Certificates',
                        '0',
                        Icons.emoji_events,
                        const Color(0xFFFF9800),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Tab Navigation
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelColor: const Color(0xFF1976D2),
                  unselectedLabelColor: Color(0xFF1976D2).withOpacity(0.7),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  tabAlignment: TabAlignment.fill,
                  isScrollable: false,
                  padding: const EdgeInsets.all(4),
                  tabs: const [
                    Tab(
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          'In Progress',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Tab(
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Completed',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Tab(
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Favorites',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildCourseList(courseProvider, 'in_progress'),
                    _buildCourseList(courseProvider, 'completed'),
                    _buildCourseList(courseProvider, 'favorites'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCourseList(CourseProvider courseProvider, String type) {
    // Filter courses based on type
    List<dynamic> courses = [];
    switch (type) {
      case 'in_progress':
        courses = courseProvider.enrolledCourses.where((course) => 
          course.progress < 100).toList();
        break;
      case 'completed':
        courses = courseProvider.enrolledCourses.where((course) => 
          course.progress >= 100).toList();
        break;
      case 'favorites':
        // Assuming there's a favorites property
        courses = courseProvider.enrolledCourses.where((course) => 
          course.isFavorite ?? false).toList();
        break;
    }

    if (courses.isEmpty) {
      return _buildEmptyState(type);
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                spreadRadius: 0,
                offset: const Offset(0, 5),
              ),
            ],
          ),
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
                  builder: (context) => CourseDetailScreen(course: course),
                ),
              );
            },
            onEnroll: () {
              // Add your onEnroll logic here
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String type) {
    String message;
    IconData icon;
    
    switch (type) {
      case 'in_progress':
        message = 'No courses in progress';
        icon = Icons.play_circle_outline;
        break;
      case 'completed':
        message = 'No completed courses yet';
        icon = Icons.check_circle_outline;
        break;
      case 'favorites':
        message = 'No favorite courses yet';
        icon = Icons.favorite_outline;
        break;
      default:
        message = 'No courses found';
        icon = Icons.library_books_outlined;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Color(0xFF03DAC6).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 64,
              color: Color(0xFF03DAC6).withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF03DAC6).withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Navigate to course catalog
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFF03DAC6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Explore Courses'),
          ),
        ],
      ),
    );
  }
}