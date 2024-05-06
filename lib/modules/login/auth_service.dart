import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class AuthService {
  // Method to refresh and get the ID token
  Future<String?> refreshIdToken() async {
    try {
      // Fetch the current session
      AuthSession session = await Amplify.Auth.fetchAuthSession();

      // Check if the user is signed in and if it's a Cognito session
      if (session.isSignedIn && session is CognitoAuthSession) {
        // Retrieve and return the ID token as a string
        return session.userPoolTokens?.idToken.raw;
      }
    } catch (e) {
      print('Error refreshing token: $e');
    }
    return null;
  }

  // Public method to get the token
  Future<String?> getToken(BuildContext context) async {
    // Call the refreshIdToken method
    var idToken = await refreshIdToken();

    if (idToken != null) {
      return idToken;
    } else {
      // Sign out the user and redirect to login screen
      print("Token not available, signing out.");
      await Amplify.Auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      return null;
    }
  }
}
