import 'dart:async';

import 'package:todo/model/todo_model.dart';
import 'package:todo/provier/todo_provider.dart';
import 'package:todo/service/todo_service.dart';
import 'package:todo/utils/api_response.dart';

class TodoStream {
  late TodoService _service;

  // controller
  late StreamController<ApiResponse<List<TodoModel>>> _listController;
  late StreamController<ApiResponse<TodoModel>> _todoController;
  late StreamController<ApiResponse<bool>> _deleteController;

  // sink
  StreamSink<ApiResponse<List<TodoModel>>> get listSink => _listController.sink;
  StreamSink<ApiResponse<TodoModel>> get todoSink => _todoController.sink;
  StreamSink<ApiResponse<bool>> get deleteSink => _deleteController.sink;

  // sink
  Stream<ApiResponse<List<TodoModel>>> get listStream => _listController.stream;
  Stream<ApiResponse<TodoModel>> get todoStream => _todoController.stream;
  Stream<ApiResponse<bool>> get deleteStream => _deleteController.stream;

  // constructor
  TodoStream() {
    _service = TodoService();
    _listController = StreamController<ApiResponse<List<TodoModel>>>();
    _todoController = StreamController<ApiResponse<TodoModel>>();
    _deleteController = StreamController<ApiResponse<bool>>();
  }

  // methods
  getTodoList(TodoProvider provider) async {
    listSink.add(ApiResponse.loading("Calling todo list"));
    try {
      List<TodoModel> data = await _service.getTodosList(provider);
      listSink.add(ApiResponse.completed(data));
    } catch (e) {
      listSink.add(ApiResponse.error(e.toString()));
    }
  }

  createTodoList(TodoProvider provider, CreateTodoModel todo) async {
    todoSink.add(ApiResponse.loading("Calling create todo"));
    try {
      TodoModel data = await _service.createTodo(provider, todo);
      todoSink.add(ApiResponse.completed(data));
    } catch (e) {
      todoSink.add(ApiResponse.error(e.toString()));
    }
  }

  updateTodoList(TodoProvider provider, int id, CreateTodoModel todo) async {
    todoSink.add(ApiResponse.loading("Calling update todo"));
    try {
      TodoModel data = await _service.updateTodo(provider, id, todo);
      todoSink.add(ApiResponse.completed(data));
    } catch (e) {
      todoSink.add(ApiResponse.error(e.toString()));
    }
  }

  deleteTodoList(TodoProvider provider, int id) async {
    deleteSink.add(ApiResponse.loading("Calling delete todo"));
    try {
      bool data = await _service.deleteTodo(provider, id);
      deleteSink.add(ApiResponse.completed(data));
    } catch (e) {
      deleteSink.add(ApiResponse.error(e.toString()));
    }
  }

  disposeDeleteStream() {
    deleteSink.add(ApiResponse.active());
    _deleteController.close();
  }

  disposeTodoStream() {
    _todoController.close();
  }
}
