import 'package:aoun_app/modules/login/login_screen.dart';
import 'package:aoun_app/shared/components/components.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({super.key});
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var FnameController = TextEditingController();
  var LnameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                TextFormField(
                  controller: FnameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    prefixIcon: Icon(
                      Icons.edit,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.name,
                  onFieldSubmitted: (value){
                    print(value);
                  },
                  onChanged: (value){
                    print(value);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: LnameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    prefixIcon: Icon(
                      Icons.edit,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.name,
                  onFieldSubmitted: (value){
                    print(value);
                  },
                  onChanged: (value){
                    print(value);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(
                      Icons.email,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onFieldSubmitted: (value){
                    print(value);
                  },
                  onChanged: (value){
                    print(value);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(
                      Icons.phone,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  onFieldSubmitted: (value){
                    print(value);
                  },
                  onChanged: (value){
                    print(value);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(
                      Icons.lock,
                    ),
                    suffixIcon: Icon(
                        Icons.remove_red_eye
                    ),

                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  onFieldSubmitted: (value){
                    print(value);
                  },
                  onChanged: (value){
                    print(value);
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                defaultButton(
                    function: (){
                      print(FnameController);
                      print(LnameController);
                      print(emailController);
                      print(passwordController);
                      print(phoneController);
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
    );
  }
}
