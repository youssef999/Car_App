

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var phoneController = TextEditingController();
  var otpController = TextEditingController();
  var isCodeSent = false.obs;
  var verificationId = ''.obs;
  var userType = 'User'.obs;
  var selectedLanguage = 'ar'.obs;

  List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
  List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());

  // void changeLanguage(String lang) {
  //   selectedLanguage.value = lang;
  //   var locale = Locale(lang);
  //   Get.updateLocale(locale);
  // }

  void changeLanguage(String lang) {
  selectedLanguage.value = lang;
  var locale = Locale(lang);
  Get.updateLocale(locale);

  // ✅ امسح كل خانات الـ OTP لما اللغة تتغير
  for (var ctrl in otpControllers) {
    ctrl.clear();
  }
}

  Future<void> sendOTP() async {
    print("Sending OTP to: ${phoneController.text.trim()}");
    String phone = '+20${phoneController.text.trim()}';
    print("phone: $phone");
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        print(" verification completed");
        Get.offAllNamed('/MainUserPage');
      },
      verificationFailed: (FirebaseAuthException e) {
        Get.snackbar( e.message.toString() ,'');
        print("Verification failed: ${e.message}");
      },
      // codeSent: (String verId, int? resendToken) {
      //   print("Code sent to $phone");
      //   verificationId.value = verId;
      //   print("Verification ID:$resendToken");
      //   isCodeSent.value = true;
      //   Get.toNamed('/OtpView', arguments: {'otp': ''});
      // },

      codeSent: (String verId, int? resendToken) {
  verificationId.value = verId;
  print("✅ OTP code has been 'sent' (test mode). Use 123456"); // ✅ للطباعة
  isCodeSent.value = true;
  Get.toNamed('/OtpView');
},
      codeAutoRetrievalTimeout: (String verId) {
        verificationId.value = verId;
      },
    );
  }

  Future<void> verifyOTP() async {
    String otp = otpControllers.map((c) => c.text).join();
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId.value,
      smsCode: otp,
    );

    try {
      await _auth.signInWithCredential(credential);
      // Navigate to main screen
      if (userType.value == 'User') {
        Get.offAllNamed('/MainUserPage');
      } else {
        Get.offAllNamed('/ProviderDashboard');
      }
    } catch (e) {
      Get.snackbar("Error", "OTP verification failed");
    }
  }

  void resendOTP() {
    isCodeSent.value = false;
    sendOTP();
  }
}

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class LoginController extends GetxController {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   var phoneController = TextEditingController();
//   var otpController = TextEditingController();
//   var isCodeSent = false.obs;
//   var verificationId = ''.obs;
//   var userType = 'User'.obs;
//   var selectedLanguage = 'ar'.obs;

//   List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
//   List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());

//   void changeLanguage(String lang) {
//     selectedLanguage.value = lang;
//     var locale = Locale(lang);
//     Get.updateLocale(locale);
//   }

//   Future<void> sendOTP() async {
//     String phone = '+20${phoneController.text.trim()}';
//     print("📲 Sending OTP to $phone");

//     await _auth.verifyPhoneNumber(
//       phoneNumber: phone,
//       timeout: const Duration(seconds: 60),
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         print("✅ Auto-verifying with credential...");
//         await _auth.signInWithCredential(credential);
//         _goToMain();
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         Get.snackbar("خطأ", e.message ?? "فشل التحقق");
//         print("❌ Verification failed: ${e.message}");
//       },
//       codeSent: (String verId, int? resendToken) {
//         print("📨 Code sent to $phone, Verification ID: $verId");
//         verificationId.value = verId;
//         isCodeSent.value = true;
//         Get.toNamed('/OtpView');
//       },
//       codeAutoRetrievalTimeout: (String verId) {
//         verificationId.value = verId;
//         print("⏳ Code auto-retrieval timeout");
//       },
//     );
//   }

//   Future<void> verifyOTP() async {
//     String otp = otpControllers.map((c) => c.text).join();
//     print("🔐 Verifying OTP: $otp");

//     try {
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: verificationId.value,
//         smsCode: otp,
//       );
//       await _auth.signInWithCredential(credential);
//       _goToMain();
//     } catch (e) {
//       Get.snackbar("Error", "OTP verification failed");
//       print("❌ OTP verification error: $e");
//     }
//   }

//   void resendOTP() {
//     isCodeSent.value = false;
//     sendOTP();
//   }

//   void _goToMain() {
//     if (userType.value == 'User') {
//       Get.offAllNamed('/MainUserPage');
//     } else {
//       Get.offAllNamed('/ProviderDashboard');
//     }
//   }
// }



