import 'package:aoun_app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:aoun_app/modules/addAdv/appPost_screen.dart';

class ReportPostScreen extends StatefulWidget {
  const ReportPostScreen({super.key});

  @override
  State<ReportPostScreen> createState() => _ReportPostSceenState();
}

class _ReportPostSceenState extends State<ReportPostScreen> {
  var subjectController = TextEditingController();
  var bodyController = TextEditingController();
  var dropdownValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Report',
          style: TextStyle(
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
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              defaultFormField(
                  controller: subjectController,
                  validate: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the subject';
                    }
                    return null;
                  },
                  label: 'Subject'),
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
                    initialSelection: dropdownValue,
                    onSelected: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    dropdownMenuEntries: ['Items', 'Events', 'Rides']
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Please inform us with the details',
                  
                ),
              ),
              defaultFormField(
                controller: bodyController,
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the details';
                  }
                  return null;
                },
                label: 'Body',
                height: 7,
              ),
              const SizedBox(height: 100,),
              defaultButton(function: () {}, text: 'Send', IsUpperCase: false),
            ],
          )),
    );
  }
}
