import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo/constant/routes.dart';
import 'package:todo/provier/auth_provider.dart';
import 'package:todo/screen/password/verify_otp_screen.dart';
import 'package:todo/stream/auth_stream.dart';
import 'package:todo/theme/app_color.dart';
import 'package:todo/utils/api_response.dart';
import 'package:todo/utils/common.dart';

class VerifyPasswordScreen extends StatefulWidget {
  const VerifyPasswordScreen({super.key});

  @override
  State<VerifyPasswordScreen> createState() => _VerifyPasswordScreenState();
}

class _VerifyPasswordScreenState extends State<VerifyPasswordScreen> {
  AuthStream? _stream;
  TextEditingController password = TextEditingController();
  bool obscure = true;
  bool apiCallDone = false;
  String username = "";
  String email = "";
  final _formKey = GlobalKey<FormState>();

  callVerifyPassword() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState!.validate()) {
      apiCallDone = true;
      _stream?.resetPasswordRequest(username, password.text);
    }
  }

  @override
  void initState() {
    _stream = AuthStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    username = context.watch<AuthProvider>().username;
    email = context.watch<AuthProvider>().email;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Verify your password",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
              ),
              Text("Enter your current password to set a new password"),
              Text(
                "Note: You'll be logged out of all devices after a password change",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: password,
                obscureText: obscure,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter Password';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => callVerifyPassword(),
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
              StreamBuilder<ApiResponse<bool>>(
                stream: _stream?.boolStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status) {
                      case Status.LOADING:
                        return loadingBtn();
                      case Status.DONE:
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) {
                            if (apiCallDone) {
                              Navigator.push(
                                context,
                                Common.pageRouteBuilder(
                                  VerifyOtpScreen(
                                    email: email,
                                    isForgetPassword: false,
                                  ),
                                ),
                              );
                              apiCallDone = false;
                            }
                          },
                        );
                        return verifyBtn();
                      case Status.ERROR:
                        apiCallDone
                            ? Fluttertoast.showToast(
                                msg: snapshot.data!.msg,
                                toastLength: Toast.LENGTH_SHORT,
                                backgroundColor: AppColor.red,
                                textColor: AppColor.white)
                            : null;
                        apiCallDone = false;
                        return verifyBtn();
                      default:
                        break;
                    }
                  }
                  return verifyBtn();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Align verifyBtn() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
          onPressed: () => callVerifyPassword(), child: Text("Verify")),
    );
  }

  Align loadingBtn() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
          onPressed: () {},
          child: const CircularProgressIndicator(
            color: AppColor.black,
          )),
    );
  }
}
