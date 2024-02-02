import 'package:flutter/material.dart';
import 'package:aoun_app/Registration_screen.dart';
import 'package:aoun_app/login_screen.dart';




void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }

}