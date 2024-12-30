import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo/model/todo_model.dart';
import 'package:todo/provier/todo_provider.dart';
import 'package:todo/stream/todo_stream.dart';
import 'package:todo/theme/app_color.dart';
import 'package:todo/utils/api_response.dart';

class TodoItem extends StatefulWidget {
  final int todoId;

  final TodoModel todo;
  final bool slidabeEnabled;
  final TextEditingController textFieldController;
  final Function(bool, int) updateCallback;
  final Function submitUpdateForm;

  const TodoItem({
    super.key,
    required this.todo,
    required this.todoId,
    required this.slidabeEnabled,
    required this.textFieldController,
    required this.updateCallback,
    required this.submitUpdateForm,
  });

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  TodoStream? _stream;
  TodoStream? _deleteStream;

  bool editMode = false;
  bool showToast = true;
  bool isDeleteApiCompleted = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.slidabeEnabled && editMode) {
      editMode = false;
    }

    return Slidable(
      enabled: widget.slidabeEnabled,
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: widget.todo.completed
            ? [deleteSlideBtn()]
            : [
                deleteSlideBtn(),
                const SizedBox(
                  width: 4,
                ),
                editSlideBtn(),
              ],
      ),
      child: Card(
        child: editMode
            ? updateTextField(context)
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StreamBuilder<ApiResponse<TodoModel>>(
                    stream: _stream?.todoStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data!.status) {
                          case Status.LOADING:
                            return loader();
                          case Status.DONE:
                            _stream?.disposeTodoStream();

                            return checkbox();
                          case Status.ERROR:
                            showToast
                                ? Fluttertoast.showToast(
                                    msg: snapshot.data!.msg,
                                    toastLength: Toast.LENGTH_SHORT,
                                    backgroundColor: AppColor.red,
                                    textColor: AppColor.white)
                                : null;
                            WidgetsBinding.instance.addPostFrameCallback(
                              (_) {
                                if (showToast) {
                                  _stream?.disposeTodoStream();
                                  setState(() {
                                    showToast = false;
                                  });
                                }
                              },
                            );
                            return checkbox();
                          default:
                            break;
                        }
                      }
                      return checkbox();
                    },
                  ),
                  Text(
                    widget.todo.name,
                    style: widget.todo.completed
                        ? TextStyle(
                            color: AppColor.grey,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: AppColor.grey,
                            decorationThickness: 2.0,
                          )
                        : null,
                  )
                ],
              ),
      ),
    );
  }

  Padding loader() {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          color: AppColor.white,
          strokeWidth: 1,
        ),
      ),
    );
  }

  TextFormField updateTextField(BuildContext context) {
    return TextFormField(
      controller: widget.textFieldController,
      autofocus: true,
      decoration: InputDecoration(
        fillColor: AppColor.card,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        hintText: "Add Todo Notes",
        suffixIcon: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            setState(() {
              editMode = false;
            });
            widget.updateCallback(false, -1);
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Note should not be empty';
        }
        return null;
      },
      style: const TextStyle(fontSize: 15),
      onFieldSubmitted: (value) {
        setState(() {
          editMode = false;
        });
        widget.submitUpdateForm();
      },
    );
  }

  Checkbox checkbox() {
    return Checkbox(
      value: widget.todo.completed,
      activeColor: AppColor.blue,
      // focusColor: AppColors.mediumGreen,
      shape: const CircleBorder(),
      side: BorderSide(color: AppColor.grey, width: 1),
      onChanged: (value) {
        var tododata =
            CreateTodoModel(name: widget.todo.name, completed: value!);
        _stream = TodoStream();
        setState(() {
          showToast = true;
        });
        _stream?.updateTodoList(
            context.read<TodoProvider>(), widget.todoId, tododata);
      },
    );
  }

  SlidableAction editSlideBtn() {
    return SlidableAction(
      onPressed: (context) {
        setState(() {
          editMode = true;
        });
        widget.textFieldController.text = widget.todo.name;
        widget.updateCallback(true, widget.todoId);
      },
      borderRadius: BorderRadius.circular(100),
      backgroundColor: AppColor.card,
      foregroundColor: AppColor.blue,
      icon: Icons.edit,
    );
  }

  SlidableAction deleteSlideBtn() {
    return SlidableAction(
      onPressed: (context) {
        _deleteStream = TodoStream();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Theme.of(context).cardTheme.color,
              title: Text(
                "Delete Todo",
              ),
              content: Text(
                "This will Todo the transaction forever.\nAre you sure?",
                style: const TextStyle(fontSize: 13, color: AppColor.white),
                textAlign: TextAlign.center,
              ),
              icon: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: AppColor.red),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                    Icons.delete_forever_rounded,
                    color: AppColor.white,
                  )),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                deleteStream(),
                MaterialButton(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  onPressed: () {
                    Navigator.pop(context);
                    _deleteStream?.disposeDeleteStream();
                  },
                  color: AppColor.black,
                  child: Text("Close"),
                ),
              ],
            );
          },
        ).then(
          (value) {
            if (value == null) {
              _deleteStream?.disposeDeleteStream();
            }
          },
        );
      },
      backgroundColor: AppColor.card,
      foregroundColor: AppColor.red,
      borderRadius: BorderRadius.circular(100),
      padding: const EdgeInsets.all(0),
      icon: Icons.delete,
    );
  }

  StreamBuilder<ApiResponse<bool>> deleteStream() {
    return StreamBuilder<ApiResponse<bool>>(
      stream: _deleteStream?.deleteStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data?.status) {
            case Status.LOADING:
              return deleteLoadingBtn(context);
            case Status.DONE:
              WidgetsBinding.instance.addPostFrameCallback(
                (_) {
                  if (isDeleteApiCompleted) {
                    Navigator.pop(context);
                    _deleteStream?.disposeDeleteStream();
                    isDeleteApiCompleted = false;
                  }
                },
              );
              return deleteBtn(context);
            case Status.ERROR:
              isDeleteApiCompleted
                  ? Fluttertoast.showToast(
                      msg: snapshot.data!.msg,
                      toastLength: Toast.LENGTH_SHORT,
                      backgroundColor: AppColor.red,
                      textColor: AppColor.white)
                  : null;
              return deleteBtn(context);
            default:
              break;
          }
        }
        return deleteBtn(context);
      },
    );
  }

  MaterialButton deleteBtn(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onPressed: () {
        _deleteStream?.deleteTodoList(
            context.read<TodoProvider>(), widget.todoId);
        isDeleteApiCompleted = true;
      },
      color: AppColor.red,
      child: Text("Delete"),
    );
  }

  MaterialButton deleteLoadingBtn(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onPressed: null,
      color: AppColor.red,
      child: const CircularProgressIndicator(
        color: AppColor.white,
      ),
    );
  }
}
