const String todoTable = 'todo';

class TodoFields {
  static const String username = 'username';
  static const String title = 'title';
  static const String done = 'done';
  static const String created = 'created';
  static final List<String> allFields = [username, title, done, created];
}

class Todo {
  final String username;
  final String title;
  bool done;
  final DateTime created;

  Todo({
    required this.username,
    required this.title,
    this.done = false,
    required this.created,
  });

  Map<String, Object?> toJson() => {
        TodoFields.username: username,
        TodoFields.title: title,
        TodoFields.done: done ? 1 : 0,
        TodoFields.created: created.toIso8601String(),
      };

  static Todo fromJson(Map<String, Object?> json) => Todo(
        username: json[TodoFields.username] as String,
        title: json[TodoFields.title] as String,
        done: json[TodoFields.done] == 1,
        created: DateTime.parse(json[TodoFields.created] as String),
      );

  @override
  bool operator ==(covariant Todo other) {
    return (username == other.username) &&
        (title.toUpperCase().compareTo(other.title.toUpperCase()) == 0);
  }

  @override
  int get hashCode => Object.hash(username, title);
}
