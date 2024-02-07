import 'package:aoun_app/modules/addAdv/add_advertisement.dart';
import 'package:aoun_app/modules/events_screen/events_screen.dart';
import 'package:aoun_app/modules/items_screen/items_screen.dart';
import 'package:aoun_app/modules/login/login_screen.dart';
import 'package:aoun_app/modules/report/report_post.dart';
import 'package:aoun_app/modules/rides_screen/rides_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget{
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  int counter = 0;
  List<Widget> screens = [
    ItemsScreen(),EventsScreen(),RidesScreen()
  ];


  Widget build(BuildContext context) {

    return Scaffold(
      drawer: Expanded(
        child: Drawer(
          child: ListView(
            children: [
              SizedBox(
                height: 65,
                child: DrawerHeader(
                  child: Text(
                  'Aoun',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 24,
                  ),
                ),
                          ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Personal Page'),
                onTap: () {
                  // Navigate to the shop screen
                  Navigator.pop(context);
                  // You can add navigation logic here
                },
              ),
              ListTile(
                leading: Icon(Icons.report),
                title: Text('Report an Issue'),
                onTap: () {
                  // Navigate to the shopping cart screen
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportPostScreen()));
                  // You can add navigation logic here
                },
              ),
              Divider(), // Add a divider for visual separation
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  // Navigate to the settings screen
                  Navigator.pop(context);
                  // You can add navigation logic here
                },
              ),
              ListTile(
                leading: Icon(Icons.help),
                title: Text('About us'),
                onTap: () {
                  // Navigate to the help & support screen
                  Navigator.pop(context);
                  // You can add navigation logic here
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  // Navigate to the help & support screen
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                  // You can add navigation logic here
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(

        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))
        ),
        backgroundColor: Colors.blue,
        title: Text(
          'Aoun',
              style: TextStyle(
            fontSize: 26.0,
                color: Colors.white
        ),
        ),
        actions:
        [
          IconButton(
              onPressed:() {
                print('Notification clicked');
              },
              color: Colors.white,
              icon: const Icon(
                Icons.notifications,)
          )
          ,
          IconButton(
              onPressed:() {
                print('search clicked');
              },
              color: Colors.white,
              icon: const Icon(
                Icons.search,)
          ),
          IconButton(
              onPressed:() {
                print('filter');
              },
              color: Colors.white,
              icon: const Icon(
                Icons.filter_alt_sharp,)
          ),
        ],
      ),
      body: screens[counter],
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
          onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPost()));
          }
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: counter,
        elevation: 19,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.shop_rounded),
            label: "Items",

          ),
          BottomNavigationBarItem(icon: Icon(Icons.golf_course),
              label: "Events"),
          BottomNavigationBarItem(icon: Icon(Icons.local_taxi),
              label: "Rides"),
        ],
        onTap: (index){
          setState(() {
            counter=index;
          });

        },
      ),

    );
  }
}