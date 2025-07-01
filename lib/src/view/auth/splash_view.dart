import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pass_key/src/blocs/auth/auth_bloc.dart';
import 'package:pass_key/src/config/routes/route_names.dart';
import 'package:pass_key/src/core/utils/enums.dart';
import 'package:pass_key/src/core/utils/utils.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    _authInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == BlocStatus.success) {
            Navigator.pushReplacementNamed(context, homeRoute);
          } else if (state.status == BlocStatus.error) {
            if (state.authMessage != '') {
              showSnackBar(context, state.authMessage);
            }
            Navigator.pushReplacementNamed(context, signInRoute);
          }
        },
        child: Center(
          child: Image.asset(
            'assets/app_logo.png',
            height: 160.0,
            width: 160.0,
          ),
        ),
      ),
    );
  }

  void _authInit() {
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        context.read<AuthBloc>().add(CheckUserLogInOrNot());
      }
    });
  }
}
