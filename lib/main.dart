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
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'amplifyconfiguration.dart';

Future<void> _configureAmplify() async {
  try {
    // Add Auth plugin
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    await Amplify.addPlugin(authPlugin);
    // Add any other plugins here

    // Configure Amplify
    // Ensure you have copied your `amplifyconfiguration.dart` content correctly
    await Amplify.configure(amplifyconfig);

    Amplify.Auth.signOut();

    print('Amplify successfully configured');
  } catch (e) {
    print('Could not configure Amplify: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await _configureAmplify();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return BlocProvider(
        create: (context) => HomeCubit(),
        child: MaterialApp(
          theme: ThemeData(textTheme: GoogleFonts.workSansTextTheme()),
          title: 'Aoun',
          debugShowCheckedModeBanner: false,
          home: LoginScreen(),
        ),
      );
    });
  }
}
