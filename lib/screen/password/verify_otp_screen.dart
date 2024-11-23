import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo/constant/enums.dart';
import 'package:todo/screen/password/reset_password_screen.dart';
import 'package:todo/stream/auth_stream.dart';
import 'package:todo/theme/app_color.dart';
import 'package:todo/utils/api_response.dart';
import 'package:todo/utils/common.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;
  final bool isForgetPassword;
  const VerifyOtpScreen(
      {super.key, required this.email, required this.isForgetPassword});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  AuthStream? _stream;
  final _formKey = GlobalKey<FormState>();

  TextEditingController otp = TextEditingController();
  bool isTextFieldEnable = true;
  bool apiCallDone = false;

  verifyOTP() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState!.validate() && otp.text.length == 6) {
      setState(() {
        isTextFieldEnable = false;
      });

      _stream?.verifyOtp(
          widget.email,
          int.parse(otp.text),
          widget.isForgetPassword
              ? Enums.forgetPassword
              : Enums.passwordChange);
      apiCallDone = true;
    }
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Image.asset(
              "asset/images/email.png",
              width: 300,
              height: 400,
            ),
            const Text(
              "Verify Request",
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 4,
            ),
            const Text(
              "We have send a 6 digit otp on your\nregistered email",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 24,
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                enabled: isTextFieldEnable,
                controller: otp,
                maxLength: 6,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter OTP';
                  } else if (value.length != 6) {
                    return 'Enter valid 6 digit otp';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value.length == 6) {
                    verifyOTP();
                  }
                },
                onFieldSubmitted: (value) {
                  verifyOTP();
                },
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  hintText: "OTP",
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder(
              stream: _stream?.boolStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data?.status) {
                    case Status.LOADING:
                      return CircularProgressIndicator();
                    case Status.DONE:
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) {
                          if (apiCallDone) {
                            Navigator.push(
                              context,
                              Common.pageRouteBuilder(
                                ResetPasswordScreen(
                                  email: widget.email,
                                  isForgetPassword: widget.isForgetPassword,
                                ),
                              ),
                            );
                            apiCallDone = false;
                          }
                        },
                      );
                      break;
                    case Status.ERROR:
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (apiCallDone) {
                          setState(() {
                            isTextFieldEnable = true;
                          });
                          apiCallDone = false;
                        }
                      });
                      apiCallDone
                          ? Fluttertoast.showToast(
                              msg: snapshot.data!.msg,
                              toastLength: Toast.LENGTH_SHORT,
                              backgroundColor: AppColor.red,
                              textColor: AppColor.white,
                            )
                          : null;
                      break;
                    default:
                      break;
                  }
                }
                return const SizedBox();
              },
            ),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                child: const Text("Resend OTP"),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
