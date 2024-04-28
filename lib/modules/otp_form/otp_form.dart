import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../layout/home_layout.dart';

class OtpForm extends StatelessWidget {

  const OtpForm({Key? key}): super(key: key);

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
        padding: const EdgeInsets.all(10.0),
        child: Column(

          children: [
            Text('2-Step Verification', style: Theme.of(context).textTheme.headlineLarge),
            SizedBox(height: 15),
            Text('Please Enter the 4-digits code that you received', style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(height: 80),
            Form(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 68,
                      width: 64,
                    child : TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "0",
                      ),
                      style: Theme.of(context).textTheme.titleLarge,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,

                      ],
                    )
                  ),
                  SizedBox(width: 10,),
                  SizedBox(
                      height: 68,
                      width: 64,
                      child : TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "0",
                        ),
                        style: Theme.of(context).textTheme.titleLarge,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,

                        ],
                      )
                  ),
                  SizedBox(width: 10,),
                  SizedBox(
                      height: 68,
                      width: 64,
                      child : TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "0",
                        ),
                        style: Theme.of(context).textTheme.titleLarge,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,

                        ],
                      )
                  ),
                  SizedBox(width: 10,),
                  SizedBox(
                      height: 68,
                      width: 64,
                      child : TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "0",
                        ),
                        style: Theme.of(context).textTheme.titleLarge,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,

                        ],
                      )
                  ),
                ],
              ),

            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButtonTheme(data: TextButtonThemeData(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(15)),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )),
                    ),
                
                ),
                  child: TextButton(
                    onPressed: () {
                      // Verify OTP
                      Navigator.pop(context);
                    },
                    child: Text('Back To Sign-in Page', style: TextStyle( color: Colors.white , fontSize: 20)),
                  ),
                ),
                TextButtonTheme(data: TextButtonThemeData(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(15)),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
                  ),

                ),
                  child: TextButton(
                    onPressed: () {
                      // Verify OTP
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                    },
                    child: Text('Verify', style: TextStyle( color: Colors.white , fontSize: 20)),
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

 // The  OtpForm  widget is a stateless widget that takes two parameters:  phoneNumber  and  onOtpVerified . The  phoneNumber  is the phone number to which the OTP was sent, and the  onOtpVerified  is a callback function that will be called when the OTP is verified.
 // The  OtpForm  widget contains a  Form  widget with a  Column  widget as its child. The  Column  widget contains a  Text  widget that displays the phone number and a  PinCodeTextField  widget that allows the user to enter the OTP.
 // The  PinCodeTextField  widget is a custom widget that we will create in the next step.
 // Step 3: Create a PinCodeTextField widget
 // The  PinCodeTextField  widget is a custom widget that allows the user to enter a 6-digit OTP.
 // Create a new file named  pin_code_text_field.dart  inside the  lib/widgets  directory and add the following code:
 // Path: lib/widgets/pin_code_text_field.dart