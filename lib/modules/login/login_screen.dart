import 'package:aoun_app/layout/home_layout.dart';
import 'package:aoun_app/modules/otp_form/otp_form.dart';
import 'package:aoun_app/modules/registration/Registration_screen.dart';
import 'package:aoun_app/shared/components/components.dart';
import 'package:aoun_app/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import 'auth_service.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final RegExp kfupmEmailRegex = RegExp(r'^[sg]\d{9}@kfupm\.edu\.sa$', caseSensitive: false);

  var formkey = GlobalKey<FormState>();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))
        ),
        automaticallyImplyLeading: false,
        title: Text(
            'Aoun',
            style: GoogleFonts.lato(
                textStyle: TextStyle(
                  color: Colors.indigo,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w700,
                )
            )
        ),
        centerTitle: true,

        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back!\nGlad to see you again!',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  defaultFormField(
                      controller: emailController,
                      type: TextInputType.emailAddress,
                      validate: (value){
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!kfupmEmailRegex.hasMatch(value)) {
                          return 'Invalid KFUPM email format';
                        }
                        return null;
                      },
                      label: 'Email Address',
                      prefix: Icons.email,
                      onChange: (value){
                        print(value);
                      },
                      onSubmit: (value){
                        print(value);
                      }
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  defaultFormField(
                      controller: passwordController,
                      type: TextInputType.visiblePassword,
                      validate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Password';
                        }
                      },
                      label: 'Password',
                      prefix: Icons.lock,
                      secureText: isPassword,
                      suffix: isPassword? Icons.visibility : Icons.visibility_off,
                      onSubmit: (value){
                            print(value);
                             },
                      onChange: (value){
                        print(value);
                      },
                      suffixPressed:(){
                        setState(() {
                          isPassword=!isPassword;
                        });
                      } ,

                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  defaultButton(
                      text: 'login',
                    function: () {
                      if (formkey.currentState!.validate()) {
                        signInUser();
                      }
                    }, IsUpperCase: true,


                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>RegistrationScreen()));
                          },
                          child: const Text(
                            'Register Now',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signInUser() async {
    if (formkey.currentState!.validate()) {
      print(emailController.text.trim());
      print(passwordController.text.trim());

      try {
        SignInResult signInResult = await Amplify.Auth.signIn(
          username: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        if (signInResult.isSignedIn) {
          getToken();  // remove after testing
          print('User signed in');


          // // Retrieve the current auth session
          // AuthSession authSession = await Amplify.Auth.fetchAuthSession(options: CognitoSessionOptions(getAWSCredentials: true));
          //
          // // Check if the session is a Cognito Auth Session and print the ID Token
          // if (authSession is CognitoAuthSession && authSession.isSignedIn) {
          //   print('ID Token: ${authSession.userPoolTokens?.idToken}');
          // }



          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
          // Navigate to your desired screen upon successful sign-in
        } else {
          print('User could not be signed in');
        }
      } on AuthException catch (e) {
        print(e.message);
        // Handle authentication errors here
      }
    }
  }


  // use this function in the needed classes to get the idToken (by calling it. line: 180) to use in the request header
  // dont forget to add "import auth_service.dart"
  void getToken() async {
    // Create an instance of AuthService
    final AuthService authService = AuthService();
    // Call the getIdToken method
    var idToken = await authService.refreshIdToken();

    if (idToken != null) {

      print(idToken);

      // var headers = {
      //   'Authorization': 'Bearer $idToken',
      // };


      // Use the headers in your backend request
    } else {
      print("token not available");
      Amplify.Auth.signOut();
      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
      // Handle the scenario where the token is not available
    }
  }


}

