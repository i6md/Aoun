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

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: _buildAppBar(context),
            body: SizedBox(
                width: double.maxFinite,
                child: Column(children: [
                  _buildProfileDetails(context),
                  SizedBox(height: 18.v),
                  _buildTabview(context),
                  Expanded(
                      child: SizedBox(
                          height: 443.v,
                          child: TabBarView(
                              controller: tabviewController,
                              children: [
                                ProfileProfileInfoPage(),
                                ProfileMyOrdersPage(),
                                ProfileSecurityPage(),
                              ])))
                ]))));
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
        leadingWidth: 36.h,
        leading: AppbarLeadingImage(
            imagePath: ImageConstant.imgArrowDown,
            margin: EdgeInsets.only(left: 12.h, top: 20.v, bottom: 20.v),
            onTap: () {
              onTapArrowDown(context);
            },),
        centerTitle: true,
        title: AppbarTitle(text: "Aoun"),
        styleType: Style.bgFill);
  }

  /// Section Widget
  Widget _buildProfileDetails(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 104.h, vertical: 32.v),
        decoration: AppDecoration.white,
        child: Column(children: [
          SizedBox(
              height: 116.v,
              width: 100.h,
              child: Stack(alignment: Alignment.bottomLeft, children: [
                CustomImageView(
                    imagePath: 'assets/images/img_profile_image.png',
                    height: 100.adaptSize,
                    width: 100.adaptSize,
                    radius: BorderRadius.circular(50.h),
                    alignment: Alignment.topCenter),
                Padding(
                    padding: EdgeInsets.only(left: 31.h),
                    child: CustomIconButton(
                        height: 32.adaptSize,
                        width: 32.adaptSize,
                        padding: EdgeInsets.all(5.h),
                        alignment: Alignment.bottomLeft,
                        child:
                            CustomImageView(imagePath: ImageConstant.imgEdit2)))
              ])),
          SizedBox(height: 10.v),
          Text("Archie Copeland".toUpperCase(),
              style: theme.textTheme.bodyLarge),
          SizedBox(height: 13.v),
          Text("Allentown, New Mexico",
              style: CustomTextStyles.bodyMediumGray600)
        ]));
  }

  /// Section Widget
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

  /// Navigates back to the previous screen.
  onTapArrowDown(BuildContext context) {
    Navigator.pop(context);
  }
}
