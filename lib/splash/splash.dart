import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';


class Splash extends StatefulWidget {
  final String title;
  const Splash({Key? key, this.title = "Splash"}) : super(key: key);
  @override
  SplashViewState createState() => SplashViewState();
}

class SplashViewState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthBloc>(context).add(
      VerifyCurrentToken(),
    );
  }


  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AuthBloc, AuthState>(builder: (context, state) {
     return Scaffold(
        body: Image(
          fit: BoxFit.cover,
          image: AssetImage('images/splash.png'),
          height: double.infinity,
          width: double.infinity,
        ),
      );
    }, listener: (context, state) async {

      log("splash" + state.toString());
      if (state is UnAuthenticated) {
        Timer(const Duration(seconds: 1), () => Navigator.pushReplacementNamed(context, "/signin"));
      }
      if (state is Authenticated) {
        RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

        if (initialMessage != null) {
          Timer(const Duration(seconds: 1), () =>  Navigator.pushReplacementNamed(context, "/dashboard", arguments: {"hasAlerts": true}));
        } else {
          Timer(const Duration(seconds: 1), () =>  Navigator.pushReplacementNamed(context, "/dashboard", arguments: {"hasAlerts": false}));
        }

      }
    });
  }
}
