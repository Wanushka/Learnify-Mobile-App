class Course {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final String thumbnail;
  final int progress;
  final List<Lesson> lessons;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.thumbnail,
    required this.progress,
    required this.lessons,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    var lessonsFromJson = json['lessons'] as List;
    List<Lesson> lessonList =
        lessonsFromJson.map((lesson) => Lesson.fromJson(lesson)).toList();

    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      instructor: json['instructor'],
      thumbnail: json['thumbnail'],
      progress: json['progress'],
      lessons: lessonList,
    );
  }
}

class Lesson {
  final String title;
  final String type;
  final String url;
  bool completed;

  Lesson({
    required this.title,
    required this.type,
    required this.url,
    this.completed = false,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      title: json['title'],
      type: json['type'],
      url: json['url'],
      completed: json['completed'],
    );
  }
}
