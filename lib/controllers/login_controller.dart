import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final List<TextEditingController> otpControllers =
      List.generate(4, (_) => TextEditingController());
  var verificationId = ''.obs;
  var isCodeSent = false.obs;
  var userType = 'User'.obs;
  var selectedLanguage = 'en'.obs;

  void changeLanguage(String languageCode) {
    selectedLanguage.value = languageCode;
    Get.updateLocale(Locale(languageCode));
  }

  Future<void> phoneNumberVerification() async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          Get.offNamed('/HomeView');
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('Error', 'Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId.value = verificationId;
          isCodeSent.value = true;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId.value = verificationId;
        },
        timeout: Duration(seconds: 60),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to send OTP: $e');
      print('================================ ${e}');
    }
  }

  Future<void> verifyOTP() async {
    try {
      String otp = otpControllers.map((controller) => controller.text).join();
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      Get.offNamed('/HomeView');
    } catch (e) {
      Get.snackbar('Error', 'Failed to verify OTP: $e');
    }
  }

  Future<void> resendOTP() async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          Get.offNamed('/HomeView');
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('Error', 'Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId.value = verificationId;
          isCodeSent.value = true;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId.value = verificationId;
        },
        timeout: Duration(seconds: 60),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to resend OTP: $e');
    }
  }
}
