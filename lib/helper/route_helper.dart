import 'package:flutter/material.dart';

class  RouteHelper {
  static const String initial = '/taskListScreen';
  static const String taskListScreen = '/taskListScreen';
  static const String taskAddScreen = '/taskAddScreen';


  static String getInitialRoute() => initial;
  static String getTaskListRoute() => taskListScreen;
  static String getTaskAddRoute() => taskAddScreen;


  static PageRouteBuilder _buildRoute(
      Widget page, {
        RouteTransitionsBuilder? transition,
      }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: transition ??
              (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
    );
  }


  static Future<T?> pushNamed<T>(
      BuildContext context, {
        required String routeName,
        Object? arguments,
      }) {
    return Navigator.of(context).pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  static Future<T?> pushReplacementNamed<T>(
      BuildContext context, {
        required String routeName,
        Object? arguments,
      }) {
    return Navigator.of(context).pushReplacementNamed<T, T>(
      routeName,
      arguments: arguments,
    );
  }

  static Future<T?> offAllNamed<T>(
      BuildContext context, {
        required String routeName,
        Object? arguments,
      }) {
    return Navigator.of(context).pushNamedAndRemoveUntil<T>(
      routeName,
          (route) => false,
      arguments: arguments,
    );
  }

}
