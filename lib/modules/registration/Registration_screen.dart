import 'package:aoun_app/modules/login/login_screen.dart';
import 'package:aoun_app/shared/components/components.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final RegExp kfupmEmailRegex = RegExp(r'^[sg]\d{9}@kfupm\.edu\.sa$', caseSensitive: false);

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
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Registration',
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    defaultFormField(
                        controller: fnameController,
                        type: TextInputType.name,
                        validate: (value){
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          else if (!nameRegex.hasMatch(value)) {
                            return 'Invalid characters in name.\nOnly letters, spaces, and hyphens are allowed.';
                          }

                        },
                        label: 'First Name',
                        prefix: Icons.edit,
                        onChange: (value){
                          print(value);
                        },
                      onSubmit: (value){
                        print(value);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                      controller: lnameController,
                      type: TextInputType.name,
                      validate: (value){
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        else if (!nameRegex.hasMatch(value)) {
                          return 'Invalid characters in name.\nOnly letters, spaces, and hyphens are allowed.';
                        }

                      },
                      label: 'Last Name',
                      prefix: Icons.edit,
                      onChange: (value){
                        print(value);
                      },
                      onSubmit: (value){
                        print(value);
                      },
                    ),
                    const SizedBox(
                      height: 10,
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
                        controller: phoneController,
                        type: TextInputType.phone,
                        validate: (value){
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
                      onChange: (value){
                        print(value);
                      },
                      onSubmit: (value){
                        print(value);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                      controller: passwordController,
                      type: TextInputType.visiblePassword,
                      validate: (value){
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Password';
                        }
                        else if (!passwordRegex.hasMatch(value)) {
                          return 'Password must be at least 8 characters\n'
                              'long and include at least one uppercase letter'
                              ',\none lowercase letter, and one digit.';
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
                      suffixPressed: (){
                        setState(() {
                          isPassword = !isPassword;
                        });
                      }

                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    defaultButton(
                        function: (){
                          if(formkey.currentState!.validate()) {
                            print(fnameController);
                            print(lnameController);
                            print(emailController);
                            print(passwordController);
                            print(phoneController);
                          }
                        },
                        text: 'registration',
                        IsUpperCase: true
                    ),
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
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                          },
                          child: const Text(
                            'Login Now',
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
      ),
    );
  }
}
