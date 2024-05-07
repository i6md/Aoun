import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:aoun_app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:aoun_app/modules/addAdv/appPost_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportPostScreen extends StatefulWidget {
  const ReportPostScreen({super.key});

  @override
  State<ReportPostScreen> createState() => _ReportPostSceenState();
}

class _ReportPostSceenState extends State<ReportPostScreen> {
  var subjectController = TextEditingController();
  var bodyController = TextEditingController();
  var dropdownValue = '';
  int? _value = 1;
  List<String> serviceTypes = ['Item', '  Event', 'Ride'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Report',
            style: GoogleFonts.readexPro(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          leading: Padding(
            padding: const EdgeInsetsDirectional.only(start: 10),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              reportText(label: 'Subject'),
              // defaultFormField(
              //     controller: subjectController,
              //     validate: (value) {
              //       if (value == null || value.isEmpty) {
              //         return 'Please enter the subject';
              //       }
              //       return null;
              //     },
              //     label: 'Subject'),
              // Generated code for this TextField Widget...
              text_field(
                subjectController: subjectController,
                label: 'e.g. Inappropriate Post',
              ),

              const SizedBox(
                height: 20,
              ),

              reportText(label: 'Service Type'),
              const SizedBox(height: 10),
              // DropdownMenu<String>(
              //   initialSelection: dropdownValue,
              //   onSelected: (String? value) {
              //     // This is called when the user selects an item.
              //     setState(() {
              //       dropdownValue = value!;
              //     });
              //   },
              //   dropdownMenuEntries: ['Items', 'Events', 'Rides']
              //       .map<DropdownMenuEntry<String>>((String value) {
              //     return DropdownMenuEntry<String>(
              //         value: value, label: value);
              //   }).toList(),
              // ),
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 25.0,
                  children: List<Widget>.generate(
                    3,
                    (int index) {
                      return ChoiceChip(
                        padding: const EdgeInsets.all(12),
                        label: Text(
                          serviceTypes[index],
                          style: GoogleFonts.readexPro(),
                        ),
                        side: const BorderSide(
                          color: Color.fromARGB(255, 224, 227, 231),
                        ),
                        selected: _value == index,
                        onSelected: (bool selected) {
                          setState(() {
                            _value = selected ? index : null;
                          });
                        },
                      );
                    },
                  ).toList(),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Please inform us with the details',
                  style: GoogleFonts.readexPro(),
                ),
              ),
              // defaultFormField(
              //   controller: bodyController,
              //   validate: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter the details';
              //     }
              //     return null;
              //   },
              //   label: 'Body',
              // ),
              text_field(
                  subjectController: bodyController, label: 'Description'),
              // const SizedBox(
              //   height: 30,
              // ),
              Spacer(),
              defaultButton(function: () {}, text: 'Send', IsUpperCase: false),
            ],
          ),
        ));
  }

  Future<void> createReport() async {
    const apiUrl =
        'https://your-backend-url/report'; // Replace with your actual backend URL
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'object_id': 'i_1234567890', // Replace with the actual object ID
      'reported_by': 'user123', // Replace with the actual user ID
    });

    try {
      final response =
          await http.post(Uri.parse(apiUrl), headers: headers, body: body);
      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final reportId = responseBody['report']['report_id'];
        final createdAt = responseBody['report']['created_at'];
        // Handle successful report creation
        print('Report created successfully. Report ID: $reportId');
      } else {
        final errorMessage = responseBody['error'];
        // Handle error scenario
        print('Error creating report: $errorMessage');
      }
    } catch (e) {
      // Handle network or other exceptions
      print('Error: $e');
    }
  }
}
