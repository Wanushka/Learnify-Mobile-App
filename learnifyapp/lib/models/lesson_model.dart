class Lesson {
  final String id;
  final String title;
  final String contentUrl;
  final bool isCompleted;

  Lesson({
    required this.id,
    required this.title,
    required this.contentUrl,
    this.isCompleted = false,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      contentUrl: json['contentUrl'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
