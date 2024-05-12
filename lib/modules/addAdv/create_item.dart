import 'package:aoun_app/modules/login/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:path/path.dart' as p;
import '../../layout/home_layout.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aoun_app/shared/components/components.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class CreateItemScreen extends StatefulWidget {
  const CreateItemScreen({super.key});

  @override
  State<CreateItemScreen> createState() => _CreateItemScreenState();
}

class _CreateItemScreenState extends State<CreateItemScreen> {
  List<String> postType = ['Offer', 'Request'];
  var iselected = 0;
  // var backColor = Colors.white;
  // var textColor = Colors.black;
  var ofSelected = false;
  var reSelected = false;

  var dropdownValueS = '';
  var dropdownValueR = '';
  var isSelected = false;
  var resValue = 'Stationary';
  // List<XFile>? images = [];
  // List<File> _images = [];
  List<Image> _images = [];
  List<XFile?> imageFiles = [];
  var absorb = false;
  var allFieldsFilled = true;
  Color addPhotoColor = Color.fromARGB(255, 3, 50, 71);

  final List<String> sList = ['Stationary', 'Medicine', 'Car Needs','Others'];

  TextEditingController textController1 = TextEditingController();
  TextEditingController textController2 = TextEditingController();
  TextEditingController textController3 = TextEditingController();

  var categoryValue = 'Item';

  bool _checkFields() {
    if ((reSelected || ofSelected) &&
        textController1.text.isNotEmpty &&
        textController2.text.isNotEmpty &&
        textController3.text.isNotEmpty) {
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

  Future<void> addItem(
      TextEditingController? textController1,
      TextEditingController? textController2,
      TextEditingController? textController3,
      List<XFile?> images,
      bool ofSelected) async {
    String apiUrl;
    if (ofSelected) {
      apiUrl =
          'https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/add_item';
    } else {
      apiUrl =
          'https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/request_item';
    }
    AuthService authService = AuthService();
    var token = await authService.getToken();

    String? text1 = textController1?.text;
    String? text2 = textController2?.text;
    String? text3 = textController3?.text;

    print('this is text1 $text1 text2 $text2 text3 $text3');
    final requestHeaders = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    };
    final requestBody = {
      'title': text1,
      'description': text3,
      'building': text2,
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
      final itemId = responseData['item']['item_id'];
      final createdAt = responseData['item']['created_at'];
      final itemType = responseData['item']['item_type'];
      print(
          'Item created successfully with ID $itemId at $createdAt with item type: $itemType');

      // Show success message to user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item created successfully!'),
        ),
      );

      // Navigate to items screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      print(
          'Error creating item. Status code: ${response.statusCode}, Response: ${response.body}');

      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item could not be created: ${response.body}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
        child: Column(mainAxisSize: MainAxisSize.max, children: [
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
                        padding:
                            EdgeInsets.symmetric(vertical: 30, horizontal: 10),
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
                controller: textController1,
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
                // validator: _model.textController1Validator
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
              'Building Number',
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
                controller: textController2,
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
                //   validator: _model.textController2Validator
                //       .asValidator(context),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
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
          // const SizedBox(
          //   height: 20,
          // ),
          Align(
            alignment: AlignmentDirectional(-1, 0),
            child: Text(
              'Item Type',
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
                controller: textController3,
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
                // validator: _model.textController3Validator
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
                  if (categoryValue == 'Item') {
                    addItem(textController1, textController2, textController3,
                        imageFiles, ofSelected);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please Fill All Required Fields!'),
                    ),
                  );
                }
              },
              text: 'Create',
              IsUpperCase: false),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }
}
