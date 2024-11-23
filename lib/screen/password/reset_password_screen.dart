import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo/constant/routes.dart';
import 'package:todo/stream/auth_stream.dart';
import 'package:todo/theme/app_color.dart';
import 'package:todo/utils/api_response.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final bool isForgetPassword;
  const ResetPasswordScreen(
      {super.key, required this.email, required this.isForgetPassword});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  AuthStream? _authStream;

  TextEditingController password = TextEditingController();
  TextEditingController cpassword = TextEditingController();

  bool apiCallDone = false;
  bool obscure = true;
  bool cobscure = true;
  bool minimumCharacters = false;
  bool captialLetters = false;
  bool lowerLetters = false;
  bool numberCheck = false;
  bool specialCharacters = false;
  bool showError = true;

  FocusNode cpasswordFocus = FocusNode();

  @override
  void initState() {
    _authStream = AuthStream();
    super.initState();
  }

  navigationPop(BuildContext context) {
    if (widget.isForgetPassword) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.loginScreen,
        (route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.mainScreen,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => navigationPop(context),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => navigationPop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
              )),
        ),
        floatingActionButton: StreamBuilder<ApiResponse<bool>>(
          stream: _authStream?.boolStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data?.status) {
                case Status.LOADING:
                  return loadingFloatingBtn();
                case Status.DONE:
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) {
                      if (apiCallDone) {
                        navigationPop(context);
                        apiCallDone = false;
                      }
                    },
                  );
                  return floatingBtn(context);
                case Status.ERROR:
                  apiCallDone
                      ? Fluttertoast.showToast(
                          msg: snapshot.data!.msg,
                          toastLength: Toast.LENGTH_SHORT,
                          backgroundColor: AppColor.red,
                          textColor: AppColor.white,
                        )
                      : null;
                  apiCallDone = false;
                  return floatingBtn(context);
                default:
                  break;
              }
            }
            return floatingBtn(context);
          },
        ),
        body: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) =>
              Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.loginScreen,
            (route) => false,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Reset Password",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  label(
                    "Enter your new password",
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  label(
                    "New Password :",
                  ),
                  size15(),
                  TextFormField(
                    controller: password,
                    obscureText: obscure,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Password';
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) =>
                        FocusScope.of(context).requestFocus(cpasswordFocus),
                    onChanged: (word) {
                      setState(() {
                        minimumCharacters = word.length >= 8;
                        lowerLetters = word.contains(RegExp(r'[a-z]'));
                        captialLetters = word.contains(RegExp(r'[A-Z]'));
                        numberCheck = word.contains(RegExp(r'[0-9]'));
                        specialCharacters = word.split('').any(
                            (char) => !RegExp(r'[a-zA-Z0-9\s]').hasMatch(char));
                      });
                    },
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Password",
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 0),
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
                  size40(),
                  label("Confirm New Password :"),
                  size15(),
                  TextFormField(
                    focusNode: cpasswordFocus,
                    controller: cpassword,
                    obscureText: cobscure,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Confirm Password";
                      } else if (password.text != value) {
                        return "Password Not Same";
                      }
                      return null;
                    },
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 0),
                      suffixIcon: IconButton(
                        icon: Icon(
                            color: Theme.of(context).iconTheme.color,
                            cobscure ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(
                            () {
                              cobscure = !cobscure;
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  size40(),
                  label("Password must contains :"),
                  size15(),
                  passwordCheckLabels("Minimum 8 charcters", minimumCharacters),
                  size8(),
                  passwordCheckLabels("Lower case letter", lowerLetters),
                  size8(),
                  passwordCheckLabels("Upper case letter", captialLetters),
                  size8(),
                  passwordCheckLabels("Special characters", specialCharacters),
                  size8(),
                  passwordCheckLabels("Number", numberCheck),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isPasswordCondition() {
    return minimumCharacters &&
        captialLetters &&
        lowerLetters &&
        numberCheck &&
        specialCharacters;
  }

  FloatingActionButton floatingBtn(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: isPasswordCondition()
          ? AppColor.card
          : AppColor.card.withOpacity(0.5),
      elevation: isPasswordCondition() ? 6 : 0,
      onPressed: isPasswordCondition()
          ? () {
              FocusScope.of(context).requestFocus(FocusNode());
              if (_formKey.currentState!.validate()) {
                if (widget.isForgetPassword) {
                  _authStream?.forgetPassoword(
                    widget.email,
                    password.text,
                  );
                } else {
                  _authStream?.resetPassoword(
                    widget.email,
                    password.text,
                  );
                }
                apiCallDone = true;
              }
            }
          : null,
      child: Icon(
        Icons.check,
        color: isPasswordCondition()
            ? AppColor.blue
            : AppColor.blue.withOpacity(0.5),
      ),
    );
  }

  FloatingActionButton loadingFloatingBtn() {
    return FloatingActionButton(
      onPressed: () {},
      child: const CircularProgressIndicator(
        color: AppColor.blue,
      ),
    );
  }

  Row passwordCheckLabels(String text, bool isFollowed) {
    return Row(
      children: [
        Icon(Icons.check_circle_outlined,
            size: 15, color: isFollowed ? AppColor.blue : AppColor.grey),
        const SizedBox(
          width: 10,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 12, color: isFollowed ? AppColor.blue : AppColor.grey),
        )
      ],
    );
  }

  SizedBox size40() {
    return const SizedBox(
      height: 25,
    );
  }

  Text label(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14),
    );
  }

  SizedBox size15() {
    return const SizedBox(
      height: 15,
    );
  }

  SizedBox size8() {
    return const SizedBox(
      height: 8,
    );
  }

  @override
  void dispose() {
    cpasswordFocus.dispose();
    super.dispose();
  }
}
