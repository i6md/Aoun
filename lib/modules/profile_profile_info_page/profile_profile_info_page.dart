import 'package:flutter/material.dart';
import 'package:aoun_app/core/app_export.dart';
import 'package:aoun_app/widgets/custom_elevated_button.dart';
import 'package:aoun_app/widgets/custom_text_form_field.dart';

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
  TextEditingController firstNameController = TextEditingController();

  TextEditingController lastNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
  Widget _buildFirstName(BuildContext context) {
    return CustomTextFormField(
      controller: firstNameController,
      hintText: "Archie",
    );
  }

  /// Section Widget
  Widget _buildLastName(BuildContext context) {
    return CustomTextFormField(
      controller: lastNameController,
      hintText: "Copeland",
    );
  }

  /// Section Widget
  Widget _buildEmail(BuildContext context) {
    return CustomTextFormField(
      controller: emailController,
      hintText: "archiecopeland@gmail.com",
      textInputAction: TextInputAction.done,
      textInputType: TextInputType.emailAddress,
    );
  }

  /// Section Widget
  Widget _buildSaveEdit(BuildContext context) {
    return CustomElevatedButton(
      text: "Save Edit",
    );
  }

  /// Section Widget
  Widget _buildThirtyFive(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "First Name",
            style: theme.textTheme.titleSmall,
          ),
          SizedBox(height: 12.v),
          _buildFirstName(context),
          SizedBox(height: 26.v),
          Text(
            "Last Name",
            style: theme.textTheme.titleSmall,
          ),
          SizedBox(height: 12.v),
          _buildLastName(context),
          SizedBox(height: 26.v),
          Text(
            "Email address",
            style: theme.textTheme.titleSmall,
          ),
          SizedBox(height: 12.v),
          _buildEmail(context),
          SizedBox(height: 31.v),
          _buildSaveEdit(context),
        ],
      ),
    );
  }
}
