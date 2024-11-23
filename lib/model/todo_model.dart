// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TodoModel {
  int id;
  String name;
  bool completed;
  TodoModel({
    required this.id,
    required this.name,
    required this.completed,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'completed': completed,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] as int,
      name: map['name'] as String,
      completed: map['completed'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoModel.fromJson(String source) =>
      TodoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TodoModel(id: $id, name: $name, completed: $completed)';
}

class CreateTodoModel {
  String name;
  bool completed;
  CreateTodoModel({
    required this.name,
    required this.completed,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'completed': completed,
    };
  }

  factory CreateTodoModel.fromMap(Map<String, dynamic> map) {
    return CreateTodoModel(
      name: map['name'] as String,
      completed: map['completed'] as bool,
    );
  }

  String toJson() => json.encode(toMap());
}
