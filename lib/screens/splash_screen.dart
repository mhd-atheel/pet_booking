import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_booking/components/bottom_navbar.dart';
import 'package:pet_booking/screens/auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  isLogin (){
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        Get.offAll(const AuthScreen());
      } else {
        Get.offAll(const BottomNavbar());
        print('User is signed in!');
      }
    });
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      isLogin();
    });


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             SizedBox(height:MediaQuery.of(context).size.height/5 ,),
             Image.asset(
                 'assets/images/logo.png',
               height: MediaQuery.of(context).size.height/3,
             ),
             SizedBox(height:MediaQuery.of(context).size.height/7 ,),
             const SizedBox(
               height: 40.0,
               width: 40.0,
               child: CircularProgressIndicator(
                 color: Color(0xffF19820),
               ),
             ),
           ],
         ),
      ),
    );
  }
}
