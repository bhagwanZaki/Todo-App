import 'package:flutter/material.dart';
import 'package:todo/theme/app_color.dart';

class CreateTodo extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Function submitForm;
  final Function toggleAddState;
  final TextEditingController createTextField;
  const CreateTodo(
      {super.key,
      required this.submitForm,
      required this.createTextField,
      required this.formKey,
      required this.toggleAddState});

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Card(
        child: TextFormField(
          controller: widget.createTextField,
          autofocus: true,
          decoration: InputDecoration(
            fillColor: AppColor.card,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColor.card),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColor.card),
            ),
            hintText: "Add Todo Notes",
            suffixIcon: IconButton(
              icon: Icon(color: Theme.of(context).iconTheme.color, Icons.close),
              onPressed: () {
                widget.toggleAddState();
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
          onFieldSubmitted: (_) {
            widget.submitForm();
          },
          onEditingComplete: () {},
        ),
      ),
    );
  }
}
