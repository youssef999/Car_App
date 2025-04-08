import 'package:first_project/controllers/login_controller.dart';
import 'package:first_project/values/colors.dart';
import 'package:first_project/views/provider%20views/provider_dashboard.dart';
import 'package:first_project/views/user%20views/main_user_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OtpView extends StatelessWidget {
  OtpView({super.key});

  final LoginController _controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify OTP'.tr),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Enter the 4-digit OTP sent to your phone'.tr,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) => _buildOtpField(index)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(buttonColor),
              ),
              onPressed: () {
                final box = GetStorage();
                String userType = box.read('userType');
                if (userType == 'User') {
                  Get.off(MainUserPage());
                } else {
                  Get.off(ProviderDashboard());
                }

                // Get.offNamed('/HomeView');
              },
              //_controller.verifyOTP,
              child: Text(
                'Verify OTP'.tr,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(buttonColor),
              ),
              onPressed: _controller.resendOTP,
              child: Text(
                'Resend OTP'.tr,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpField(int index) {
    return Container(
      width: 50,
      child: TextField(
        controller: _controller.otpControllers[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: const InputDecoration(
            counterText: '', // Remove the character counter
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder()),
        onChanged: (value) {
          if (value.length == 1 && index < 3) {
            // Move focus to the next field

            FocusScope.of(Get.context!).nextFocus();
          } else {
            // If it's the last field, unfocus
            FocusScope.of(Get.context!).unfocus();
          }
        },
      ),
    );
  }
}
