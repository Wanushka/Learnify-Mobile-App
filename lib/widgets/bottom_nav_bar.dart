import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 16, 
        right: 16, 
        bottom: MediaQuery.of(context).padding.bottom > 0 ? 8 : 16
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1976D2).withOpacity(0.95),
            Color(0xFF1565C0).withOpacity(0.95),
            Color(0xFF0D47A1).withOpacity(0.95),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1976D2).withOpacity(0.25),
            blurRadius: 15,
            spreadRadius: 0,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            spreadRadius: 0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background particles
          ...List.generate(6, (index) => _buildParticle(index)),
          
          // Navigation items
          Container(
            height: 65,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
                _buildNavItem(1, Icons.book_outlined, Icons.book, 'Courses'),
                _buildNavItem(2, Icons.quiz_outlined, Icons.quiz, 'Quizzes'),
                _buildNavItem(3, Icons.person_outline, Icons.person, 'Profile'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = widget.selectedIndex == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onItemTapped(index),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(horizontal: 2),
          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 4),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.25),
                      Colors.white.withOpacity(0.1),
                    ],
                  )
                : null,
            borderRadius: BorderRadius.circular(16),
            border: isSelected
                ? Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  )
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 6,
                      spreadRadius: 0,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with animation
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: isSelected ? _scaleAnimation.value : 1.0,
                    child: Container(
                      padding: EdgeInsets.all(3),
                      decoration: isSelected
                          ? BoxDecoration(
                              color: Color(0xFF03DAC6).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Color(0xFF03DAC6).withOpacity(0.4),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF03DAC6).withOpacity(0.3),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                ),
                              ],
                            )
                          : null,
                      child: Icon(
                        isSelected ? activeIcon : icon,
                        color: isSelected 
                            ? Color(0xFF03DAC6) 
                            : Colors.white.withOpacity(0.7),
                        size: 18,
                      ),
                    ),
                  );
                },
              ),
              
              SizedBox(height: 1),
              
              // Label with slide animation
              AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, isSelected ? 0 : 1),
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 200),
                      opacity: isSelected ? 1.0 : 0.7,
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: isSelected ? 9 : 8,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected 
                              ? Colors.white 
                              : Colors.white.withOpacity(0.7),
                          letterSpacing: 0.2,
                          shadows: isSelected
                              ? [
                                  Shadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 2,
                                    color: Colors.black.withOpacity(0.2),
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParticle(int index) {
    final positions = [
      Offset(0.15, 0.3),
      Offset(0.85, 0.2),
      Offset(0.3, 0.7),
      Offset(0.7, 0.8),
      Offset(0.5, 0.1),
      Offset(0.9, 0.6),
    ];
    
    final sizes = [3.0, 4.0, 2.0, 3.5, 2.5, 4.5];
    final colors = [
      Color(0xFF64B5F6).withOpacity(0.15),
      Color(0xFF42A5F5).withOpacity(0.1),
      Color(0xFF90CAF9).withOpacity(0.08),
      Color(0xFF03DAC6).withOpacity(0.12),
      Color(0xFF1E88E5).withOpacity(0.1),
      Color(0xFF2196F3).withOpacity(0.15),
    ];

    return Positioned(
      left: MediaQuery.of(context).size.width * positions[index].dx - 35,
      top: 65 * positions[index].dy,
      child: Container(
        width: sizes[index],
        height: sizes[index],
        decoration: BoxDecoration(
          color: colors[index],
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: colors[index],
              blurRadius: 2,
              spreadRadius: 0.5,
            ),
          ],
        ),
      ),
    );
  }
}