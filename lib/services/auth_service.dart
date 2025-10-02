import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
class AuthService {
  final FirebaseAuth firebaseAuth;

  AuthService(this.firebaseAuth);

  Future<UserCredential?> signInWithGoogle() async {
    GoogleSignInAccount? googleUser;

    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        final userCredential =  await firebaseAuth.signInWithPopup(googleProvider);
        await _saveUserId(userCredential.user!.uid);
      }
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(
        clientId:
            '620188640445-fdjkv973n5uaid4omtp12kbmfm2ig00a.apps.googleusercontent.com',
        serverClientId:
            '620188640445-qmve8sqfae4ic6q7s1pjisnohslhr6d1.apps.googleusercontent.com',
      );
      googleUser = await googleSignIn.attemptLightweightAuthentication();

      googleUser = await googleSignIn.attemptLightweightAuthentication();

      if (googleSignIn.supportsAuthenticate() && googleUser == null) {
        googleUser = await googleSignIn.authenticate();
      }
      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create Firebase credential using Google auth tokens
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await firebaseAuth
          .signInWithCredential(credential);

      await _saveUserId(userCredential.user!.uid);

      return userCredential;
    } catch (e) {
      print(e.toString());
    }
  }
  Future<void> _saveUserId(String id)async{
    if(id.isEmpty) return;
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('userId', id);
  }

  static Future<String?> getUserId() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }
}
