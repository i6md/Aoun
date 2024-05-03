import 'package:aoun_app/modules/report/report_post.dart';
import 'package:aoun_app/modules/settings/notifications_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool delete = true;

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            'Settings',
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                'Language',
                style: GoogleFonts.readexPro(fontSize: 15),
              ),
              const Spacer(),
              // const SizedBox(width: 150),
              Text(
                'English',
                textAlign: TextAlign.right,
                style: GoogleFonts.readexPro(fontSize: 15),
              ),
            ],
          ),
          const Divider(height: 80),
          Row(
            children: [
              Text(
                'Notifications',
                style: GoogleFonts.readexPro(fontSize: 15),
              ),
              const Spacer(),
              // const SizedBox(width: 150),
              IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationsSettingsScreen())),
                  icon: const Icon(Icons.arrow_forward_ios_rounded, size: 15,)),
            ],
          ),
          const Divider(height: 80),
          Row(
            children: [
              Text(
                'Report Problem',
                style: GoogleFonts.readexPro(fontSize: 15),
              ),
              const Spacer(),
              // const SizedBox(width: 150),
              IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ReportPostScreen())),
                  icon: const Icon(Icons.arrow_forward_ios_rounded, size: 15,)),
            ],
          ),
          const Divider(height: 80),
          Row(
            children: [
              Text(
                'Delete Account',
                style: GoogleFonts.readexPro(
                  fontSize: 15,
                  color: Colors.red,
                ),
              ),
              const Spacer(),
              // const SizedBox(width: 150),
              IconButton(
                  onPressed: () {
                    if (delete) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Are you sure?', style: TextStyle(fontSize: 15)),
                            actions: [
                              TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  )),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  icon: const Icon(Icons.arrow_forward_ios_rounded, size: 15,)),
            ],
          ),
        ]),
      ),
    );
  }
}
