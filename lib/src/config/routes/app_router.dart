import 'package:flutter/material.dart';
import 'package:pass_key/src/config/routes/route_names.dart';
import 'package:pass_key/src/core/constants/strings.dart';
import 'package:pass_key/src/view/auth/signin_view.dart';
import 'package:pass_key/src/view/auth/signup_view.dart';
import 'package:pass_key/src/view/auth/splash_view.dart';
import 'package:pass_key/src/view/home/home_view.dart';
import 'package:pass_key/src/view/settings/settings_view.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute:
        return _slideFromRight(SplashView());
      case signInRoute:
        return _slideFromRight(SigninView());
      case signUpRoute:
        return _slideFromRight(SignupView());
      case homeRoute:
        return _slideFromRight(HomeView());
      case settingsRoute:
        return _slideFromRight(SettingsView());
      default:
        return _errorRoute();
    }
  }

  static Route _slideFromRight(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.ease));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder:
          (_) => Scaffold(
            body: Center(child: Text(routeNotFound)),
          ),
    );
  }
}
