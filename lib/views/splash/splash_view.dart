import 'package:first_project/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../login_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    // Navigate after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {

      Get.offAll(LoginPage());
    //  Navigator.pushReplacementNamed(context, '/home'); // Change to your desired route
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,

      //Colors.blue.shade900, // Or your brand color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo with animation

            SizedBox(
              width: 200,
              height: 326,
              child: Lottie.asset(
                'assets/images/carLogo5.json', // Path to your Lottie file
                fit: BoxFit.contain,
                animate: true, // Ensure animation plays
                repeat: true, // Loop the animation
              ),
            ),
            // AnimatedContainer(
            //   duration: const Duration(seconds: 2),
            //   curve: Curves.easeInOut,
            //   width: 150,
            //   height: 150,
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: AssetImage('assets/images/carLogo.json'), // Replace with your logo
            //       fit: BoxFit.contain,
            //     ),
            //   ),
            //   transform: Matrix4.identity()..scale(1.0),
            // ),
            const SizedBox(height: 30),
            // App name with animation
            AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(seconds: 1),
              child: Text(
                'Car Fix'.tr,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}