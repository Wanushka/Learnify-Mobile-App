import 'package:flutter/material.dart';
import 'package:learnifyapp/screens/Courses/course_detail_screen.dart';
import '../../models/course_model.dart';
import '../../services/course_service.dart';
import '../../widgets/course_card.dart';
import 'package:provider/provider.dart';
import '../../providers/course_provider.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({Key? key}) : super(key: key);

  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> with TickerProviderStateMixin {
  late Future<List<Course>> _courses;
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = ['All', 'Programming', 'Design', 'Business', 'Marketing'];

  @override
  void initState() {
    super.initState();
    _courses = CourseService().getCourses();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
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
            stops: [0.0, 0.2, 0.5, 0.8],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom Header
              _buildCustomHeader(),
              
              // Search and Filter Section
              _buildSearchAndFilter(),
              
              // Courses Content
              Expanded(
                child: FadeTransition(
                  opacity: _fadeInAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildCoursesContent(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomHeader() {
    return Container(
      height: 120,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          // Top bar with title and notification icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Discover',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Learn something new today 🚀',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(Icons.notifications_outlined, color: Colors.white, size: 24),
                  onPressed: () => _showComingSoon('Notifications'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        children: [
          // Search Bar
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search courses...',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: Container(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.search_rounded, color: Color(0xFF1976D2), size: 24),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear_rounded, color: Colors.grey[400]),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : Container(
                        padding: EdgeInsets.all(12),
                        child: Icon(Icons.tune_rounded, color: Color(0xFF1976D2), size: 24),
                      ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
          ),
          
          SizedBox(height: 16),
          
          // Category Filter
          Container(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                
                return Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Color(0xFF1976D2) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: Color(0xFF1976D2).withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(0, 6),
                          ),
                        ] : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Color(0xFF1976D2),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesContent() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: FutureBuilder<List<Course>>(
        future: _courses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }
          
          if (snapshot.hasError) {
            return _buildErrorState();
          }

          final courses = snapshot.data!;
          final filteredCourses = _filterCourses(courses);
          
          if (filteredCourses.isEmpty) {
            return _buildEmptyState();
          }

          return _buildCoursesList(filteredCourses);
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF1976D2).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)),
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 24),
          Text(
            "Loading amazing courses...",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "This won't take long",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFFE53E3E).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Color(0xFFE53E3E),
            ),
          ),
          SizedBox(height: 24),
          Text(
            "Oops! Something went wrong",
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF1A1A1A),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "We couldn't load the courses. Please try again.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _courses = CourseService().getCourses();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1976D2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Try Again',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF03DAC6).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 48,
              color: Color(0xFF03DAC6),
            ),
          ),
          SizedBox(height: 24),
          Text(
            _searchQuery.isNotEmpty ? "No courses found" : "No courses available",
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF1A1A1A),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty 
                ? "Try adjusting your search or filters"
                : "Check back later for new courses",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          if (_searchQuery.isNotEmpty) ...[
            SizedBox(height: 24),
            TextButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _selectedCategory = 'All';
                });
              },
              child: Text(
                'Clear filters',
                style: TextStyle(
                  color: Color(0xFF1976D2),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCoursesList(List<Course> courses) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, 20),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 16,
              childAspectRatio: 2.8,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final course = courses[index];
                return _buildModernCourseCard(course, index);
              },
              childCount: courses.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernCourseCard(Course course, int index) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseDetailScreen(course: course),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      spreadRadius: 0,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Course Image
                    Container(
                      width: 120,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF1976D2).withOpacity(0.8),
                            Color(0xFF2196F3).withOpacity(0.6),
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
                            child: Image.asset(
                              course.thumbnail,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Play button overlay
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.play_arrow_rounded,
                                color: Color(0xFF1976D2),
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Course Info
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title and instructor
                            Text(
                              course.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A1A),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.person_outline, size: 14, color: Colors.grey[600]),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    course.instructor,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            
                            Spacer(),
                            
                            // Progress and enroll button
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Progress',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Container(
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                        child: FractionallySizedBox(
                                          alignment: Alignment.centerLeft,
                                          widthFactor: course.progress / 100,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [Color(0xFF1976D2), Color(0xFF2196F3)],
                                              ),
                                              borderRadius: BorderRadius.circular(3),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 12),
                                Consumer<CourseProvider>(
                                  builder: (context, courseProvider, child) {
                                    final isEnrolled = courseProvider.enrolledCourses.any((c) => c.id == course.id);
                                    return Container(
                                      height: 32,
                                      child: ElevatedButton(
                                        onPressed: isEnrolled ? null : () {
                                          courseProvider.enrollInCourse(course.id);
                                          _showEnrollmentSuccess(course.title);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isEnrolled ? Colors.grey[300] : Color(0xFF1976D2),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          padding: EdgeInsets.symmetric(horizontal: 12),
                                          elevation: 0,
                                        ),
                                        child: Text(
                                          isEnrolled ? 'Enrolled' : 'Enroll',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: isEnrolled ? Colors.grey[600] : Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Course> _filterCourses(List<Course> courses) {
    List<Course> filtered = courses;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((course) =>
          course.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          course.instructor.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    if (_selectedCategory != 'All') {
      // Add category filtering logic here when course model includes category
      // filtered = filtered.where((course) => course.category == _selectedCategory).toList();
    }

    return filtered;
  }

  void _showEnrollmentSuccess(String courseTitle) {
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
              child: Icon(Icons.check_circle, color: Colors.white, size: 16),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Successfully enrolled in $courseTitle!',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 3),
      ),
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