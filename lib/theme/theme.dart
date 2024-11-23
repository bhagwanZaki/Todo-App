import 'package:flutter/material.dart';
import 'package:todo/theme/app_color.dart';

class AppTheme {
  static OutlineInputBorder darkTextFieldBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColor.textInput),
    );
  }

  static ThemeData themeData(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Spartan',
      scaffoldBackgroundColor: AppColor.black,
      actionIconTheme: ActionIconThemeData(
        backButtonIconBuilder: (context) => const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColor.black,
        titleSpacing: 0,
        titleTextStyle: TextStyle(
          fontSize: 20,
          color: AppColor.white,
          fontFamily: 'Spartan',
        ),
      ),
      cardTheme: CardTheme(
        color: AppColor.card,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        backgroundColor: AppColor.card,
      ),
      textTheme: Theme.of(context).textTheme.apply(
            fontFamily: 'Spartan',
            displayColor: AppColor.white,
            bodyColor: AppColor.white,
            decorationColor: AppColor.grey,
          ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        errorStyle: const TextStyle(
            fontSize: 10, color: AppColor.red, fontFamily: 'Spartan'),
        enabledBorder: darkTextFieldBorder(),
        focusedBorder: darkTextFieldBorder(),
        fillColor: AppColor.textInput,
        filled: true,
        hintStyle: const TextStyle(
          fontFamily: 'Spartan',
          color: AppColor.white40,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      iconTheme: const IconThemeData(color: AppColor.white),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(AppColor.white),
          iconColor: WidgetStateProperty.all(AppColor.white),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 10,
            ),
          ),
          elevation: WidgetStateProperty.all(0),
          shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          backgroundColor: WidgetStateProperty.all(AppColor.blue),
          foregroundColor: WidgetStateProperty.all(AppColor.black),
          textStyle: WidgetStateProperty.all(
            const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w400,
              fontFamily: 'Spartan',
            ),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(AppColor.white),
      )),
      dialogTheme: DialogTheme(
        backgroundColor: AppColor.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 24,
          fontFamily: 'Spartan',
        ),
      ),
      useMaterial3: true,
    );
  }
}
