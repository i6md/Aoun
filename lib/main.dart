import 'package:aoun_app/core/app_export.dart';
import 'package:aoun_app/layout/home_layout.dart';
import 'package:aoun_app/map/map.dart';
import 'package:aoun_app/modules/login/login_screen.dart';
import 'package:aoun_app/modules/registration/Registration_screen.dart';
import 'package:aoun_app/modules/users/users_screen.dart';
import 'package:aoun_app/shared/bloc_observer.dart';
import 'package:aoun_app/shared/cubit/cubit.dart';
import 'package:aoun_app/splash_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';





void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
          return BlocProvider(
            create: (context) => HomeCubit(),
            child: MaterialApp(
              theme: ThemeData(textTheme: GoogleFonts.workSansTextTheme()),
              title: 'Aoun',
              debugShowCheckedModeBanner: false,
              home: HomeScreen(),
            ),
          );
        }
    );
  }
}