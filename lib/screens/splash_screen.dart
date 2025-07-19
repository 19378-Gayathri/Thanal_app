import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:thanal_app/screens/location_permission.dart';
import 'onboarding_screen.dart';                  



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(

       context,
        MaterialPageRoute(builder: (_) =>  const OnboardingScreen()),
      );
    });
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
   body: SizedBox.expand(
  child: FittedBox(
    fit: BoxFit.contain,
    child: Image.asset('assets/splash/splash_screen.png'),
  ),
),
  
  );
 }
}