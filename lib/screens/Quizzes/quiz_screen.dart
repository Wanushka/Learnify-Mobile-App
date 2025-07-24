import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/quiz_provider.dart';
import '../../widgets/quiz_option_tile.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
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
            stops: [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom Header
              _buildCustomHeader(),

              // Quiz Content
              Expanded(
                child: FadeTransition(
                  opacity: _fadeInAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Consumer<QuizProvider>(
                      builder: (context, quizProvider, child) {
                        if (quizProvider.isLoading) {
                          return _buildLoadingState();
                        }

                        if (quizProvider.quizSections.isEmpty) {
                          return _buildEmptyState();
                        }

                        return _buildQuizContent(quizProvider);
                      },
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
                    'Quiz Arena',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Test your knowledge 🚀',
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
                  icon: Icon(Icons.leaderboard_outlined,
                      color: Colors.white, size: 24),
                  onPressed: () => _showComingSoon('Leaderboard'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 25,
              spreadRadius: 0,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1976D2), Color(0xFF2196F3)],
                ),
                shape: BoxShape.circle,
              ),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Loading Quizzes...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Preparing your learning experience',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              spreadRadius: 0,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1976D2), Color(0xFF2196F3)],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.quiz_rounded, size: 48, color: Colors.white),
            ),
            SizedBox(height: 24),
            Text(
              'No Quizzes Available',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Check back later for new quiz challenges',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            SizedBox(height: 32),
            Container(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_rounded,
                    color: Colors.white, size: 20),
                label: Text(
                  'Go Back',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1976D2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizContent(QuizProvider quizProvider) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
      physics: BouncingScrollPhysics(),
      itemCount: quizProvider.quizSections.length,
      itemBuilder: (context, index) {
        final section = quizProvider.quizSections[index];
        return FadeTransition(
          opacity: _fadeInAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: _buildQuizSection(section, quizProvider, index),
          ),
        );
      },
    );
  }

  Widget _buildQuizSection(
      dynamic section, QuizProvider quizProvider, int index) {
    final score = quizProvider.getQuizScore(section.id);
    final totalQuestions = section.questions.length;
    final progress = totalQuestions > 0 ? score / totalQuestions : 0.0;

    return Container(
      margin: EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 0,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          _buildSectionHeader(section, progress, totalQuestions, score),

          // Quiz Questions
          ...section.questions.asMap().entries.map((entry) {
            int questionIndex = entry.key;
            var quiz = entry.value;
            return _buildQuizQuestion(
                quiz, section, quizProvider, questionIndex);
          }).toList(),

          // Section Footer
          _buildSectionFooter(section, quizProvider, score, totalQuestions),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      dynamic section, double progress, int totalQuestions, int score) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1976D2), Color(0xFF2196F3)],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      section.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer_outlined, size: 18, color: Colors.white),
                    SizedBox(width: 6),
                    Text(
                      '${section.duration} mins',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '$score/$totalQuestions',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  widthFactor: progress,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.white.withOpacity(0.8)],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuizQuestion(dynamic quiz, dynamic section,
      QuizProvider quizProvider, int questionIndex) {
    final isAnswered = quizProvider.isAnswerSelected(section.id, quiz.id);

    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1976D2), Color(0xFF2196F3)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Q${questionIndex + 1}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  quiz.question,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                    height: 1.4,
                  ),
                ),
              ),
              if (isAnswered)
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFF4CAF50),
                    size: 20,
                  ),
                ),
            ],
          ),

          SizedBox(height: 20),

          // Options
          ...quiz.options.map((option) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: _buildModernQuizOption(
                option: option.id,
                text: option.text,
                isSelected:
                    quizProvider.getSelectedAnswer(section.id, quiz.id) ==
                        option.id,
                isCorrect: quiz.correctAnswer == option.id,
                showResult: isAnswered,
                onTap: () =>
                    quizProvider.submitAnswer(section.id, quiz.id, option.id),
              ),
            );
          }).toList(),

          // Explanation
          if (isAnswered && quiz.explanation.isNotEmpty)
            Container(
              margin: EdgeInsets.only(top: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF1976D2).withOpacity(0.05),
                    Color(0xFF2196F3).withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Color(0xFF1976D2).withOpacity(0.1),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Color(0xFF1976D2).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.lightbulb_outline,
                      color: Color(0xFF1976D2),
                      size: 16,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      quiz.explanation,
                      style: TextStyle(
                        color: Color(0xFF1976D2),
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          if (questionIndex < section.questions.length - 1)
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 1,
              color: Colors.grey[100],
            ),
        ],
      ),
    );
  }

  Widget _buildModernQuizOption({
    required String option,
    required String text,
    required bool isSelected,
    required bool isCorrect,
    required bool showResult,
    required VoidCallback onTap,
  }) {
    Color backgroundColor = Colors.white;
    Color borderColor = Colors.grey[300]!;
    Color textColor = Color(0xFF1A1A1A);
    IconData? icon;
    Color? iconColor;

    if (showResult) {
      if (isCorrect) {
        backgroundColor = Color(0xFF4CAF50).withOpacity(0.1);
        borderColor = Color(0xFF4CAF50);
        icon = Icons.check_circle;
        iconColor = Color(0xFF4CAF50);
      } else if (isSelected) {
        backgroundColor = Color(0xFFE53E3E).withOpacity(0.1);
        borderColor = Color(0xFFE53E3E);
        icon = Icons.cancel;
        iconColor = Color(0xFFE53E3E);
      }
    } else if (isSelected) {
      backgroundColor = Color(0xFF1976D2).withOpacity(0.1);
      borderColor = Color(0xFF1976D2);
      textColor = Color(0xFF1976D2);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: showResult ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: 1.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected && !showResult
                      ? Color(0xFF1976D2)
                      : Colors.transparent,
                  border: Border.all(
                    color: borderColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    option,
                    style: TextStyle(
                      color: isSelected && !showResult
                          ? Colors.white
                          : borderColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
              if (icon != null)
                Container(
                  padding: EdgeInsets.all(4),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionFooter(dynamic section, QuizProvider quizProvider,
      int score, int totalQuestions) {
    final percentage =
        totalQuestions > 0 ? (score / totalQuestions * 100).round() : 0;

    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF1976D2).withOpacity(0.1),
                    Color(0xFF2196F3).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFF1976D2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        Icon(Icons.emoji_events, color: Colors.white, size: 16),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Score',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '$score/$totalQuestions ($percentage%)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: IconButton(
              onPressed: () => _showResetDialog(section, quizProvider),
              icon: Icon(Icons.refresh_rounded, color: Color(0xFF1976D2)),
              tooltip: 'Reset Quiz',
            ),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(dynamic section, QuizProvider quizProvider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 30,
                  spreadRadius: 0,
                  offset: Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFF1976D2).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.refresh_rounded,
                      color: Color(0xFF1976D2), size: 32),
                ),
                SizedBox(height: 24),
                Text(
                  'Reset Quiz?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'This will clear all your answers and reset your progress for this quiz section.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey[300]!),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            quizProvider.resetQuiz(section.id);
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF1976D2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            'Reset',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
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
