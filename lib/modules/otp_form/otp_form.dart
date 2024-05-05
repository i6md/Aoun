import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import '../../layout/home_layout.dart';

class OtpForm extends StatefulWidget {
  final String email;

  const OtpForm({Key? key, required this.email}) : super(key: key);

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());

  void confirmSignUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        final String confirmationCode = _controllers.map((controller) => controller.text).join();
        final String email = widget.email;

        final SignUpResult result = await Amplify.Auth.confirmSignUp(
          username: email,
          confirmationCode: confirmationCode,
        );

        if (result.isSignUpComplete) {
          print("Verification is complete");
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          print('Sign-up confirmation not complete, additional steps required');
        }
      } catch (e) {
        print('Error confirming sign-up: $e');
      }
    }
  }

  Widget _buildOtpField(int index) {
    return SizedBox(
      height: 68,
      width: 50,
      child: TextFormField(
        controller: _controllers[index],
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: "0",
        ),
        style: Theme.of(context).textTheme.titleLarge,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return ' ';
          }
          return null;
        },
        onChanged: (value) {
          if (value.length == 1) {
            if (index < 5) FocusScope.of(context).nextFocus();
          } else {
            if (index > 0) FocusScope.of(context).previousFocus();
          }
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }

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
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text('2-Step Verification', style: Theme.of(context).textTheme.headlineLarge),
            SizedBox(height: 15),
            Text('Please Enter the 6-digits code that you received', style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(height: 80),
            Form(
              key: _formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < 6; i++) ...[
                    _buildOtpField(i),
                    if (i < 5) SizedBox(width: 10), // Add spacing between the fields
                  ]
                ],
              ),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Back To Sign-in Page', style: TextStyle(color: Colors.white, fontSize: 20)),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(15)),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: confirmSignUp,
                  child: Text('Verify', style: TextStyle(color: Colors.white, fontSize: 20)),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(15)),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
