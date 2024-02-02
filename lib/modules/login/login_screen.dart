import 'package:aoun_app/modules/registration/Registration_screen.dart';
import 'package:aoun_app/shared/components/components.dart';
import 'package:flutter/material.dart';

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
        title: const Text(
          'Aoun',
          style: TextStyle(
            fontSize: 30.0,
            color: Colors.white,
          ),
        ),

        backgroundColor: Colors.blue.withOpacity(0.8),
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
                    'Login',
                    style: TextStyle(
                      fontSize: 40.0,
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
                        if(formkey.currentState!.validate()){
                          print(emailController);
                          print(passwordController);
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
                              fontSize: 20.0,
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
}
