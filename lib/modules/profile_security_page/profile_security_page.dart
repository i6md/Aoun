import 'package:flutter/material.dart';
import 'package:aoun_app/core/app_export.dart';
import 'package:aoun_app/widgets/custom_elevated_button.dart';
import 'package:aoun_app/widgets/custom_text_form_field.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class ProfileSecurityPage extends StatefulWidget {
  const ProfileSecurityPage({Key? key}) : super(key: key);

  @override
  ProfileSecurityPageState createState() => ProfileSecurityPageState();
}

class ProfileSecurityPageState extends State<ProfileSecurityPage>
    with AutomaticKeepAliveClientMixin<ProfileSecurityPage> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
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
                    SizedBox(height: 97.v),
                    _buildChangePasswordSection(context),
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
  Widget _buildChangePasswordSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Change password",
            style: CustomTextStyles.titleSmallOnPrimarySemiBold,
          ),
          SizedBox(height: 22.v),
          Text(
            "Current password",
            style: theme.textTheme.titleSmall,
          ),
          SizedBox(height: 11.v),
          CustomTextFormField(
            controller: passwordController,
            hintText: "Password",
            textInputType: TextInputType.visiblePassword,
            obscureText: true,
          ),
          SizedBox(height: 27.v),
          Text(
            "New password",
            style: theme.textTheme.titleSmall,
          ),
          SizedBox(height: 11.v),
          CustomTextFormField(
            controller: newpasswordController,
            hintText: "Password",
            textInputAction: TextInputAction.done,
            textInputType: TextInputType.visiblePassword,
            obscureText: true,
          ),
          SizedBox(height: 24.v),
          CustomElevatedButton(
            text: "Update Password",
            buttonStyle: CustomButtonStyles.fillGray,
            onPressed: () => changePassword(context),
          ),
        ],
      ),
    );
  }

  void changePassword(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        // Sign in with the old password to verify user identity
        // await Amplify.Auth.signIn(
        //   username: emailController.text,
        //   password: passwordController.text,
        // );

        // Change password
        await Amplify.Auth.updatePassword(
          newPassword: newpasswordController.text, oldPassword: passwordController.text,
        );

        // Password successfully changed.
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Success'),
            content: Text('Password changed successfully.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } catch (e) {
        // Handle error.
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to change password. ${e.toString()}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
}
