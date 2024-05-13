import 'package:aoun_app/map/map.dart';
import 'package:aoun_app/modules/addAdv/add_advertisement.dart';
import 'package:aoun_app/modules/addAdv/create_post.dart';
import 'package:aoun_app/modules/events_screen/events_screen.dart';
import 'package:aoun_app/modules/items_screen/items_screen.dart';
import 'package:aoun_app/modules/login/login_screen.dart';
import 'package:aoun_app/modules/notifications/notification_screen.dart';
import 'package:aoun_app/modules/profile_profile_info_tab_container_screen/profile_profile_info_tab_container_screen.dart';
import 'package:aoun_app/modules/report/report_post.dart';
import 'package:aoun_app/modules/rides_screen/rides_screen.dart';
import 'package:aoun_app/modules/settings/settings_screen.dart';
import 'package:aoun_app/modules/users/users_screen.dart';
import 'package:aoun_app/shared/cubit/cubit.dart';
import 'package:aoun_app/shared/cubit/states.dart';
import 'package:aoun_app/widgets/app_bar/appbar_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import '../Filters/filter_dialog.dart';
import '../searchDelegate/searchDelegate.dart';

class HomeScreen extends StatelessWidget {
  bool isAdmin = true;
  HomeScreen({super.key});

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomeCubit(),
      child: BlocConsumer<HomeCubit, HomeStates>(
        listener: (BuildContext context, HomeStates state) {},
        builder: (BuildContext context, HomeStates state) {
          HomeCubit cubit = HomeCubit.get(context);
          return Scaffold(
            drawer: Drawer(
              child: ListView(
                children: [
                  SizedBox(
                    height: 65,
                    child: DrawerHeader(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        'Aoun',
                        style: GoogleFonts.readexPro(
                            textStyle: TextStyle(
                          color: Colors.indigo,
                          fontSize: 23.0,
                          fontWeight: FontWeight.w700,
                        )),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Personal Page'),
                    onTap: () {
                      // Navigate to the shop screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProfileProfileInfoTabContainerScreen()));
                      // You can add navigation logic here
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.report),
                    title: Text('Report an Issue'),
                    onTap: () {
                      // Navigate to the shopping cart screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReportPostScreen()));
                      // You can add navigation logic here
                    },
                  ),
                  Divider(), // Add a divider for visual separation
                  ListTile(
                    leading: Icon(Icons.map),
                    title: Text('Map'),
                    onTap: () {
                      // Navigate to the settings screen
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MapScreen()));
                      // You can add navigation logic here
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                    onTap: () {
                      // Navigate to the settings screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsScreen()));
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
                  if (isAdmin)
                    ListTile(
                      leading: Icon(Icons.supervised_user_circle_sharp),
                      title: Text('Manage users'),
                      onTap: () {
                        // Navigate to the help & support screen
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UsersScreen()));
                        // You can add navigation logic here
                      },
                    ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                    onTap: () {
                      // Navigate to the help & support screen
                      Amplify.Auth.signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                      // You can add navigation logic here
                    },
                  ),
                ],
              ),
            ),
            appBar: AppBar(
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(10))),
              backgroundColor: Colors.white,
              title: Text('Aoun',
                  style: GoogleFonts.readexPro(
                      textStyle: TextStyle(
                    color: Colors.indigo,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w700,
                  ))),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationsScreen()));
                    },
                    color: Colors.grey[800],
                    icon: const Icon(
                      Icons.notifications,
                      color: Colors.indigo,
                    )),
                IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: DataSearch(HomeCubit.get(context).ads),
                    );
                  },
                  color: Colors.grey[800],
                  icon: const Icon(
                    Icons.search,
                    color: Colors.indigo,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    List<String> resourceTypes;
                    switch (HomeCubit.get(context).counter) {
                      case 0: // Items
                        resourceTypes = ['Stationary', 'Medicine', 'Car Needs', 'Other'];
                        break;
                      case 1: // Events
                        resourceTypes = ['Student Clubs', 'Sports', 'Gatherings', 'Other'];
                        break;
                      case 2: // Rides
                        resourceTypes = ['Travel', 'Transportation', 'Delivery', 'Other'];
                        break;
                      default:
                        resourceTypes = [];
                    }
                    List<String> selectedFilters = await showDialog(
                      context: context,
                      builder: (context) => FilterDialog(
                          selectedFilters: HomeCubit.get(context).filters,
                          resourceTypes: resourceTypes),
                    );
                    HomeCubit.get(context).updateFilters(selectedFilters);
                  },
                  color: Colors.grey[800],
                  icon: const Icon(
                    Icons.filter_alt_sharp,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
            body: ConditionalBuilder(
              condition: true,
              builder: (BuildContext context) => cubit.screens[cubit.counter],
              fallback: (BuildContext context) =>
                  Center(child: CircularProgressIndicator()),
            ),
            backgroundColor: Colors.white,
            //
            floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreatePostScreen()));
              },
              backgroundColor: Colors.indigo,
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.counter,
              elevation: 30,
              iconSize: 20,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.shop_rounded),
                  label: "Items",
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.golf_course), label: "Events"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.local_taxi), label: "Rides"),
              ],
              onTap: (index) {
                cubit.changeIndex(index);
              },
            ),
          );
        },
      ),
    );
  }
}
