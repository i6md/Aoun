import 'package:aoun_app/layout/home_layout.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:aoun_app/modules/login/login_screen.dart';
import 'package:aoun_app/modules/registration/Registration_screen.dart';
import 'package:aoun_app/modules/users/users_screen.dart';
import 'package:aoun_app/splash_screen.dart';
import 'package:flutter/material.dart';
import 'amplifyconfiguration.dart';



void _configureAmplify() async {
  try {
    // Add Auth plugin
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    await Amplify.addPlugin(authPlugin);
    // Add any other plugins here

    // Configure Amplify
    // Ensure you have copied your `amplifyconfiguration.dart` content correctly
    await Amplify.configure(amplifyconfig);

    print('Amplify successfully configured');
  } catch (e) {
    print('Could not configure Amplify: $e');
  }
}



void main(){

  WidgetsFlutterBinding.ensureInitialized();
  _configureAmplify();
  runApp(const MyApp());
}

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