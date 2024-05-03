import 'package:aoun_app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
                  'Offers',
                  style: GoogleFonts.readexPro(color: Colors.black),
                ),
              ),
              Tab(
                child: Text(
                  'Requests',
                  style: GoogleFonts.readexPro(color: Colors.black),
                ),
                // text: 'Requests',
              ),
            ],
            controller: _tabController,
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
            'Notifications',
            style: GoogleFonts.readexPro(fontSize: 20),
          ),
          actions: [],
          centerTitle: true,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.max, children: [
                notificationOffer(
                    title: 'Panadol',
                    name: 'Meshal Aldajani',
                    place: '839',
                    rating: '4.9'),
                const Divider(
                  height: 10,
                ),
                notificationOffer(
                    title: 'Baloot',
                    name: 'Khaled Alnoubi',
                    place: '861',
                    rating: '4.5'),
                const Divider(
                  height: 10,
                ),
                notificationOffer(
                    title: 'Vacuum',
                    name: 'Asem Alsayed',
                    place: '829',
                    rating: '4.8'),
                const Divider(
                  height: 10,
                ),
                notificationOffer(
                    title: 'Riyadh - KFUPM',
                    name: 'Jehad Alrehaily',
                    place: '839',
                    rating: '5.0'),
                const Divider(
                  height: 10,
                ),
              ])),
              SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.max, children: [
                  notificationRequest(
                      name: 'Meshal Aldajani', place: '839', rating: '4.3'),
                  const Divider(
                    height: 10,
                  ),
                  notificationRequest(
                      name: 'Turki Alzahrani', place: '816', rating: '4.7'),
                  const Divider(
                    height: 10,
                  ),
                  notificationRequest(
                      name: 'Osama Morsi', place: '830', rating: '4.6'),
                  const Divider(
                    height: 10,
                  ),
                  notificationRequest(
                      name: 'Khaled Alnoubi', place: '826', rating: '5.0'),
                  const Divider(
                    height: 10,
                  ),
                  notificationRequest(
                      name: 'Asem Alsayed', place: '861', rating: '4.9'),
                  const Divider(
                    height: 10,
                  ),
                ]),
              ),
            ],
          ),
        ));
  }
}
