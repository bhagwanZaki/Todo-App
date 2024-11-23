import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/provier/auth_provider.dart';
import 'package:todo/provier/todo_provider.dart';
import 'package:todo/screen/auth/login_screen.dart';
import 'package:todo/screen/auth/register_screen.dart';
import 'package:todo/screen/profile/setting_screen.dart';
import 'package:todo/screen/main/todo_list_screen.dart';
import 'package:todo/screen/password/forget_password_screen.dart';
import 'package:todo/screen/profile/verify_password.dart';
import 'package:todo/theme/theme.dart';

import 'package:todo/screen/auth/splash_screen.dart';
import 'package:todo/constant/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TodoProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: MaterialApp(
          title: 'Todo',
          theme: AppTheme.themeData(context),
          darkTheme: AppTheme.themeData(context),
          home: const SplashScreen(),
          debugShowCheckedModeBanner: false,
          routes: {
            // auth
            Routes.splashScreen: (context) => const SplashScreen(),
            Routes.loginScreen: (context) => const LoginScreen(),
            Routes.registerScreen: (context) => const RegisterScreen(),
            // main
            Routes.mainScreen: (context) => const TodoListScreen(),
            Routes.settingScreen: (context) => const SettingScreen(),
            // password
            Routes.forgetPasswordScreen: (context) =>
                const ForgetPasswordScreen(),
            Routes.verifyPasswordScreen: (context) =>
                const VerifyPasswordScreen(),
          },
        ),
      ),
    );
  }
}
