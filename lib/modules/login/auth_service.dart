import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class AuthService {

  Future<String?> refreshIdToken() async {
    try {
      // Fetch the current session
      AuthSession session = await Amplify.Auth.fetchAuthSession();

      // Check if the user is signed in
      if (session.isSignedIn) {
        // Check if the session contains user pool tokens
        if (session is CognitoAuthSession) {
          // Retrieve and return the ID token as a string
          return session.userPoolTokens?.idToken.raw;
        }
      }
    } catch (e) {
      print('Error refreshing token: $e');
    }
    return null;
  }

  


}
