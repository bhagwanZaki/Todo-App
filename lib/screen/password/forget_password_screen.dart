import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo/constant/enums.dart';
import 'package:todo/screen/password/verify_otp_screen.dart';
import 'package:todo/stream/auth_stream.dart';
import 'package:todo/theme/app_color.dart';
import 'package:todo/utils/api_response.dart';
import 'package:todo/utils/common.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  AuthStream? _stream;
  bool apiCallDone = false;

  submitForm() {
    _stream?.otpRequest(emailController.text, Enums.forgetPassword);
    apiCallDone = true;
  }

  @override
  void initState() {
    _stream = AuthStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Forget Password",
              style: TextStyle(
                  fontSize: 36, fontWeight: FontWeight.w500, height: 0),
            ),
            const SizedBox(
              height: 4,
            ),
            Text("Forget password? No worries"),
            SizedBox(
              height: 20,
            ),
            Text(
              "Enter registered email:",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                ),
                keyboardType: TextInputType.emailAddress,
                onFieldSubmitted: (_) {
                  submitForm();
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: StreamBuilder(
                stream: _stream?.boolStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data?.status) {
                      case Status.LOADING:
                        return loadingBtn();
                      case Status.DONE:
                        apiCallDone
                            ? WidgetsBinding.instance.addPostFrameCallback(
                                (_) => Navigator.push(
                                    context,
                                    Common.pageRouteBuilder(VerifyOtpScreen(
                                      email: emailController.text,
                                      isForgetPassword: true,
                                    ))),
                              )
                            : null;
                        apiCallDone = false;
                        return submitBtn();
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
                        return submitBtn();
                      default:
                        break;
                    }
                  }
                  return submitBtn();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  ElevatedButton submitBtn() {
    return ElevatedButton(
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());
        if (_formKey.currentState!.validate()) {
          submitForm();
        }
      },
      child: Text("Send OTP"),
    );
  }

  ElevatedButton loadingBtn() {
    return ElevatedButton(
      onPressed: () {},
      child: CircularProgressIndicator(
        color: AppColor.black,
      ),
    );
  }
}
