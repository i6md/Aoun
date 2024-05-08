import 'package:aoun_app/modules/addAdv/create_event.dart';
import 'package:aoun_app/modules/addAdv/create_item.dart';
import 'package:aoun_app/modules/addAdv/create_ride.dart';
import 'package:aoun_app/modules/events_screen/events_screen.dart';
import 'package:aoun_app/modules/items_screen/items_screen.dart';
import 'package:aoun_app/modules/rides_screen/rides_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen>
    with TickerProviderStateMixin {
  late final TabController _typeController;

  @override
  void initState() {
    super.initState();
    _typeController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        bottom: TabBar(
          indicatorColor: Color.fromARGB(255, 3, 50, 71),
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: <Widget>[
            Tab(
              child: Text(
                'Item',
                style: GoogleFonts.readexPro(color: Colors.black),
              ),
            ),
            Tab(
              child: Text(
                'Event',
                style: GoogleFonts.readexPro(color: Colors.black),
              ),
              // text: 'Requests',
            ),
            Tab(
              child: Text(
                'Ride',
                style: GoogleFonts.readexPro(color: Colors.black),
              ),
              // text: 'Requests',
            ),
          ],
          controller: _typeController,
        ),
        leading: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF0F1113),
            size: 32,
          ),
        ),
        title: Text(
          'Create Post',
          style: GoogleFonts.readexPro(fontSize: 20),
        ),
        actions: [],
        centerTitle: true,
        elevation: 2,
      ),
      body: SafeArea(
        top: true,
        child: TabBarView(
          controller: _typeController,
          children: <Widget>[
            CreateItemScreen(),
            CreateEventScreen(),
            CreateRideScreen(),
          ],
        ),
      ),
    );
  }
}
