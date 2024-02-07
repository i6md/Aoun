import 'package:aoun_app/layout/home_layout.dart';
import 'package:aoun_app/modules/login/login_screen.dart';
import 'package:aoun_app/modules/registration/Registration_screen.dart';
import 'package:aoun_app/modules/users/users_screen.dart';
import 'package:aoun_app/splash_screen.dart';
import 'package:flutter/material.dart';





void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }

}