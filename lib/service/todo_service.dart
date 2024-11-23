import 'package:http/http.dart' as http;

import 'package:todo/constant/api_routes.dart';
import 'package:todo/model/todo_model.dart';
import 'package:todo/provier/todo_provider.dart';

import 'package:todo/utils/api_exception.dart';
import 'package:todo/utils/preferences.dart';

class TodoService {
  Preferences prefs = Preferences();

  Future<dynamic> getHeader() async {
    String? token = await prefs.getStringItem("token");

    if (token == null) {
      throw UnauthorisedException("No token found");
    }

    return {'Content-Type': 'application/json', 'Cookie': token};
  }

  Future<dynamic> getTodosList(TodoProvider provider) async {
    var header = await getHeader();
    http.Response response = await http.get(
      Uri.parse(ApiRoutes.todoListApi),
      headers: header,
    );

    var repsonseBody = returnResponse(response);

    List<TodoModel> todoList =
        List.from(repsonseBody).map((e) => TodoModel.fromMap(e)).toList();

    provider.initList(todoList);
    return todoList;
  }

  Future<dynamic> createTodo(
      TodoProvider provider, CreateTodoModel todo) async {
    var header = await getHeader();

    http.Response response = await http.post(
      Uri.parse(ApiRoutes.createTodoApi),
      headers: header,
      body: todo.toJson(),
    );

    var responseBody = returnResponse(response);
    TodoModel newTodo = TodoModel.fromMap(responseBody);
    provider.addTodo(newTodo);
    return newTodo;
  }

  Future<dynamic> updateTodo(
      TodoProvider provider, int id, CreateTodoModel todo) async {
    var header = await getHeader();
    http.Response response = await http.put(
      Uri.parse('${ApiRoutes.updateTodoApi}$id'),
      headers: header,
      body: todo.toJson(),
    );

    var responseBody = returnResponse(response);
    TodoModel updatedTodo = TodoModel.fromMap(responseBody);

    provider.updateTodo(updatedTodo);
    return updatedTodo;
  }

  Future<dynamic> deleteTodo(TodoProvider provider, int id) async {
    var header = await getHeader();

    http.Response response = await http
        .delete(Uri.parse('${ApiRoutes.deleteTodoApi}$id'), headers: header);

    returnResponse(response);
    provider.deleteTodo(id);
    return true;
  }
}
