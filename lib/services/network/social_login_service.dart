import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialLoginService {
   GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<GoogleSignInAccount?> handleGoogleSignIn() async {
     _googleSignIn = GoogleSignIn(
      scopes: ['email'],
    );

    GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

    if (googleSignInAccount != null) {
      return googleSignInAccount;
    } else {
      return null;
    }
  
  }

  Future<AuthorizationCredentialAppleID?> appleSignIn() async {
    AuthorizationCredentialAppleID? credential =
        await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    if (credential != null) {
      return null;
    } else {
      return credential;
    }
  }



  logout(){
      _googleSignIn.signOut();
  }
}
