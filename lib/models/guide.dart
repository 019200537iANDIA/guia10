class Guide {
  String? id; // Ahora String para Firestore
  String title;
  String content;
  String imagePath;

  Guide({
    this.id,
    required this.title,
    required this.content,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'imagePath': imagePath,
    };
  }

  factory Guide.fromMap(Map<String, dynamic> map, String id) {
    return Guide(
      id: id,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      imagePath: map['imagePath'] ?? '',
    );
  }
}