import 'dart:io';

class TodoItem {
  int id = -1;
  String title = "";
  String description = "";
  DateTime date = DateTime.now();
  final bool done;
  File? image;

  TodoItem({
    this.id = -1,
    required this.title,
    this.description = "",
    required this.date,
    this.done = false,
    this.image,
  });

  void setImage(File image) {
    this.image = image;
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'done': done ? 1 : 0,
    };
  }
}
