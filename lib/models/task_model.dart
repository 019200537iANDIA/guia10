class Task {
  final String? id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final String userId;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.createdAt,
    required this.userId,
  });

  // Validaciones
  bool isValid() {
    return title.isNotEmpty && 
           description.isNotEmpty && 
           userId.isNotEmpty;
  }

  bool isTitleValid() {
    return title.trim().length >= 3 && title.trim().length <= 50;
  }

  bool isDescriptionValid() {
    return description.trim().length >= 5 && description.trim().length <= 200;
  }

  // Conversión a/desde Firebase
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'userId': userId,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      userId: map['userId'] ?? '',
    );
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    String? userId,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
    );
  }
}