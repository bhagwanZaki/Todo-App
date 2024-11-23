import 'package:flutter/material.dart';
import 'package:todo/model/todo_model.dart';

class TodoProvider extends ChangeNotifier {
  List<TodoModel> todoList;
  TodoProvider({this.todoList = const []});

  void clear() {
    todoList = [];
  }

  void initList(List<TodoModel> list) {
    todoList = list;
    notifyListeners();
  }

  void addTodo(TodoModel todo) {
    todoList = [todo, ...todoList];
    notifyListeners();
  }

  void updateTodo(TodoModel todo) {
    final index = todoList.indexWhere((element) => element.id == todo.id);

    if (index != -1) {
      todoList[index] = todo;
      notifyListeners();
    }
  }

  void deleteTodo(int id) {
    todoList.removeWhere(
      (element) => element.id == id,
    );
    notifyListeners();
  }
}
