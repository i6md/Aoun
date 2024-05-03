import 'dart:io';

import 'package:aoun_app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final List<String> postTypes = <String>['Offer', 'Request'];
final Map<String, List<String>> _dropDownMenu = {
  'Items': ['Stationary', 'Medicine', 'Car Needs'],
  'Events': ['Student Clubs', 'Sports', 'Gatherings'],
  'Rides': [
    'KFUPM - SAR',
    'SAR - KFUPM',
    'KFUPM - Airport',
    'Airport - KFUPM',
    'KFUPM - Riyadh',
    'Riyadh - KFUPM'
  ]
};
// final List<String> ServiceTypes = <String>['Item', 'Event', 'Ride'];
// final List<List<String>> ResourceTypes = [['Stationary', 'Medicine', 'Car Needs'], ['Student Clubs', 'Sports', 'Gatherings'], ['KFUPM - SAR', 'SAR - KFUPM', 'KFUPM - Airport', 'Airport - KFUPM', 'KFUPM - Riyadh', 'Riyadh - KFUPM']];

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() {
    return _AddPostScreenState();
  }
}

class _AddPostScreenState extends State<AddPostScreen> {
  var dropdownValueP = postTypes[0];
  var dropdownValueS = '';
  var dropdownValueR = '';
  var isSelected = false;
  var _selectedKey = '';

  List<XFile>? images = [];

  var titleController = TextEditingController();
  var buildingController = TextEditingController();
  var bodyController = TextEditingController();

  // Future<void> _pickImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     setState(() {
  //       images.add(File(pickedFile.path));
  //     });
  //   }
  // }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        images!.addAll(pickedFiles);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 15),
            Row(
              children: [
                const Text(
                  'Post Type',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'sans-serif',
                  ),
                ),
                const SizedBox(width: 30),
                DropdownMenu<String>(
                  initialSelection: postTypes[0],
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      dropdownValueP = value!;
                    });
                  },
                  dropdownMenuEntries:
                  postTypes.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // OutlinedButton(onPressed: (){}, child: const Text('Add Picture'), style: OutlinedButton.styleFrom(backgroundColor: Colors.grey,foregroundColor: Colors.black),),
            Row(
              children: [
                InkWell(
                    onTap: _pickImage,
                    child: Container(
                      width: 80,
                      padding: const EdgeInsets.all(10),
                      // alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius:
                          BorderRadius.circular(10)), // Make rounded corner
                      child: const Column(
                        children: [
                          Text('+'),
                          Text(
                            "Add Pictures",
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(width: 10,),
                TextButton(onPressed: () {setState(() {
                  images!.clear();
                });}, child: const Text('Reset Pictures', style: TextStyle(color: Colors.red, fontSize: 10),))
              ],
            ),
            const SizedBox(
              height: 10,
            ),

            images!.isEmpty
                ? const Text('No images selected.')
                : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: images!
                    .map((image) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    image.path,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ))
                    .toList(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            defaultFormField(
                controller: titleController,
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title';
                  }
                  return null;
                },
                label: 'Title',
                prefix: Icons.title,
                onChange: (value) {
                  print(value);
                },
                onSubmit: (value) {
                  print(value);
                }),
            const SizedBox(
              height: 20,
            ),
            defaultFormField(
                controller: buildingController,
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the buiding number';
                  }
                  return null;
                },
                label: 'Building Number',
                prefix: Icons.home,
                onChange: (value) {
                  print(value);
                },
                onSubmit: (value) {
                  print(value);
                }),

            const SizedBox(
              height: 20,
            ),

            Row(
              children: [
                const Text(
                  'Service Type',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'sans-serif',
                  ),
                ),
                const SizedBox(width: 30),
                DropdownMenu<String>(
                  initialSelection: dropdownValueS,
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      dropdownValueS = value!;
                      isSelected = true;
                      _selectedKey = value;
                    });
                  },
                  dropdownMenuEntries: _dropDownMenu.keys
                      .map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (isSelected)
              Row(
                children: [
                  const Text(
                    'Resource Type',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'sans-serif',
                    ),
                  ),
                  const SizedBox(width: 30),
                  DropdownMenu<String>(
                    initialSelection: dropdownValueR,
                    onSelected: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValueS = value!;
                      });
                    },
                    dropdownMenuEntries: _dropDownMenu[_selectedKey]!
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList(),
                  ),
                ],
              ),
            const SizedBox(
              height: 30,
            ),

            defaultFormField(
                controller: bodyController,
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the description of the post';
                  }
                  return null;
                },
                label: 'Description',
                height: 5,
                prefix: Icons.description,
                action: TextInputAction.newline,
                type: TextInputType.multiline,
                onChange: (value) {

                },
                onSubmit: (value) {

                }),

            const SizedBox(
              height: 20,
            ),
            // Center(
            //   child: OutlinedButton(
            //     style: ButtonStyle(
            //         backgroundColor: MaterialStateProperty.all(Colors.blue),
            //         padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 20, horizontal: 50)),
            //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            //             RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(10.0),
            //                 side: const BorderSide(color: Color.fromARGB(255, 243, 33, 222))))),
            //     onPressed: () {},

            //     child: const Text(
            //       "Create Post",
            //       style: TextStyle(fontSize: 20.0, color: Colors.white,),
            //     ),
            //   ),
            // ),
            defaultButton(function: (){}, text: 'Create Post', IsUpperCase: false),
            const SizedBox(height: 10,),
          ],
        ));
  }
}
