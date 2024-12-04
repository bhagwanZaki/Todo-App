import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo/component/create_todo.dart';
import 'package:todo/component/todo_item.dart';
import 'package:todo/model/todo_model.dart';
import 'package:todo/provier/todo_provider.dart';
import 'package:todo/stream/todo_stream.dart';
import 'package:todo/theme/app_color.dart';
import 'package:todo/utils/api_response.dart';
import 'package:todo/utils/common.dart';
import 'package:todo/constant/routes.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  TextEditingController createTextFieldController = TextEditingController();
  TextEditingController updateController = TextEditingController();

  TodoStream? _listStream;
  final _formKey = GlobalKey<FormState>();

  CreateTodoModel createTodoModel = CreateTodoModel(name: '', completed: false);
  DateTime todaysDate = DateTime.now();
  bool addTodoStatus = true;
  bool showError = true;
  int currentTodoForUpdate = -1;
  bool isEditModeOn = false;

  @override
  void initState() {
    _listStream = TodoStream();
    _listStream?.getTodoList(context.read<TodoProvider>());
    super.initState();
  }

  void addTodo() {
    if (_formKey.currentState!.validate()) {
      createTodoModel.name = createTextFieldController.text;
      _listStream?.createTodoList(
          context.read<TodoProvider>(), createTodoModel);
      createTextFieldController.text = '';
      setState(() {
        // addTodoStatus = true;
        showError = true;
      });
    }
  }

  void updateTodoCall() {
    _listStream?.updateTodoList(
        context.read<TodoProvider>(),
        currentTodoForUpdate,
        CreateTodoModel(
          name: updateController.text,
          completed: false,
        ));
    setState(() {
      isEditModeOn = false;
      currentTodoForUpdate = -1;
    });
  }

  void toggleAddState() {
    createTextFieldController.text = '';
    setState(() {
      addTodoStatus = !addTodoStatus;
    });
  }

  void setSelectedTodoUpdateState(bool status, int id) {
    setState(() {
      isEditModeOn = status;
      currentTodoForUpdate = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<TodoModel> todoList = context.watch<TodoProvider>().todoList;

    return Scaffold(
      floatingActionButton: createUpdateStream(),
      body: RefreshIndicator(
        onRefresh: () => _listStream?.getTodoList(context.read<TodoProvider>()),
        child: SafeArea(
            child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            "${todaysDate.day < 10 ? '0' : ''}${todaysDate.day}",
                            style: TextStyle(
                                color: AppColor.blue,
                                fontWeight: FontWeight.w700,
                                fontSize: 60),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${Common.monthName(todaysDate.month)}, ${todaysDate.year}\n${Common.weekDayName(todaysDate.weekday)}",
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                    Ink(
                      width: 51,
                      height: 51,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.card,
                      ),
                      child: InkWell(
                        onTap: () =>
                            Navigator.pushNamed(context, Routes.settingScreen),
                        borderRadius: BorderRadius.circular(60),
                        child: Icon(Icons.person),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    "Tasks",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    " (${todoList.where(
                          (element) => element.completed == false,
                        ).length})",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  )
                ],
              ),
              addTodoStatus
                  ? SizedBox()
                  : CreateTodo(
                      formKey: _formKey,
                      createTextField: createTextFieldController,
                      submitForm: addTodo,
                      toggleAddState: toggleAddState,
                    ),
              StreamBuilder<ApiResponse<List<TodoModel>>>(
                stream: _listStream?.listStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status) {
                      case Status.LOADING:
                        return CircularProgressIndicator(
                          color: AppColor.blue,
                        );
                      case Status.DONE:
                        return todoList.isEmpty
                            ? Column(
                                children: [
                                  Image.asset(
                                    "asset/images/empty.png",
                                    width: 300,
                                    height: 400,
                                  ),
                                  Text("No Task, Enjoy your day")
                                ],
                              )
                            : ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: todoList.length,
                                itemBuilder: (context, index) {
                                  TodoModel data = todoList[index];
                                  return TodoItem(
                                    todoId: data.id,
                                    todo: data,
                                    textFieldController: updateController,
                                    slidabeEnabled: !isEditModeOn,
                                    updateCallback: setSelectedTodoUpdateState,
                                    submitUpdateForm: updateTodoCall,
                                  );
                                },
                              );
                      case Status.ERROR:
                        return errorComponent(context);
                      default:
                        break;
                    }
                  }
                  return CircularProgressIndicator(
                    color: AppColor.blue,
                  );
                },
              )
            ],
          ),
        )),
      ),
    );
  }

  StreamBuilder<ApiResponse<TodoModel>> createUpdateStream() {
    return StreamBuilder<ApiResponse<TodoModel>>(
      stream: _listStream?.todoStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data?.status) {
            case Status.LOADING:
              return loadingFloatingBtn();
            case Status.DONE:
              return isEditModeOn ? editFloatingBtn() : addFloatingBtn();
            case Status.ERROR:
              showError
                  ? Fluttertoast.showToast(
                      msg: snapshot.data!.msg,
                      toastLength: Toast.LENGTH_SHORT,
                      backgroundColor: AppColor.red,
                      textColor: AppColor.white)
                  : null;
              showError = false;
              return addFloatingBtn();
            default:
              break;
          }
        }
        return isEditModeOn ? editFloatingBtn() : addFloatingBtn();
      },
    );
  }

  Column errorComponent(BuildContext context) {
    return Column(
      children: [
        Image.asset("asset/images/error.png"),
        ElevatedButton(
          onPressed: () =>
              _listStream?.getTodoList(context.read<TodoProvider>()),
          child: Text("Retry"),
        )
      ],
    );
  }

  FloatingActionButton addFloatingBtn() {
    return FloatingActionButton(
      onPressed: () {
        if (!addTodoStatus) {
          addTodo();
        } else {
          setState(() {
            addTodoStatus = false;
          });
        }
      },
      child: Icon(addTodoStatus ? Icons.add : Icons.check),
    );
  }

  FloatingActionButton editFloatingBtn() {
    return FloatingActionButton(
      onPressed: () => updateTodoCall(),
      child: Icon(Icons.edit),
    );
  }

  FloatingActionButton loadingFloatingBtn() {
    return FloatingActionButton(
      onPressed: null,
      child: CircularProgressIndicator(
        color: AppColor.blue,
      ),
    );
  }
}
