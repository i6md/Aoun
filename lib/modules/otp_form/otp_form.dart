import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;


import '../../layout/home_layout.dart';
import '../login/auth_service.dart';

class OtpForm extends StatefulWidget {
  final String email;
  final String password;


  const OtpForm({Key? key, required this.email, required this.password}) : super(key: key);

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  List<XFile?> imageFiles = [];
  List<Image> _images = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());



  void confirmSignUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        final String confirmationCode =
            _controllers.map((controller) => controller.text).join();
        final String email = widget.email;
        final String password = widget.password;

        final SignUpResult result = await Amplify.Auth.confirmSignUp(
          username: email,
          confirmationCode: confirmationCode,
        );

        if (result.isSignUpComplete) {
          print("Verification is complete");

          // Sign in the user automatically
          try {
            SignInResult signInResult = await Amplify.Auth.signIn(
              username: email,
              password: password,
            );

            if (signInResult.isSignedIn) {
              final AuthService authService = AuthService();
              final token = await authService.getToken();
              if (token != null) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                print("osama is here + $token");
                await addUserInfo(token);
                print("user added to database");
              } else {
                print("Failed to retrieve token after sign-in.");
              }
            } else {
              print("Failed to sign in.");
            }
          } catch (e) {
            print("Sign in failed: $e");
          }
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
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
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
            Text('2-Step Verification',
                style: Theme.of(context).textTheme.headlineLarge),
            SizedBox(height: 15),
            Text('Please Enter the 6-digits code that you received',
                style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(height: 80),
            Form(
              key: _formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < 6; i++) ...[
                    _buildOtpField(i),
                    if (i < 5)
                      SizedBox(width: 10), // Add spacing between the fields
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
                  child: Text('Back To Sign-in Page',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.all(15)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: confirmSignUp,
                  child: Text('Verify',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.all(15)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.indigo),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _uploadImages() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    imageFiles.add(pickedFile);

    if (pickedFile != null) {
      setState(() {
        _images.add(Image.file(File(pickedFile.path),
            width: 100, height: 100, fit: BoxFit.cover));
      });
    }
  }

  Future<void> addUserInfo(String token) async {
    var url = 'https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/add_user_info';
    var headers = {'Authorization': 'Bearer $token'};

    final requestBody = {
      'building': "Building 1",
      'room': 'room 101',
      'picture_1': {"content": "null", "extension": "null"}
      // Add other pictures as needed
    };
    // if (imageFiles.isNotEmpty) {
    //   int counter = 1;
    //   for (XFile? image in imageFiles) {
    //     List<int> imageBytes = File(image!.path).readAsBytesSync();
    //     String base64Image = base64Encode(imageBytes);
    //     //print(
    //     //    'I am heeereee\n \n I am heeereee\n \n I am heeereee\n \nI am heeereee\n \n $base64Image');
    //     requestBody["picture_$counter"] = {
    //       "content": base64Image,
    //       "extension": p.extension(image.path).substring(1)
    //     };
    //     //Object? test1 = requestBody;
    //     //print('$requestBody["picture_$counter"]\n\n\n\n\n heeeree');
    //     //print('$test1');
    //     counter++;
    //   }
    // } else {
    //   requestBody.remove('picture_1');
    // }
    // Object? test1 = requestBody;
    // print('$test1');


    // var body = jsonEncode({
    //   "building": "Building 1",
    //   "room": "Room 101",
    //   "pic": {
    //     "content": "C:\Users\ommor\OneDrive\Desktop\plain-green-wall.jpg",
    //     "extension": "jpg"
    //   }
    // });

    var response = await http.post(Uri.parse(url), headers: headers, body: json.encode(requestBody));

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      print(responseBody); // Handle the successful responsee
    } else {
      throw Exception('Failed to add user info: ${response.body}');
    }
  }
}
