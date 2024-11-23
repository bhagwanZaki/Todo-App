import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo/model/user_model.dart';
import 'package:todo/screen/auth/email_verification.dart';
import 'package:todo/stream/auth_stream.dart';
import 'package:todo/theme/app_color.dart';
import 'package:todo/utils/api_response.dart';
import 'package:todo/utils/common.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  AuthStream? _authStream;

  // focus nodes
  FocusNode fullNameFieldFocus = FocusNode();
  FocusNode emailFieldFocus = FocusNode();
  FocusNode passwordFieldFocus = FocusNode();
  FocusNode cPasswordFieldFocus = FocusNode();

  // controller
  TextEditingController username = TextEditingController();
  TextEditingController fullname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cpassword = TextEditingController();

  // obscure
  bool obscure = true;
  bool obscure2 = true;

  // function

  register() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState!.validate()) {
      _authStream?.register(username.text, email.text);
    }
  }

  // main

  @override
  void initState() {
    _authStream = AuthStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Already have an account",
            style: TextStyle(fontWeight: FontWeight.w400),
          )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Register",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.w400),
              ),
              label("Welcome to Todo"),
              const SizedBox(
                height: 36,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                controller: username,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Username';
                  }
                  return null;
                },
                onFieldSubmitted: (value) =>
                    FocusScope.of(context).requestFocus(fullNameFieldFocus),
                style: const TextStyle(fontSize: 15),
                decoration: const InputDecoration(
                  hintText: "Username",
                ),
              ),
              size16(),
              TextFormField(
                focusNode: fullNameFieldFocus,
                textInputAction: TextInputAction.next,
                controller: fullname,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Name';
                  }
                  return null;
                },
                onFieldSubmitted: (value) =>
                    FocusScope.of(context).requestFocus(emailFieldFocus),
                style: const TextStyle(fontSize: 15),
                decoration: const InputDecoration(
                  hintText: "Full Name",
                ),
              ),
              size16(),
              TextFormField(
                focusNode: emailFieldFocus,
                textInputAction: TextInputAction.next,
                controller: email,
                keyboardType: TextInputType.emailAddress,
                onFieldSubmitted: (value) =>
                    FocusScope.of(context).requestFocus(passwordFieldFocus),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Email';
                  }
                  return null;
                },
                style: const TextStyle(fontSize: 15),
                decoration: const InputDecoration(
                  hintText: "Email",
                ),
              ),
              size16(),
              TextFormField(
                focusNode: passwordFieldFocus,
                textInputAction: TextInputAction.next,
                controller: password,
                obscureText: obscure,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Password';
                  }
                  return null;
                },
                onFieldSubmitted: (value) =>
                    FocusScope.of(context).requestFocus(cPasswordFieldFocus),
                style: const TextStyle(fontSize: 15),
                decoration: InputDecoration(
                  hintText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                        color: Theme.of(context).iconTheme.color,
                        obscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(
                        () {
                          obscure = !obscure;
                        },
                      );
                    },
                  ),
                ),
              ),
              size10(),
              size10(),
              TextFormField(
                focusNode: cPasswordFieldFocus,
                controller: cpassword,
                obscureText: obscure,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter Confirm Password";
                  } else if (password.text != value) {
                    return "Password Not Same";
                  }
                  return null;
                },
                onFieldSubmitted: (value) => register(),
                style: const TextStyle(fontSize: 15),
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                        color: Theme.of(context).iconTheme.color,
                        obscure2 ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(
                        () {
                          obscure2 = !obscure2;
                        },
                      );
                    },
                  ),
                ),
              ),
              size50(),
              Align(
                alignment: Alignment.centerRight,
                child: StreamBuilder<ApiResponse<RegisterResponseModel>>(
                  stream: _authStream?.verifyEmailStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data?.status) {
                        case Status.LOADING:
                          return loadingBtn();
                        case Status.DONE:
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) => Navigator.push(
                                context,
                                Common.pageRouteBuilder(EmailVerificationScreen(
                                  username: username.text,
                                  email: email.text,
                                  password: password.text,
                                  fullname: fullname.text,
                                ))),
                          );
                          return registerBtn();
                        case Status.ERROR:
                          Fluttertoast.showToast(
                            msg: snapshot.data!.msg,
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: AppColor.red,
                            textColor: AppColor.white,
                          );
                          return registerBtn();
                        default:
                          break;
                      }
                    }
                    return registerBtn();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton registerBtn() {
    return ElevatedButton(
      onPressed: () => register(),
      child: const Text("Register"),
    );
  }

  ElevatedButton loadingBtn() {
    return ElevatedButton(
      onPressed: () {},
      child: const CircularProgressIndicator(
        color: AppColor.black,
      ),
    );
  }

  SizedBox size10() {
    return const SizedBox(
      height: 10,
    );
  }

  SizedBox size16() {
    return const SizedBox(
      height: 16,
    );
  }

  SizedBox size50() {
    return const SizedBox(
      height: 40,
    );
  }

  Text label(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14),
    );
  }
}
