import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:aoun_app/core/app_export.dart';
import 'package:aoun_app/widgets/custom_elevated_button.dart';
import 'package:aoun_app/widgets/custom_text_form_field.dart';
import 'package:http/http.dart' as http;
import '../../models/user/user_model.dart';
import '../login/auth_service.dart';

// ignore_for_file: must_be_immutable
class ProfileProfileInfoPage extends StatefulWidget {
  const ProfileProfileInfoPage({Key? key})
      : super(
          key: key,
        );

  @override
  ProfileProfileInfoPageState createState() => ProfileProfileInfoPageState();
}

class ProfileProfileInfoPageState extends State<ProfileProfileInfoPage>
    with AutomaticKeepAliveClientMixin<ProfileProfileInfoPage> {

  TextEditingController buildingController = TextEditingController();

  TextEditingController roomController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> updateUserInfo() async {
    AuthService authService = AuthService();
    var token = await authService.getToken();
    final requestHeaders = {
      "Authorization": "Bearer $token",
    };
    final requestBody = {
      "building": buildingController.text,
      "room": roomController.text,
      "pic": {
        "content": "",
        "extension": "jpg"
      }
    };

    final response = await http.post(
        Uri.parse('https://f1rb8ipuw4.execute-api.eu-north-1.amazonaws.com/ver1/edit_user_info'),
        headers: requestHeaders,
        body: json.encode(requestBody)
    );


    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final message = responseData['message'];
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Information updated successfully: $message'),
          )
      );
    } else {
      final errorResponse = json.decode(response.body);
      final error = errorResponse['error'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
        ),
      );
    }

  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          width: SizeUtils.width,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Form(
              key: _formKey,
              child: Container(
                width: double.maxFinite,
                decoration: AppDecoration.white,
                child: Column(
                  children: [
                    SizedBox(height: 38.v),
                    _buildThirtyFive(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget

  /// Section Widget
  Widget _buildBuilding(BuildContext context) {
    return CustomTextFormField(
      controller: buildingController,
      hintText: "Building number",
      textInputAction: TextInputAction.done,
      textInputType: TextInputType.number,
    );
  }

  Widget _buildroom(BuildContext context) {
    return CustomTextFormField(
      controller: roomController,
      hintText: "Room number",
      textInputAction: TextInputAction.done,
      textInputType: TextInputType.number,
    );
  }

  /// Section Widget
  Widget _buildSaveEdit(BuildContext context) {
    return CustomElevatedButton(
      text: "Save Edit",
      onPressed: () {
        if (buildingController.text.isNotEmpty && roomController.text.isNotEmpty) {
          updateUserInfo();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please fill in all fields'),
            ),
          );
        }
      },
    );
  }

  /// Section Widget
  Widget _buildThirtyFive(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 26.v),
          Text(
            "Building",
            style: theme.textTheme.titleSmall,
          ),
          SizedBox(height: 12.v),
          _buildBuilding(context),
          SizedBox(height: 26.v),
          Text(
            "Room",
            style: theme.textTheme.titleSmall,
          ),
          SizedBox(height: 12.v),
          _buildroom(context),
          SizedBox(height: 31.v),
          _buildSaveEdit(context),
        ],
      ),
    );
  }
}

