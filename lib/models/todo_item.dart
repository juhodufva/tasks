class TodoItem {
  int id = -1;
  String title = "";
  String description = "";
  DateTime date = DateTime.now();
  bool done = false;

  TodoItem(
      {this.id = -1,
      required this.title,
      this.description = "",
      required this.date,
      this.done = false});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'done': done ? 1 : 0,
    };
  }
}
