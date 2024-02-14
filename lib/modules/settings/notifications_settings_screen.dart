import 'package:aoun_app/modules/report/report_post.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  List<String> serviceTypes = ['Item', 'Event', 'Ride'];
  int? _value = 1;

  bool slight = true;
  bool mlight = true;
  bool clight = true;

  bool blight = true;
  bool splight = true;
  bool stlight = true;
  bool glight = true;

  bool nlight = true;
  bool aklight = true;
  bool kalight = true;
  bool rklight = true;
  bool krlight = true;
  bool ktlight = true;
  bool tklight = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        // title: Padding(
        //   padding: const EdgeInsets.only(left: 60),
        //   child: Text(
        //     'Notifications',
        //     style: GoogleFonts.readexPro(
        //       color: Colors.black,
        //       fontSize: 22,
        //       // fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
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
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  'Notifications',
                  style: GoogleFonts.readexPro(
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                // const SizedBox(width: 150),
                Switch(
                  // This bool value toggles the switch.
                  value: nlight,
                  activeColor: Colors.green,
                  onChanged: (bool value) {
                    // This is called when the user toggles the switch.
                    setState(() {
                      nlight = value;
                    });
                  },
                ),
              ],
            ),
            const Divider(height: 40),
            if (nlight) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 40.0,
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
              const SizedBox(height: 20,),
              if (_value == 0) ...[
                Row(
                  children: [
                    Text(
                      'Stationary',
                      style: GoogleFonts.readexPro(
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    // const SizedBox(width: 150),
                    Switch(
                      // This bool value toggles the switch.
                      value: slight,
                      activeColor: Colors.green,
                      onChanged: (bool value) {
                        // This is called when the user toggles the switch.
                        setState(() {
                          slight = value;
                        });
                      },
                    ),
                  ],
                ),
                const Divider(height: 40),
                Row(
                  children: [
                    Text(
                      'Medicine',
                      style: GoogleFonts.readexPro(
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    // const SizedBox(width: 150),
                    Switch(
                      // This bool value toggles the switch.
                      value: mlight,
                      activeColor: Colors.green,
                      onChanged: (bool value) {
                        // This is called when the user toggles the switch.
                        setState(() {
                          mlight = value;
                        });
                      },
                    ),
                  ],
                ),
                const Divider(height: 40),
                Row(
                  children: [
                    Text(
                      'Car Needs',
                      style: GoogleFonts.readexPro(
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    // const SizedBox(width: 150),
                    Switch(
                      // This bool value toggles the switch.
                      value: clight,
                      activeColor: Colors.green,
                      onChanged: (bool value) {
                        // This is called when the user toggles the switch.
                        setState(() {
                          clight = value;
                        });
                      },
                    ),
                  ],
                ),
                const Divider(height: 40),
              ] else if (_value == 1) ...[
                Row(
                  children: [
                    Text(
                      'Baloot',
                      style: GoogleFonts.readexPro(
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    // const SizedBox(width: 150),
                    Switch(
                      // This bool value toggles the switch.
                      value: blight,
                      activeColor: Colors.green,
                      onChanged: (bool value) {
                        // This is called when the user toggles the switch.
                        setState(() {
                          blight = value;
                        });
                      },
                    ),
                  ],
                ),
                const Divider(height: 40),
                Row(
                  children: [
                    Text(
                      'Sports',
                      style: GoogleFonts.readexPro(
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    // const SizedBox(width: 150),
                    Switch(
                      // This bool value toggles the switch.
                      value: splight,
                      activeColor: Colors.green,
                      onChanged: (bool value) {
                        // This is called when the user toggles the switch.
                        setState(() {
                          splight = value;
                        });
                      },
                    ),
                  ],
                ),
                const Divider(height: 40),
                Row(
                  children: [
                    Text(
                      'Student Clubs',
                      style: GoogleFonts.readexPro(
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    // const SizedBox(width: 150),
                    Switch(
                      // This bool value toggles the switch.
                      value: stlight,
                      activeColor: Colors.green,
                      onChanged: (bool value) {
                        // This is called when the user toggles the switch.
                        setState(() {
                          stlight = value;
                        });
                      },
                    ),
                  ],
                ),
                const Divider(height: 40),
                Row(
                  children: [
                    Text(
                      'Gatherings',
                      style: GoogleFonts.readexPro(
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    // const SizedBox(width: 150),
                    Switch(
                      // This bool value toggles the switch.
                      value: glight,
                      activeColor: Colors.green,
                      onChanged: (bool value) {
                        // This is called when the user toggles the switch.
                        setState(() {
                          glight = value;
                        });
                      },
                    ),
                  ],
                ),
                const Divider(height: 40),
              ] else
                ...[
                  Row(
                  children: [
                    Text(
                      'Airport -> KFUPM',
                      style: GoogleFonts.readexPro(
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    // const SizedBox(width: 150),
                    Switch(
                      // This bool value toggles the switch.
                      value: aklight,
                      activeColor: Colors.green,
                      onChanged: (bool value) {
                        // This is called when the user toggles the switch.
                        setState(() {
                          aklight = value;
                        });
                      },
                    ),
                  ],
                ),
                const Divider(height: 40),
                Row(
                  children: [
                    Text(
                      'KFUPM -> Airport',
                      style: GoogleFonts.readexPro(
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    // const SizedBox(width: 150),
                    Switch(
                      // This bool value toggles the switch.
                      value: kalight,
                      activeColor: Colors.green,
                      onChanged: (bool value) {
                        // This is called when the user toggles the switch.
                        setState(() {
                          kalight = value;
                        });
                      },
                    ),
                  ],
                ),
                const Divider(height: 40),
                Row(
                  children: [
                    Text(
                      'Riyadh -> KFUPM',
                      style: GoogleFonts.readexPro(
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    // const SizedBox(width: 150),
                    Switch(
                      // This bool value toggles the switch.
                      value: rklight,
                      activeColor: Colors.green,
                      onChanged: (bool value) {
                        // This is called when the user toggles the switch.
                        setState(() {
                          rklight = value;
                        });
                      },
                    ),
                  ],
                ),
                const Divider(height: 40),
                Row(
                  children: [
                    Text(
                      'KFUPM -> Riyadh',
                      style: GoogleFonts.readexPro(
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    // const SizedBox(width: 150),
                    Switch(
                      // This bool value toggles the switch.
                      value: krlight,
                      activeColor: Colors.green,
                      onChanged: (bool value) {
                        // This is called when the user toggles the switch.
                        setState(() {
                          krlight = value;
                        });
                      },
                    ),
                  ],
                ),
                const Divider(height: 40),
                Row(
                  children: [
                    Text(
                      'Train Station -> KFUPM',
                      style: GoogleFonts.readexPro(
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    // const SizedBox(width: 150),
                    Switch(
                      // This bool value toggles the switch.
                      value: tklight,
                      activeColor: Colors.green,
                      onChanged: (bool value) {
                        // This is called when the user toggles the switch.
                        setState(() {
                          tklight = value;
                        });
                      },
                    ),
                  ],
                ),
                const Divider(height: 40),
                Row(
                  children: [
                    Text(
                      'KFUPM -> Train Station',
                      style: GoogleFonts.readexPro(
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    // const SizedBox(width: 150),
                    Switch(
                      // This bool value toggles the switch.
                      value: ktlight,
                      activeColor: Colors.green,
                      onChanged: (bool value) {
                        // This is called when the user toggles the switch.
                        setState(() {
                          ktlight = value;
                        });
                      },
                    ),
                  ],
                ),
                const Divider(height: 40),
                ],
            ],
          ]),
        ),
      ),
    );
  }
}
