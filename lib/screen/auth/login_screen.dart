import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo/constant/routes.dart';
import 'package:todo/model/user_model.dart';
import 'package:todo/provier/auth_provider.dart';
import 'package:todo/stream/auth_stream.dart';
import 'package:todo/theme/app_color.dart';
import 'package:todo/utils/api_response.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  FocusNode passwordFocus = FocusNode();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool obscure = true;
  bool apiCompleted = false;

  AuthStream? _authStream;

  login() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState!.validate()) {
      apiCompleted = true;
      _authStream?.login(
          context.read<AuthProvider>(), username.text, password.text);
    }
  }

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
          onPressed: () => Navigator.pushNamed(context, Routes.registerScreen),
          child: const Text(
            "Don't have an account",
            style: TextStyle(fontWeight: FontWeight.w400),
          )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Login",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.w400),
              ),
              label("Welcome back to Todo"),
              const SizedBox(
                height: 36,
              ),
              size10(),
              TextFormField(
                controller: username,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Username';
                  }
                  return null;
                },
                onFieldSubmitted: (value) =>
                    FocusScope.of(context).requestFocus(passwordFocus),
                style: const TextStyle(fontSize: 15),
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: "Username",
                ),
              ),
              size16(),
              TextFormField(
                focusNode: passwordFocus,
                controller: password,
                obscureText: obscure,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Password';
                  }
                  return null;
                },
                onFieldSubmitted: (value) {
                  login();
                },
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
              const SizedBox(
                height: 0,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    style: const ButtonStyle(
                        padding: WidgetStatePropertyAll(EdgeInsets.all(0))),
                    onPressed: () => Navigator.pushNamed(
                        context, Routes.forgetPasswordScreen),
                    child: const Text(
                      "Forgot Password ?",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    )),
              ),
              size50(),
              Align(
                alignment: Alignment.centerRight,
                child: StreamBuilder<ApiResponse<UserModel>>(
                  stream: _authStream?.authStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data?.status) {
                        case Status.LOADING:
                          return loadingBtn();
                        case Status.DONE:
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) {
                              if (apiCompleted) {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    Routes.mainScreen, (route) => false);
                                apiCompleted = false;
                              }
                            },
                          );
                          return loginBtn();
                        case Status.ERROR:
                          apiCompleted
                              ? Fluttertoast.showToast(
                                  msg: snapshot.data!.msg,
                                  toastLength: Toast.LENGTH_SHORT,
                                  backgroundColor: AppColor.red,
                                  textColor: AppColor.white)
                              : null;
                          apiCompleted = false;
                          return loginBtn();
                        default:
                          return loadingBtn();
                      }
                    }
                    return loginBtn();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton loginBtn() {
    return ElevatedButton(
      onPressed: () => login(),
      child: const Text("Login"),
    );
  }

  ElevatedButton loadingBtn() {
    return ElevatedButton(
      onPressed: () => login(),
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
