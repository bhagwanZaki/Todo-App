import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo/component/setting/logout_item.dart';
import 'package:todo/constant/enums.dart';
import 'package:todo/constant/routes.dart';
import 'package:todo/provier/auth_provider.dart';
import 'package:todo/stream/auth_stream.dart';
import 'package:todo/theme/app_color.dart';
import 'package:todo/utils/api_response.dart';

class DeleteAccountItem extends StatefulWidget {
  final String username;
  final String email;
  const DeleteAccountItem(
      {super.key, required this.username, required this.email});

  @override
  State<DeleteAccountItem> createState() => _DeleteAccountItemState();
}

class _DeleteAccountItemState extends State<DeleteAccountItem> {
  bool showDeleteOTPContainer = false;
  bool apiCallDone = false;

  AuthStream? _stream;
  AuthStream? _deleteStream;

  TextEditingController confirmController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      borderRadius: BorderRadius.circular(9),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
            color: AppColor.card, borderRadius: BorderRadius.circular(9)),
        child: Row(
          children: [
            Icon(
              Icons.delete_forever_outlined,
              size: 18,
              color: AppColor.red,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              "Delete Account",
              style: TextStyle(fontSize: 12, color: AppColor.white),
            )
          ],
        ),
      ),
    );
  }

  onTap() {
    _stream ??= AuthStream();
    _deleteStream ??= AuthStream();
    if (showDeleteOTPContainer) {
      setState(() {
        showDeleteOTPContainer = false;
      });
    }
    final Size screenSize = MediaQuery.of(context).size;

    // Use the center of the screen as the anchor point
    final Offset anchorPoint = Offset(
      screenSize.width / 2,
      screenSize.height / 2,
    );
    showModalBottomSheet(
      context: context,
      anchorPoint: anchorPoint,
      isScrollControlled: true,
      shape: const BeveledRectangleBorder(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      constraints: const BoxConstraints(minWidth: double.infinity),
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateIn) {
          return Container(
            width: screenSize.width,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Delete Account",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                          onPressed: () {
                            _stream?.disposeBoolStream();
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Are you sure you want to delete your account ?",
                    style: TextStyle(
                        color: AppColor.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "This will be permantly delete your account and all its associated data. This step is irreversible",
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    child: AnimatedCrossFade(
                      crossFadeState: showDeleteOTPContainer
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 400),
                      firstChild: Form(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(
                                  text: "To confirm, type ",
                                  style: TextStyle(
                                    fontFamily: 'Spartan',
                                  ),
                                  children: [
                                TextSpan(
                                    text: widget.username,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Spartan',
                                    )),
                                TextSpan(
                                    text: " in the box below.",
                                    style: TextStyle(
                                      fontFamily: 'Spartan',
                                    )),
                              ])),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: confirmController,
                            keyboardType: TextInputType.emailAddress,
                            onFieldSubmitted: (value) {
                              if (value == widget.username) {
                                apiCallDone = true;
                                _stream?.otpRequest(
                                    widget.email, Enums.deleteAccount);
                              }
                            },
                            decoration: const InputDecoration(
                                hintText: "Enter username"),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: StreamBuilder<ApiResponse<bool>>(
                              stream: _stream?.boolStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  switch (snapshot.data?.status) {
                                    case Status.LOADING:
                                      return loadingBtn();
                                    case Status.DONE:
                                      WidgetsBinding.instance
                                          .addPostFrameCallback(
                                        (_) {
                                          setStateIn(() {
                                            showDeleteOTPContainer = true;
                                          });
                                        },
                                      );
                                      return continueBtn();
                                    case Status.ERROR:
                                      apiCallDone
                                          ? Fluttertoast.showToast(
                                              msg: snapshot.data!.msg,
                                              toastLength: Toast.LENGTH_SHORT,
                                              backgroundColor: AppColor.red,
                                              textColor: AppColor.white)
                                          : null;
                                      apiCallDone = false;
                                      return continueBtn();
                                    default:
                                      return continueBtn();
                                  }
                                }
                                return continueBtn();
                              },
                            ),
                          )
                        ],
                      )),
                      secondChild: Form(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Enter OTP send to your email',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: otpController,
                            onChanged: (value) {
                              if (value.length == 6) {
                                apiCallDone = true;
                                _deleteStream?.deleteUser(int.parse(value),
                                    context.read<AuthProvider>());
                              }
                            },
                            onFieldSubmitted: (value) {
                              if (value.length == 6) {
                                apiCallDone = true;
                                _deleteStream?.deleteUser(int.parse(value),
                                    context.read<AuthProvider>());
                              }
                            },
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            decoration:
                                const InputDecoration(hintText: "Enter OTP"),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          StreamBuilder<ApiResponse<bool>>(
                            stream: _deleteStream?.boolStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                switch (snapshot.data?.status) {
                                  case Status.LOADING:
                                    return loadingBtn();
                                  case Status.DONE:
                                    if (apiCallDone) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback(
                                        (_) {
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              Routes.loginScreen,
                                              (route) => false);
                                        },
                                      );
                                      apiCallDone = false;
                                    }
                                    return deleteBtn(context);
                                  case Status.ERROR:
                                    apiCallDone
                                        ? Fluttertoast.showToast(
                                            msg: snapshot.data!.msg,
                                            toastLength: Toast.LENGTH_SHORT,
                                            backgroundColor: AppColor.red,
                                            textColor: AppColor.white)
                                        : null;
                                    apiCallDone = false;
                                    return deleteBtn(context);
                                  default:
                                    break;
                                }
                              }
                              return deleteBtn(context);
                            },
                          ),
                        ],
                      )),
                    ),
                  )
                ],
              ),
            ),
          );
        });
      },
    ).then(
      (value) {
        _stream?.disposeBoolStream();
        _deleteStream?.disposeBoolStream();
        _stream = null;
        _deleteStream = null;
      },
    );
  }

  MaterialButton deleteBtn(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        if (otpController.text.length == 6) {
          apiCallDone = true;
          _deleteStream?.deleteUser(
              int.parse(otpController.text), context.read<AuthProvider>());
        }
      },
      minWidth: double.infinity,
      color: AppColor.red,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: const Text("Delete Account",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }

  MaterialButton continueBtn() {
    return MaterialButton(
      onPressed: () {
        if (confirmController.text == widget.username) {
          apiCallDone = true;
          _stream?.otpRequest(widget.email, Enums.deleteAccount);
        }
      },
      color: AppColor.red,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: const Text("Continue",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }

  MaterialButton loadingBtn() {
    return MaterialButton(
      onPressed: null,
      color: AppColor.red,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: const CircularProgressIndicator(
        color: AppColor.white,
      ),
    );
  }
}
