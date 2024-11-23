import 'package:flutter/material.dart';

class Common {
  static String weekDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Sunday';
      case 2:
        return 'Monday';
      case 3:
        return 'Tuesday';
      case 4:
        return 'Wednesday';
      case 5:
        return 'Thrusday';
      case 6:
        return 'Friday';
      case 7:
        return 'Saturday';
      default:
        throw Exception('Invalid Date');
    }
  }

  static String monthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        throw Exception('Invalid Month');
    }
  }

    static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 960.0;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 640.0;
  }

  static PageRouteBuilder<dynamic> pageRouteBuilder(Widget navPage) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => navPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
