import 'dart:convert';

import 'package:aoun_app/modules/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:aoun_app/core/app_export.dart';
import 'package:aoun_app/modules/profile_my_orders_page/profile_my_orders_page.dart';
import 'package:aoun_app/modules/profile_profile_info_page/profile_profile_info_page.dart';
import 'package:aoun_app/modules//profile_security_page/profile_security_page.dart';
import 'package:aoun_app/widgets/app_bar/appbar_leading_image.dart';
import 'package:aoun_app/widgets/app_bar/appbar_title.dart';
import 'package:aoun_app/widgets/app_bar/custom_app_bar.dart';
import 'package:aoun_app/widgets/custom_icon_button.dart';
import 'package:http/http.dart' as http;
import 'package:aoun_app/models/user/user_model.dart';


import '../login/auth_service.dart';

class ProfileProfileInfoTabContainerScreen extends StatefulWidget {
  const ProfileProfileInfoTabContainerScreen({Key? key}) : super(key: key);

  @override
  ProfileProfileInfoTabContainerScreenState createState() =>
      ProfileProfileInfoTabContainerScreenState();
}

// ignore_for_file: must_be_immutable
class ProfileProfileInfoTabContainerScreenState
    extends State<ProfileProfileInfoTabContainerScreen>
    with TickerProviderStateMixin {
  late TabController tabviewController;
  var user;
  Future<List<UserModel>>? userInfoFuture;

  Future<List<UserModel>> fetchUserInfo() async {
    AuthService authService = AuthService();
    var token = await authService.getToken();
    final requestHeaders = {
      "Authorization": "Bearer $token",
    };

    final response = await http.get(
        Uri.parse('https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/list_user_info'),
        headers: requestHeaders);


    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      var user = jsonResponse['user'] as Map<String, dynamic>? ?? {};
      // print(jsonResponse); // Logs the whole response
      // print("name: ${user['name']}"); // Correctly access the 'name'
      // print("building: ${user['building']}"); // Correctly access the 'building'

      // var body = jsonDecode(jsonResponse['body'] as String) as Map<String, dynamic>;
      //
      // print("user info is here");
      // print(user);
      // print(body);
      return [UserModel.fromJson(user)];

      // Assuming UserModel.fromJson can parse the user object directly
    } else {
      print(
          'Error viewing userinfo. Status code: ${response.statusCode}, Response: ${response.body}');
      throw Exception('Failed to load user info: ${response.body}');
    }

  }


  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 3, vsync: this);
    userInfoFuture = fetchUserInfo();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: _buildAppBar(context),
            body: SizedBox(
                width: double.maxFinite,
                child: Column(children: [
                  FutureBuilder<List<UserModel>>(
                    future: userInfoFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else {
                        user = snapshot.data?.first; // Assuming we want the first user's data
                        return Expanded(
                          child: Column(
                            children: [
                              _buildProfileDetails(context, user),
                              SizedBox(height: 18.v),
                              _buildTabview(context),
                              Expanded(
                                  child: SizedBox(
                                      height: 443.v,
                                      child: TabBarView(
                                          controller: tabviewController,
                                          children: [
                                            ProfileProfileInfoPage(),
                                            ProfileMyOrdersPage(user: user),
                                            ProfileSecurityPage(),
                                          ])))
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ]))));
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
        leadingWidth: 36.h,
        leading: AppbarLeadingImage(
            imagePath: ImageConstant.imgArrowDown,
            margin: EdgeInsets.only(left: 12.h, top: 20.v, bottom: 20.v),
            onTap: () {
              onTapArrowDown(context);
            }),
        centerTitle: true,
        title: AppbarTitle(text: "Aoun"),
        styleType: Style.bgFill);
  }

  Widget _buildProfileDetails(BuildContext context, UserModel? user) {
    // Debugging: Print user data to the console
    // if (user != null) {
    //   print("user is hereeeee ${user}");
    //   print("User data is available:");
    //   print("Name: ${user.name}");
    //   print("Building: ${user.building}");
    // } else {
    //   print("User data is null");
    // }
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 104.h, vertical: 32.v),
        decoration: AppDecoration.white,
        child: Column(children: [
          Text(user?.name.toUpperCase() ?? "No Name",
              style: theme.textTheme.bodyLarge),
          SizedBox(height: 13.v),
          Text(user?.building ?? "No Location",
              style: CustomTextStyles.bodyMediumGray600)
        ]));
  }

  Widget _buildTabview(BuildContext context) {
    return Container(
      height: 30.v,
      width: double.maxFinite,
      child: TabBar(
        tabAlignment: TabAlignment.center,
        controller: tabviewController,
        isScrollable: true,
        labelColor: theme.colorScheme.primary,
        labelStyle: TextStyle(
          fontSize: 14.fSize,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w400,
        ),
        unselectedLabelColor: appTheme.gray600,
        unselectedLabelStyle: TextStyle(
          fontSize: 14.fSize,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w400,
        ),
        indicatorColor: theme.colorScheme.primary,
        tabs: [
          Tab(child: Text("Profile info")),
          Tab(child: Text("My orders")),
          Tab(child: Text("Security")),
        ],
      ),
    );
  }

  onTapArrowDown(BuildContext context) {
    Navigator.pop(context);
  }
}