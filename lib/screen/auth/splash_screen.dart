import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/constant/routes.dart';
import 'package:todo/model/user_model.dart';
import 'package:todo/provier/auth_provider.dart';
import 'package:todo/stream/auth_stream.dart';
import 'package:todo/utils/api_response.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthStream? _authStream;
  @override
  void initState() {
    _authStream = AuthStream();
    _authStream?.checkAuth(context.read<AuthProvider>());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          "By\nFloran",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("asset/images/splashscreen.png"),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Todo",
              style: TextStyle(fontSize: 24),
            ),
            StreamBuilder<ApiResponse<UserModel>>(
              stream: _authStream?.authStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data?.status) {
                    case Status.LOADING:
                      return const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: CircularProgressIndicator(),
                      );
                    case Status.DONE:
                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        Navigator.pushNamedAndRemoveUntil(
                            context, Routes.mainScreen, (route) => false);
                      });
                      break;
                    case Status.ERROR:
                      if (snapshot.data?.msg == "Invalid authorization" ||
                          snapshot.data?.msg == "No token found") {
                        WidgetsBinding.instance.addPostFrameCallback((_) async {
                          Navigator.pushNamedAndRemoveUntil(
                              context, Routes.loginScreen, (route) => false);
                        });
                        break;
                      } else {
                        return ElevatedButton(
                            onPressed: () => _authStream
                                ?.checkAuth(context.read<AuthProvider>()),
                            child: Text("Retry"));
                      }
                    default:
                      break;
                  }
                }
                return SizedBox();
              },
            )
          ],
        ),
      )),
    );
  }
}
