import 'package:aoun_app/layout/home_layout.dart';
import 'package:aoun_app/modules/login/login_screen.dart';
import 'package:aoun_app/modules/otp_form/otp_form.dart';
import 'package:aoun_app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final RegExp kfupmEmailRegex =
      RegExp(r'^[sg]\d{9}@kfupm\.edu\.sa$', caseSensitive: false);

  final RegExp passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$');

  final RegExp nameRegex = RegExp(r'^[a-zA-Z\- ]+$');

  final RegExp saudiPhoneNumberRegex = RegExp(r'^\+9665[05679]\d{7}$');

  var formkey = GlobalKey<FormState>();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var phoneController = TextEditingController();

  var fnameController = TextEditingController();

  var lnameController = TextEditingController();

  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
        automaticallyImplyLeading: false,
        title: Text('Aoun',
            style: GoogleFonts.lato(
                textStyle: TextStyle(
              color: Colors.indigo,
              fontSize: 25.0,
              fontWeight: FontWeight.w700,
            ))),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hello! Register to get started',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    defaultFormField(
                      controller: fnameController,
                      type: TextInputType.name,
                      validate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        } else if (!nameRegex.hasMatch(value)) {
                          return 'Invalid characters in name.\nOnly letters, spaces, and hyphens are allowed.';
                        }
                      },
                      label: 'First Name',
                      prefix: Icons.edit,
                      onChange: (value) {
                        print(value);
                      },
                      onSubmit: (value) {
                        print(value);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                      controller: lnameController,
                      type: TextInputType.name,
                      validate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        } else if (!nameRegex.hasMatch(value)) {
                          return 'Invalid characters in name.\nOnly letters, spaces, and hyphens are allowed.';
                        }
                      },
                      label: 'Last Name',
                      prefix: Icons.edit,
                      onChange: (value) {
                        print(value);
                      },
                      onSubmit: (value) {
                        print(value);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!kfupmEmailRegex.hasMatch(value)) {
                            return 'Invalid KFUPM email format';
                          }
                          return null;
                        },
                        label: 'Email Address',
                        prefix: Icons.email,
                        onChange: (value) {
                          print(value);
                        },
                        onSubmit: (value) {
                          print(value);
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                      controller: phoneController,
                      type: TextInputType.phone,
                      validate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone number is required';
                        }
                        if (!saudiPhoneNumberRegex.hasMatch(value)) {
                          return 'Invalid Saudi Arabian phone number';
                        }

                        return null; // Return null for valid input
                      },
                      label: 'Phone Number',
                      prefix: Icons.phone,
                      onChange: (value) {
                        print(value);
                      },
                      onSubmit: (value) {
                        print(value);
                      },
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
                          } else if (!passwordRegex.hasMatch(value)) {
                            return 'Password must be at least 8 characters\n'
                                'long and include at least one uppercase letter'
                                ',\none lowercase letter, and one digit.';
                          }
                        },
                        label: 'Password',
                        prefix: Icons.lock,
                        secureText: isPassword,
                        suffix: isPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        onSubmit: (value) {
                          print(value);
                        },
                        onChange: (value) {
                          print(value);
                        },
                        suffixPressed: () {
                          setState(() {
                            isPassword = !isPassword;
                          });
                        }),
                    const SizedBox(
                      height: 20.0,
                    ),
                    defaultButton(
                        // function: (){
                        //   if(formkey.currentState!.validate()) {
                        //     print(fnameController);
                        //     print(lnameController);
                        //     print(emailController);
                        //     print(passwordController);
                        //     print(phoneController);
                        //   }
                        // },
                        function: registerUser,
                        text: 'registration',
                        IsUpperCase: true),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Do you have an account?',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: const Text(
                            'Login Now',
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
      ),
    );
  }

  void registerUser() async {
    if (formkey.currentState!.validate()) {
      try {
        Map<CognitoUserAttributeKey, String> userAttributes = {
          CognitoUserAttributeKey.email: emailController.text,
          CognitoUserAttributeKey.phoneNumber:
              phoneController.text, // Ensure this follows the E.164 format
          // CognitoUserAttributeKey.givenName: fnameController.text,
          // CognitoUserAttributeKey.familyName: lnameController.text,
          CognitoUserAttributeKey.name:
              "${fnameController.text} ${lnameController.text}",
          // Add other attributes here
        };
        final SignUpResult result = await Amplify.Auth.signUp(
          username: emailController.text,
          password: passwordController.text,
          options: SignUpOptions(userAttributes: userAttributes),
        );
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OtpForm(email: emailController.text)));
        // if (result.isSignUpComplete) {
        //   Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
        // } else {
        //   // Handle next steps based on result.nextStep
        //   print("Sign up not complete, additional steps required ${result.nextStep.signUpStep}");
        //   print("Sign up not complete, additional steps required ${result.nextStep}");
        //   print("Additional info: ${result.nextStep.additionalInfo}"); // This might contain useful info
        //   print("Code delivery details: ${result.nextStep.codeDeliveryDetails}"); // This tells you how the code was sent
        // }
      } catch (e) {
        print(e);
        // Handle sign up error
      }
    }
  }
}
