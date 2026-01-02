class CreateNotesModel {
  final String content;
  final List<String> visibility = ["admin", "representative", "trader"];

  CreateNotesModel({required this.content});

  factory CreateNotesModel.fromJson(Map<String, dynamic> json) {
    return CreateNotesModel(content: json['content'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'content': content, 'visibility': visibility};
  }

  // Optional: toString method for debugging
  @override
  String toString() {
    return 'CreateNotesModel(content: $content, visibility: $visibility)';
  }

  // Optional: copyWith method for creating modified copies
  CreateNotesModel copyWith({String? content, List<String>? visibility}) {
    return CreateNotesModel(content: content ?? this.content);
  }
}
