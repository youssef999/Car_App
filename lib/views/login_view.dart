import 'package:first_project/controllers/login_controller.dart';
import 'package:first_project/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginPage extends StatelessWidget {
  final LoginController _controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('login'.tr),
        centerTitle: true,
        actions: [
          DropdownButton<String>(
            iconEnabledColor: Colors.white,
            dropdownColor: primary,
            iconDisabledColor: const Color.fromARGB(255, 180, 132, 129),
            value: _controller.selectedLanguage.value,
            onChanged: (String? newValue) {
              _controller.changeLanguage(newValue!);
            },
            items: <String>['en', 'ar', 'ur']
                .map<DropdownMenuItem<String>>(
                  (String value) => DropdownMenuItem(
                    value: value,
                    child: Text(value.tr),
                  ),
                )
                .toList(),
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
      body: 
      
     Padding(
  padding: const EdgeInsets.all(16.0),
  child: ListView(
    children: [
      Image.asset(
        'assets/images/carLogo.webp',
        height: 170,
      ),
      const SizedBox(height: 21),

      
      Text(
        'select your account type :'.tr,
        style: const TextStyle(
          fontSize: 18, // تكبير النص قليلاً
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 10),

      Obx(() => Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: RadioListTile<String>(
                  title: Text(
                    'User'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  value: 'User',
                  groupValue: _controller.userType.value,
                  onChanged: (String? newValue) {
                    _controller.userType.value = newValue!;

                  },
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 4, 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: RadioListTile<String>(
                  title: Text(
                    'Provider'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  value: 'Provider',
                  groupValue: _controller.userType.value,
                  onChanged: (String? newValue) {
                    _controller.userType.value = newValue!;
                  },
                ),
              ),
            ],
          )),

      const SizedBox(height: 30),

   
      Text(
        'Enter your phone number'.tr,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 8),

      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _controller.phoneController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
                vertical: 14, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            labelText: '+20',
            hintText: 'Enter your phone number'.tr,
          ),
          keyboardType: TextInputType.phone,
        ),
      ),

      Obx(() => _controller.isCodeSent.value
          ? Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      spreadRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controller.otpController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'otp'.tr,
                    hintText: 'Enter OTP',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            )
          : const SizedBox()),

      const SizedBox(height: 30),

      // زر إرسال OTP
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4, // إضافة ظل للزر
            ),
            onPressed: () {
                  final box=GetStorage();
                  box.write('userType', _controller.userType.value);
                  print("type==${_controller.userType.value}");
                  Get.toNamed('/OtpView');
            },
            child: Text(
              'sendOTP'.tr,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      const SizedBox(height: 20),
    ],
  ),
),

    );
  }
}
