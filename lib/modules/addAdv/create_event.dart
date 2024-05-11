import 'dart:convert';

import 'package:aoun_app/layout/home_layout.dart';
import 'package:aoun_app/modules/login/auth_service.dart';
import 'package:aoun_app/shared/components/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  List<String> postType = ['Offer', 'Request'];
  var iselected = 0;
  // var backColor = Colors.white;
  // var textColor = Colors.black;
  var ofSelected = false;
  var reSelected = false;

  var dropdownValueS = '';
  var dropdownValueR = '';
  var isSelected = false;
  var resValue = 'Student Clubs';
  // List<XFile>? images = [];
  // List<File> _images = [];
  List<Image> _images = [];
  List<XFile?> imageFiles = [];
  var absorb = false;
  var allFieldsFilled = true;
  Color addPhotoColor = Color.fromARGB(255, 3, 50, 71);

  final List<String> sList = ['Student Clubs', 'Sports', 'Gatherings'];

  TextEditingController titleContoller = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  TextEditingController fromdateController = TextEditingController();
  TextEditingController todateController = TextEditingController();
  TextEditingController nofpartController = TextEditingController();
  TextEditingController roomController = TextEditingController();

  var categoryValue = 'Event';

  bool _checkFields() {
    if ((reSelected || ofSelected) &&
        titleContoller.text.isNotEmpty &&
        placeController.text.isNotEmpty &&
        bodyController.text.isNotEmpty &&
        fromdateController.text.isNotEmpty &&
        todateController.text.isNotEmpty &&
        nofpartController.text.isNotEmpty &&
        roomController.text.isNotEmpty) {
      setState(() {
        allFieldsFilled = true;
        print(allFieldsFilled);
      });
    } else {
      setState(() {
        allFieldsFilled = false;
        print(allFieldsFilled);
      });
    }
    return allFieldsFilled;
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

  Future<void> addEvent(
      TextEditingController? titleContoller,
      TextEditingController? placeController,
      TextEditingController? bodyController,
      TextEditingController? fromdateController,
      TextEditingController? todateController,
      TextEditingController? nofpartController,
      TextEditingController? roomController,
      List<XFile?> images,
      String category) async {
    String apiUrl =
        'https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/add_event';
    AuthService authService = AuthService();
    var token = await authService.getToken();
    //print('hello this is asem');

    String? titleText = titleContoller?.text;
    String? placeText = placeController?.text;
    String? bodyText = bodyController?.text;
    DateTime? fromdateText = DateTime.parse(fromdateController!.text);
    DateTime? todateText = DateTime.parse(todateController!.text);
    String? nofpartText = nofpartController?.text;
    String? roomText = roomController?.text;
    //final List<String> sList = ['Student Clubs', 'Sports', 'Gatherings'];

    print('this is text1 $titleText text2 $placeText text3 $bodyText');
    final requestHeaders = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    };
    final requestBody = {
      'building': placeText,
      'title': titleText,
      'category': category,
      'description': bodyText,
      'start_date_time': DateFormat('yyyy-MM-ddTHH:mm:ss').format(fromdateText),
      'end_date_time': DateFormat('yyyy-MM-ddTHH:mm:ss').format(todateText),
      'room': roomText,
      'participants_number': nofpartText,
      'picture_1': {"content": "null", "extension": "null"}
      // Add other pictures as needed
    };
    if (imageFiles.isNotEmpty) {
      int counter = 1;
      for (XFile? image in imageFiles) {
        List<int> imageBytes = File(image!.path).readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        //print(
        //    'I am heeereee\n \n I am heeereee\n \n I am heeereee\n \nI am heeereee\n \n $base64Image');
        requestBody["picture_$counter"] = {
          "content": base64Image,
          "extension": p.extension(image.path).substring(1)
        };
        //Object? test1 = requestBody;
        //print('$requestBody["picture_$counter"]\n\n\n\n\n heeeree');
        //print('$test1');
        counter++;
      }
    } else {
      requestBody.remove('picture_1');
    }
    Object? test1 = requestBody;
    //print('$requestBody["picture_$counter"]\n\n\n\n\n heeeree');
    print('$test1');

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: requestHeaders,
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final eventId = responseData['event']['event_id'];
      final createdAt = responseData['event']['created_at'];
      final eventType = responseData['event']['category'];
      print(
          'Event created successfully with ID $eventId at $createdAt with event type: $eventType');

      // Show success message to user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event created successfully!'),
        ),
      );

      // Navigate to items screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      print(
          'Error creating event. Status code: ${response.statusCode}, Response: ${response.body}');

      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Event could not be created: ${response.body}'),
        ),
      );
    }
  }

  // void dateTimePickerWidget(
  //     BuildContext context, TextEditingController controller) {
  //   picker.DatePicker.showDateTimePicker(context,
  //       showTitleActions: true,
  //       minTime: DateTime.now(),
  //       maxTime: DateTime(2025, 6, 7),
  //       theme: picker.DatePickerTheme(
  //           headerColor: Color.fromARGB(255, 3, 50, 71),
  //           backgroundColor: Colors.white,
  //           itemStyle: TextStyle(
  //               color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
  //           doneStyle: TextStyle(color: Colors.white, fontSize: 16),
  //           cancelStyle: TextStyle(color: Colors.white, fontSize: 16)),
  //       onChanged: (date) {
  //     print('change $date in time zone ' +
  //         date.timeZoneOffset.inHours.toString());
  //   }, onConfirm: (date) {
  //     String formattedDate = DateFormat('yyyy-MM-dd').format(date);
  //     String formattedTime = DateFormat('HH:mm').format(date);
  //     controller.text = '$formattedDate $formattedTime';
  //   }, currentTime: DateTime.now(), locale: picker.LocaleType.en);
  // }

  void dateTimeWidget(
      BuildContext context,
      TextEditingController fromDateController,
      TextEditingController toDateController) {
    picker.DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime(2025, 6, 7),
        theme: picker.DatePickerTheme(
            headerColor: Color.fromARGB(255, 3, 50, 71),
            backgroundColor: Colors.white,
            itemStyle: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            doneStyle: TextStyle(color: Colors.white, fontSize: 16),
            cancelStyle: TextStyle(color: Colors.white, fontSize: 16)),
        onChanged: (date) {
      print('change $date in time zone ' +
          date.timeZoneOffset.inHours.toString());
    }, onConfirm: (date) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      String formattedTime = DateFormat('HH:mm').format(date);
      fromdateController.text =
          '$formattedDate $formattedTime'; // Set the selected date to the 'from date' field

      // Set the minimum time for the 'to date' picker
      picker.DatePicker.showDateTimePicker(context,
          showTitleActions: true,
          minTime:
              date, // Set the minimum time to the selected date from the 'from date' picker
          maxTime: DateTime(2025, 6, 7),
          theme: picker.DatePickerTheme(
              headerColor: Color.fromARGB(255, 3, 50, 71),
              backgroundColor: Colors.white,
              itemStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              doneStyle: TextStyle(color: Colors.white, fontSize: 16),
              cancelStyle: TextStyle(color: Colors.white, fontSize: 16)),
          onChanged: (toDate) {
        print('change $toDate in time zone ' +
            toDate.timeZoneOffset.inHours.toString());
      }, onConfirm: (toDate) {
        String formattedToDate = DateFormat('yyyy-MM-dd').format(toDate);
        String formattedToTime = DateFormat('HH:mm').format(toDate);
        toDateController.text = '$formattedToDate $formattedToTime';
        // Set the selected date to the 'to date' field
      }, currentTime: date, locale: picker.LocaleType.en);
    }, currentTime: DateTime.now(), locale: picker.LocaleType.en);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Post Type',
                  style: GoogleFonts.readexPro(fontSize: 15),
                ),
                const SizedBox(
                  width: 50,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      ofSelected = true;
                      reSelected = false;
                    });
                  },
                  child: Container(
                    // width: 300,
                    // height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromARGB(255, 224, 227, 231),
                      ),
                      borderRadius: BorderRadius.circular(35),
                      color: ofSelected
                          ? Color.fromARGB(255, 3, 50, 71)
                          : Colors.white,
                    ),
                    padding: EdgeInsets.all(20),
                    // margin: EdgeInsets.all(20),
                    child: Text(
                      'Offer',
                      style: GoogleFonts.readexPro(
                        color: ofSelected ? Colors.white : Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                    onTap: () {
                      setState(() {
                        reSelected = true;
                        ofSelected = false;
                      });
                    },
                    child: Container(
                      // width: 300,
                      // height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromARGB(255, 224, 227, 231),
                        ),
                        borderRadius: BorderRadius.circular(35),
                        color: reSelected
                            ? Color.fromARGB(255, 3, 50, 71)
                            : Colors.white,
                      ),
                      padding: EdgeInsets.all(20),
                      // margin: EdgeInsets.all(20),
                      child: Text(
                        'Request',
                        style: GoogleFonts.readexPro(
                          color: reSelected ? Colors.white : Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    )),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: AlignmentDirectional(-1, 0),
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      _images.clear();
                    });
                  },
                  child: const Text(
                    'Reset Pictures',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  )),
            ),
            // const SizedBox(
            //   height: 5,
            // ),
            Align(
              alignment: AlignmentDirectional(-1, 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(mainAxisSize: MainAxisSize.max, children: [
                  AbsorbPointer(
                    absorbing: absorb,
                    child: InkWell(
                      // onTap: _pickImage,
                      onTap: _uploadImages,
                      child: Container(
                          // width: 300,
                          // height: 150,

                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color.fromARGB(255, 224, 227, 231),
                            ),
                            borderRadius: BorderRadius.circular(15),
                            color: addPhotoColor,
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 30, horizontal: 10),
                          // margin: EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add_outlined,
                                size: 20,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Add Photo',
                                style: GoogleFonts.readexPro(
                                    fontSize: 10, color: Colors.white),
                              )
                            ],
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),

                  // Row(
                  //   children: _images!
                  //       .map((image) => Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Image.network(
                  //               image.name,
                  //               height: 50,
                  //               width: 50,
                  //               fit: BoxFit.cover,
                  //             ),
                  //           ))
                  //       .toList(),
                  // ),
                  // Expanded(
                  //   child: ListView.builder(
                  //     itemCount: _images.length,
                  //     scrollDirection: Axis.horizontal,
                  //     itemBuilder: (context, index) {
                  //       return Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: _images[index],
                  //       );
                  //     },
                  //   ),
                  // ),
                  Wrap(
                    spacing: 10.0,
                    children: List<Widget>.generate(
                      _images.length,
                      (int index) {
                        return _images[index];
                      },
                    ).toList(),
                  ),
                  // Expanded(
                  //   child: ListView.builder(
                  //     itemCount: _images.length,
                  //     scrollDirection: Axis.horizontal,
                  //     itemBuilder: (context, index) {
                  //       return Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Image.file(
                  //           _images[index],
                  //           width: 100,
                  //           height: 100,
                  //           fit: BoxFit.cover,
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(8),
                  //   child: Image.network(
                  //     'https://picsum.photos/seed/634/600',
                  //     width: 80,
                  //     height: 80,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  // const SizedBox(width: 20),
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(8),
                  //   child: Image.network(
                  //     'https://picsum.photos/seed/634/600',
                  //     width: 80,
                  //     height: 80,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                ]),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Align(
              alignment: AlignmentDirectional(-1, 0),
              child: Text(
                'Title',
                style: GoogleFonts.readexPro(fontSize: 15),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Align(
              alignment: AlignmentDirectional(-1, 0),
              child: Container(
                width: 350,
                child: TextFormField(
                  controller: titleContoller,
                  autofocus: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'e.g. Groceries',
                    labelStyle:
                        GoogleFonts.readexPro(color: Colors.grey, fontSize: 12),
                    hintStyle: GoogleFonts.readexPro(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 224, 227, 231),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 75, 57, 239),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                  ),
                  style: const TextStyle(color: Colors.black),
                  // validator: _model.titleContollerValidator
                  //     .asValidator(context),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Align(
              alignment: AlignmentDirectional(-1, 0),
              child: Text(
                'Place',
                style: GoogleFonts.readexPro(fontSize: 15),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Align(
              alignment: AlignmentDirectional(-1, 0),
              child: Container(
                width: 350,
                child: TextFormField(
                  controller: placeController,
                  // focusNode: _model.textFieldFocusNode2,
                  autofocus: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'e.g. 839',
                    labelStyle:
                        GoogleFonts.readexPro(color: Colors.grey, fontSize: 12),
                    // hintStyle: FlutterFlowTheme.of(context).labelMedium,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 224, 227, 231),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 75, 57, 239),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                  ),
                  style: const TextStyle(color: Colors.black),
                  //   validator: _model.placeControllerValidator
                  //       .asValidator(context),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Align(
              alignment: AlignmentDirectional(-1, 0),
              child: Text(
                'Room',
                style: GoogleFonts.readexPro(fontSize: 15),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Align(
              alignment: AlignmentDirectional(-1, 0),
              child: Container(
                width: 350,
                child: TextFormField(
                  controller: roomController,
                  // focusNode: _model.textFieldFocusNode2,
                  autofocus: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'e.g. 330',
                    labelStyle:
                        GoogleFonts.readexPro(color: Colors.grey, fontSize: 12),
                    // hintStyle: FlutterFlowTheme.of(context).labelMedium,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 224, 227, 231),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 75, 57, 239),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                  ),
                  style: const TextStyle(color: Colors.black),
                  //   validator: _model.placeControllerValidator
                  //       .asValidator(context),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Align(
                alignment: AlignmentDirectional(-1, 0),
                child: Text(
                  'From Date',
                  style: GoogleFonts.readexPro(fontSize: 15),
                )),
            const SizedBox(
              height: 5,
            ),
            Align(
              alignment: AlignmentDirectional(-1, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      width: 350,
                      child: Expanded(
                        child: TextFormField(
                          controller: fromdateController,
                          enabled: false,
                        
                          // focusNode: _model.textFieldFocusNode2,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: '',
                            labelStyle: GoogleFonts.readexPro(
                                color: Colors.grey, fontSize: 12),
                            // hintStyle: FlutterFlowTheme.of(context).labelMedium,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 224, 227, 231),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 75, 57, 239),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          ),
                          style: const TextStyle(color: Colors.black),
                          //   validator: _model.placeControllerValidator
                          //       .asValidator(context),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                        onPressed: () {
                          dateTimeWidget(
                              context, fromdateController, todateController);
                        },
                        icon: Icon(Icons.calendar_month_outlined)),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Align(
                alignment: AlignmentDirectional(-1, 0),
                child: Text(
                  'To Date',
                  style: GoogleFonts.readexPro(fontSize: 15),
                )),
            const SizedBox(
              height: 5,
            ),
            Align(
              alignment: AlignmentDirectional(-1, 0),
              child: Row(
                children: [
                  Container(
                    width: 350,
                    child: TextFormField(
                      controller: todateController,
                      enabled: false,

                      // focusNode: _model.textFieldFocusNode2,
                      autofocus: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: '',
                        labelStyle: GoogleFonts.readexPro(
                            color: Colors.grey, fontSize: 12),
                        // hintStyle: FlutterFlowTheme.of(context).labelMedium,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 224, 227, 231),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 75, 57, 239),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding:
                            EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      ),
                      style: const TextStyle(color: Colors.black),
                      //   validator: _model.placeControllerValidator
                      //       .asValidator(context),
                    ),
                  ),
                  // IconButton(
                  //     onPressed: () {
                  //       dateTimeWidget(context, todateController, todateController);
                  //     },
                  //     icon: Icon(Icons.calendar_month_outlined)),
                ],
              ),
            ),

            // Align(
            //   alignment: AlignmentDirectional(-1, 0),
            //   child: Text(
            //     'Service Type',
            //     style: GoogleFonts.readexPro(fontSize: 15),
            //   ),
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            // Align(
            //   alignment: AlignmentDirectional(-1, 0),
            //   child: Container(
            //     width: 350,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(15),
            //       border: Border.all(color: Colors.grey),
            //     ),
            //     child: DropdownButtonFormField<String>(
            //         value: categoryValue,
            //         decoration: InputDecoration(
            //           contentPadding:
            //               EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //           border: InputBorder.none,
            //         ),
            //         // value: selectedValue,
            //         items: sList.keys.map((String category) {
            //           return DropdownMenuItem<String>(
            //             value: category,

            //             // padding: EdgeInsets.symmetric(
            //             //     horizontal: 16, vertical: 8),
            //             child: Text(
            //               category,
            //               style: GoogleFonts.readexPro(),
            //             ),
            //           );
            //         }).toList(),
            //         onChanged: (val) {
            //           setState(() {
            //             categoryValue = val.toString();
            //             resValue = sList[categoryValue]![0];
            //             print(categoryValue);
            //             addPhotoColor = categoryValue == 'Ride'
            //                 ? Colors.grey
            //                 : Color.fromARGB(255, 3, 50, 71);
            //             absorb = categoryValue == 'Ride' ? true : false;

            //             // resValue = '';
            //           });
            //         }),
            //   ),
            // ),
            const SizedBox(
              height: 15,
            ),

            Align(
              alignment: AlignmentDirectional(-1, 0),
              child: Text(
                'Number of participants',
                style: GoogleFonts.readexPro(fontSize: 15),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Align(
              alignment: AlignmentDirectional(-1, 0),
              child: Container(
                width: 350,
                child: TextFormField(
                  controller: nofpartController,
                  // focusNode: _model.textFieldFocusNode2,
                  autofocus: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'e.g. 12',
                    labelStyle:
                        GoogleFonts.readexPro(color: Colors.grey, fontSize: 12),
                    // hintStyle: FlutterFlowTheme.of(context).labelMedium,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 224, 227, 231),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 75, 57, 239),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                  ),
                  style: const TextStyle(color: Colors.black),
                  //   validator: _model.placeControllerValidator
                  //       .asValidator(context),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Align(
              alignment: AlignmentDirectional(-1, 0),
              child: Text(
                'Event Type',
                style: GoogleFonts.readexPro(fontSize: 15),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Align(
              alignment: AlignmentDirectional(-1, 0),
              child: Container(
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey),
                ),
                child: DropdownButtonFormField<String>(
                    value: resValue,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      border: InputBorder.none,
                    ),
                    // value: selectedValue,
                    items: sList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,

                        // padding: EdgeInsets.symmetric(
                        //     horizontal: 16, vertical: 8),
                        child: Text(
                          value,
                          style: GoogleFonts.readexPro(),
                        ),
                      );
                    }).toList(),
                    onChanged: (sValue) {
                      setState(() {
                        sValue = resValue;
                      });
                    }),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Align(
              alignment: AlignmentDirectional(-1, 0),
              child: Text(
                'Body',
                style: GoogleFonts.readexPro(fontSize: 15),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Align(
              alignment: AlignmentDirectional(-1, 0),
              child: Container(
                width: 350,
                child: TextFormField(
                  controller: bodyController,
                  // focusNode: _model.textFieldFocusNode3,
                  autofocus: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle:
                        GoogleFonts.readexPro(color: Colors.grey, fontSize: 12),
                    // hintStyle: FlutterFlowTheme.of(context).labelMedium,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 224, 227, 231),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 75, 57, 239),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                  ),
                  style: const TextStyle(color: Colors.black),
                  maxLines: null,
                  // validator: _model.bodyControllerValidator
                  //     .asValidator(context),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     // Handle button press
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor:
            //         Color.fromARGB(255, 3, 50, 71), // Button color
            //     shape: RoundedRectangleBorder(
            //       borderRadius:
            //           BorderRadius.circular(15.0), // Equal border radius
            //     ),
            //     padding: EdgeInsets.symmetric(horizontal: 150, vertical: 20),
            //   ),
            //   child: Text(
            //     'Create',
            //     style: GoogleFonts.readexPro(
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
            // Spacer(),
            defaultButton(
                function: () {
                  if (_checkFields()) {
                    addEvent(
                        titleContoller,
                        placeController,
                        bodyController,
                        fromdateController,
                        todateController,
                        nofpartController,
                        roomController,
                        imageFiles,
                        resValue);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please Fill All Required Fields!'),
                      ),
                    );
                  }
                },
                //   if (_checkFields()) {
                //     if (categoryValue == 'Item') {
                //       // addEvent(titleContoller, placeController, bodyController,
                //       //     imageFiles, ofSelected);
                //     }
                //   } else {
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(
                //         content: Text('Please Fill All Required Fields!'),
                //       ),
                //     );
                //   }
                // },
                text: 'Create',
                IsUpperCase: false),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
