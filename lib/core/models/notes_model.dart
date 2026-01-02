class NotesModel {
  final String content;

  NotesModel({required this.content});

  factory NotesModel.fromJson(Map<String, dynamic> json) {
    return NotesModel(content: json['content'] as String);
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {'content': content};
  }

  // Optional: toString method for debugging
  @override
  String toString() {
    return 'NotesModel(content: $content)';
  }

  // Optional: copyWith method for creating modified copies
  NotesModel copyWith({String? content}) {
    return NotesModel(content: content ?? this.content);
  }
}
