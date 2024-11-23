import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo/constant/routes.dart';
import 'package:todo/model/user_model.dart';
import 'package:todo/provier/auth_provider.dart';
import 'package:todo/stream/auth_stream.dart';
import 'package:todo/theme/app_color.dart';
import 'package:todo/utils/api_response.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String fullname;
  final String username;
  final String email;
  final String password;
  const EmailVerificationScreen(
      {super.key,
      required this.username,
      required this.email,
      required this.password,
      required this.fullname});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController otp = TextEditingController();
  AuthStream? _authStream;
  bool showError = false;

  @override
  void initState() {
    _authStream = AuthStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Email\nVerification",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
              ),
              Text("To confirm your email, input the OTP sent to you."),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                controller: otp,
                maxLength: 6,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: "OTP"),
                onChanged: (value) {
                  if (value.length == 6) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    showError = true;
                    _authStream?.completeRegisterApi(
                      context.read<AuthProvider>(),
                      widget.username,
                      widget.email,
                      widget.password,
                      widget.fullname,
                      int.parse(otp.text),
                    );
                  }
                },
                onFieldSubmitted: (value) {
                  if (value.length == 6) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    showError = true;
                    _authStream?.completeRegisterApi(
                      context.read<AuthProvider>(),
                      widget.username,
                      widget.email,
                      widget.password,
                      widget.fullname,
                      int.parse(otp.text),
                    );
                  }
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Resend OTP",
                      style:    TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    )),
              ),
              StreamBuilder<ApiResponse<UserModel>>(
                stream: _authStream?.authStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data?.status) {
                      case Status.LOADING:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      case Status.DONE:
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) => Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.mainScreen,
                            (route) => false,
                          ),
                        );
                        return SizedBox();
                      case Status.ERROR:
                        if (showError) {
                          showError = false;
                          Fluttertoast.showToast(
                            msg: snapshot.data!.msg,
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: AppColor.red,
                            textColor: AppColor.white,
                          );
                        }
                        return SizedBox();
                      default:
                        break;
                    }
                  }
                  return SizedBox();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
