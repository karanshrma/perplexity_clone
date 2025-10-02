import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:perplexity_clone/pages/home_page.dart';
import 'package:perplexity_clone/theme/colors.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final AuthService authService = AuthService(firebaseAuth);

    void signIn(){
      authService.signInWithGoogle();
      Navigator.push(context , HomePage.route());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

           SizedBox(
             height: 100,
             width: 400,
             child: Image.asset('assets/images/perplexity.png' , scale: 4,),
           ),
            GestureDetector(
              onTap: signIn,
              child: Container(
                height: 90,
                width: 200,

                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15) , color: AppColors.whiteColor,),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.google),
                      const SizedBox(width: 10,),
                      Text(
                        'CONTINUE WITH GOOGLE',
                        style: TextStyle(color: Colors.black , fontSize: 12 , fontWeight: FontWeight.bold),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
