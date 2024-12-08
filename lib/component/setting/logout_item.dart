import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo/constant/routes.dart';
import 'package:todo/provier/auth_provider.dart';
import 'package:todo/stream/auth_stream.dart';
import 'package:todo/theme/app_color.dart';
import 'package:todo/utils/api_response.dart';

class LogoutItem extends StatefulWidget {
  final bool logoutFromALLdevice;
  const LogoutItem({super.key, required this.logoutFromALLdevice});

  @override
  State<LogoutItem> createState() => _LogoutItemState();
}

class _LogoutItemState extends State<LogoutItem> {
  AuthStream? _stream;
  bool apiCallDone = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _stream = AuthStream();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: AppColor.card,
              surfaceTintColor: AppColor.card,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              titlePadding: const EdgeInsets.only(top: 15, left: 15, right: 15),
              title: Text(
                'Logout ${widget.logoutFromALLdevice ? 'from all device' : ''}',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              icon: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: AppColor.red),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                    Icons.delete_forever_rounded,
                    color: AppColor.white,
                  )),
              actionsAlignment: MainAxisAlignment.center,
              content: const Text('Are you sure you want to continue?'),
              actions: [
                InkWell(
                  onTap: () {
                    _stream?.disposeBoolStream();
                    Navigator.of(context).pop();
                  },
                  child: Ink(
                      child:
                          const Text('Cancel', style: TextStyle(fontSize: 14))),
                ),
                const SizedBox(
                  width: 10,
                ),
                StreamBuilder(
                  stream: _stream?.boolStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data?.status) {
                        case Status.LOADING:
                          return logoutLoadingBtn();
                        case Status.DONE:
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) {
                              if (apiCallDone) {
                                _stream?.disposeBoolStream();
                                Navigator.pushNamedAndRemoveUntil(context,
                                    Routes.loginScreen, (route) => false);
                                apiCallDone = false;
                              }
                            },
                          );
                          return logoutBtn(context, false);
                        case Status.ERROR:
                          apiCallDone
                              ? Fluttertoast.showToast(
                                  msg: snapshot.data!.msg,
                                  toastLength: Toast.LENGTH_SHORT,
                                  backgroundColor: AppColor.red,
                                  textColor: AppColor.white)
                              : null;
                          apiCallDone = false;
                          return logoutBtn(context, false);
                        default:
                          return logoutBtn(context, false);
                      }
                    }
                    return logoutBtn(context, false);
                  },
                ),
              ],
            );
          },
        ).then(
          (value) {
            if (value == null) {
              _stream?.disposeBoolStream();
            }
          },
        );
      },
      borderRadius: BorderRadius.circular(9),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
            color: AppColor.card, borderRadius: BorderRadius.circular(9)),
        child: Row(
          children: [
            Icon(
              Icons.logout,
              size: 18,
              color: AppColor.white,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              "Logout from ${widget.logoutFromALLdevice ? 'all' : 'this'} device",
              style: TextStyle(fontSize: 12, color: AppColor.white),
            )
          ],
        ),
      ),
    );
  }

  InkWell logoutBtn(BuildContext context, bool logoutFromAllDevice) {
    return InkWell(
      onTap: () {
        _stream?.logout(
            context.read<AuthProvider>(), widget.logoutFromALLdevice);
        apiCallDone = true;
      },
      child: Ink(
        child: const Text(
          'Logout',
          style: TextStyle(color: AppColor.red, fontSize: 14),
        ),
      ),
    );
  }

  InkWell logoutLoadingBtn() {
    return InkWell(
      onTap: () {},
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
