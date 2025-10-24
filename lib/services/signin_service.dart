import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

// class SignInService{
//   final FirebaseAuth firebaseAuth;
//   SignInService(this.firebaseAuth);
//
//   Future<UserCredential?> SignInWithGoogle() async{
//     try{
//       if(kIsWeb){
//         final googleProvider = GoogleAuthProvider();
//         final userCred = await firebaseAuth.signInWithPopup(googleProvider);
//         return userCred;
//       }
//       final googleSigIn = GoogleSignIn.instance;
//       await googleSigIn.initialize(
//         serverClientId: '',
//         clientId: ''
//       );
//
//       var googleUser = await googleSigIn.attemptLightweightAuthentication();
//       if(googleSigIn.supportsAuthenticate() && googleUser == null){
//         googleUser = await googleSigIn.authenticate();
//       }
//       if(googleUser == null) return null;
//
//       final googleAuth = await googleUser.authentication;
//
//       final credential = GoogleAuthProvider.credential(
//         idToken: googleAuth.idToken,
//       );
//
//       final userCred = await firebaseAuth.signInWithCredential(credential);
//
//       return userCred;
//
//     } catch(e){
//       FirebaseAuthException(message: e.toString(), code: 'auth/account-exists-with-different-credential');
//     }
//   }
// }



class SignInService{

  final FirebaseAuth firebaseAuth;
  SignInService(this.firebaseAuth);

  Future<UserCredential?> signInWithGoogle()async{

    try{
      if(kIsWeb){
        final googleProvider = GoogleAuthProvider();
        final userCred = await firebaseAuth.signInWithPopup(googleProvider);
        return userCred;
      }

      final googleSignIn = await GoogleSignIn.instance;
      await googleSignIn.initialize(
        serverClientId: '',
        clientId: ''
      );
      var googleUser = await googleSignIn.attemptLightweightAuthentication();
      if(googleUser == null && googleSignIn.supportsAuthenticate()){
        googleUser = await googleSignIn.authenticate();
      }
      if(googleUser == null) return null;

      final googleAuth = googleUser.authentication;
      final userCredential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken
      );
      final credential = await firebaseAuth.signInWithCredential(userCredential);
      return credential;


    } catch(e){
      throw Exception(e);
    }

  }


}





























