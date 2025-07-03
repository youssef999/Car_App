import 'package:first_project/controllers/login_controller.dart';
import 'package:first_project/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatelessWidget {
  final LoginController _controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('login'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                icon: const Icon(Icons.language, color: Colors.white),
                dropdownColor: primary,
                value: _controller.selectedLanguage.value,
                onChanged: (String? newValue) {
                  _controller.changeLanguage(newValue!);
                },
                items: <String>['en', 'ar', 'ur']
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem(
                    value: value,
                    child: Text(
                      value.tr.toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo and App Name
              Column(
                children: [
                  Lottie.asset(
                    'assets/images/carLogo5.json',
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Fix Car",
                    style: TextStyle(
                      color: textColorDark,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'your_car_service_solution'.tr,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 32),

              // Account Type Selection
              Text(
                'select_your_account_type'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),

              Obx(() => Column(
                children: [
                  // User Option
                  InkWell(
                    onTap: () => _controller.userType.value = 'User',
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _controller.userType.value == 'User'
                            ? primary.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _controller.userType.value == 'User'
                              ? primary
                              : Colors.grey[300]!,
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: _controller.userType.value == 'User'
                                ? primary
                                : Colors.grey,
                            size: 28,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'User'.tr,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: _controller.userType.value == 'User'
                                  ? primary
                                  : Colors.grey[800],
                            ),
                          ),
                          const Spacer(),
                          Radio<String>(
                            value: 'User',
                            groupValue: _controller.userType.value,
                            onChanged: (String? newValue) {
                              _controller.userType.value = newValue!;
                            },
                            activeColor: primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Provider Option
                  InkWell(
                    onTap: () => _controller.userType.value = 'Provider',
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _controller.userType.value == 'Provider'
                            ? primary.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _controller.userType.value == 'Provider'
                              ? primary
                              : Colors.grey[300]!,
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.business,
                            color: _controller.userType.value == 'Provider'
                                ? primary
                                : Colors.grey,
                            size: 28,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Provider'.tr,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: _controller.userType.value == 'Provider'
                                  ? primary
                                  : Colors.grey[800],
                            ),
                          ),
                          const Spacer(),
                          Radio<String>(
                            value: 'Provider',
                            groupValue: _controller.userType.value,
                            onChanged: (String? newValue) {
                              _controller.userType.value = newValue!;
                            },
                            activeColor: primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),

              const SizedBox(height: 32),

              // Phone Number Input
              Text(
                'enter_your_phone_number'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),

              Directionality(
                textDirection: TextDirection.ltr,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        spreadRadius: 1,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _controller.phoneController,
                    decoration: InputDecoration(
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Container(
                        width: 70,
                        padding: const EdgeInsets.only(left: 16),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          '+20',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      hintText:
                      'enter_phone_number_hint'.tr,
                      hintStyle: TextStyle(color: Colors.grey[300]),
                    ),
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),

              // // OTP Input (when needed)
              // Obx(() => _controller.isCodeSent.value
              //     ? Column(
              //   crossAxisAlignment: CrossAxisAlignment.stretch,
              //   children: [
              //     const SizedBox(height: 20),
              //     Text(
              //       'enter_otp_code'.tr,
              //       style: TextStyle(
              //         fontSize: 18,
              //         fontWeight: FontWeight.w600,
              //         color: Colors.grey[800],
              //       ),
              //     ),
              //     const SizedBox(height: 12),
              //     Container(
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(12),
              //         boxShadow: [
              //           BoxShadow(
              //             color: Colors.black.withOpacity(0.05),
              //             blurRadius: 8,
              //             spreadRadius: 1,
              //             offset: const Offset(0, 4),
              //           ),
              //         ],
              //       ),
              //       child: TextField(
              //         controller: _controller.otpController,
              //         decoration: InputDecoration(
              //           contentPadding: const EdgeInsets.symmetric(
              //               vertical: 18, horizontal: 16),
              //           border: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(12),
              //             borderSide: BorderSide.none,
              //           ),
              //           filled: true,
              //           fillColor: Colors.white,
              //           hintText: 'enter_otp_hint'.tr,
              //           hintStyle: TextStyle(color: Colors.grey[500]),
              //           prefixIcon: Icon(Icons.lock_outline,
              //               color: Colors.grey[500]),
              //         ),
              //         keyboardType: TextInputType.number,
              //         style: const TextStyle(fontSize: 16),
              //       ),
              //     ),
              //   ],
              // )
                 // : const SizedBox()),

              const SizedBox(height: 36),

              // Send OTP Button
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    shadowColor: primary.withOpacity(0.3),
                  ),
                  onPressed: () {
                    final box = GetStorage();
                    box.write('userType', _controller.userType.value);
                    print("type==${_controller.userType.value}");
                    Get.toNamed('/OtpView');
                  },
                  // onPressed: () {
                  //   final box = GetStorage();
                  //   box.write('userType', _controller.userType.value);
                  //   _controller.sendOTP(); // ← إرسال الكود هنا
                  // },

                  child: Text(
                    'sendOTP'.tr,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Terms and Privacy Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'by_continuing_you_agree'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ),
            
         ] ),
        ),
    ));
}
}
