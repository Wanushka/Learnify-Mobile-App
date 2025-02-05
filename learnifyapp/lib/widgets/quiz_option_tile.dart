import 'package:flutter/material.dart';

class QuizOption extends StatelessWidget {
  final String option;
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool showResult;
  final VoidCallback onTap;

  const QuizOption({
    Key? key,
    required this.option,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    this.showResult = false,
    required this.onTap,
  }) : super(key: key);

  Color _getBackgroundColor() {
    if (!showResult) return isSelected ? Colors.blue.withOpacity(0.2) : Colors.white;
    if (isCorrect) return Colors.green.withOpacity(0.2);
    return isSelected ? Colors.red.withOpacity(0.2) : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showResult ? null : onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey.shade400,
                ),
              ),
              child: Text(
                option,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
            if (showResult)
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.green : Colors.red,
              ),
          ],
        ),
      ),
    );
  }
}