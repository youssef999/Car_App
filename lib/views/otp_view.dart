// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:first_project/controllers/login_controller.dart';
// import 'package:first_project/values/colors.dart';
// import 'package:first_project/views/provider%20views/provider_dashboard.dart';
// import 'package:first_project/views/user_views/main_user_page.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart';

// class OtpView extends StatefulWidget {
//   String otp;
//   OtpView({super.key, required this.otp});

//   @override
//   State<OtpView> createState() => _OtpViewState();
// }

// class _OtpViewState extends State<OtpView> {
//   final LoginController _controller = Get.put(LoginController());

//   @override
//   void initState() {
//     super.initState();
//     // نحدد التركيز لأول خانة لما الشاشة تبدأ
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _controller.otpFocusNodes[0].requestFocus();
//     });
//   }

//   // @override
//   // void dispose() {
//   //   // تأكد من تنظيف الـ FocusNodes و Controllers عشان مايسببوش تسرب ذاكرة
//   //   for (var node in _controller.otpFocusNodes) {
//   //     node.dispose();
//   //   }
//   //   for (var ctrl in _controller.otpControllers) {
//   //     ctrl.dispose();
//   //   }
//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Verify OTP'.tr),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text(
//               'Enter the 4-digit OTP sent to your phone'.tr,
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: List.generate(6, (index) => _buildOtpField(index)),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
//               onPressed: () {
//                 Get.to(MainUserPage());

//                 // لو حبيت تستخدم الـ OTP اللي جاي من الـ widget
//                 // String otp = widget.otp;

//                 // لو حبيت تستخدم الـ OTP من الـ controller
//                 // _controller.verifyOTP(otp);

//                 // هنا ممكن تضيف منطق التحقق من OTP
//                 //  if()

//                 final box = GetStorage();
//                 String userType = box.read('userType');
//                 if (userType == 'User') {
//                   Get.off(MainUserPage());
//                 } else {
//                   Get.off(ProviderDashboard());
//                 }
//                 ////  _controller.verifyOTP();
//               },
//               child: Text(
//                 'Verify OTP'.tr,
//                 style: const TextStyle(
//                     fontWeight: FontWeight.w600, color: Colors.white),
//               ),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
//               onPressed: _controller.resendOTP,
//               child: Text(
//                 'Resend OTP'.tr,
//                 style: const TextStyle(
//                     fontWeight: FontWeight.w600, color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOtpField(int index) {
//     return SizedBox(
//       width: 50,
//       height: 60,
//       child: RawKeyboardListener(
//         focusNode: FocusNode(), // منفصل عن FocusNode الخاص بـ TextField
//         onKey: (event) {
//           if (event is RawKeyDownEvent &&
//               event.logicalKey == LogicalKeyboardKey.backspace) {
//             final currentText = _controller.otpControllers[index].text;
//             if (currentText.isEmpty && index > 0) {
//               // مسح وراجع للخانة السابقة
//               _controller.otpControllers[index - 1].clear();
//               FocusScope.of(context)
//                   .requestFocus(_controller.otpFocusNodes[index - 1]);
//             }
//           }
//         },
//         child: TextField(
//           controller: _controller.otpControllers[index],
//           focusNode: _controller.otpFocusNodes[index],
//           textAlign: TextAlign.center,
//           keyboardType: TextInputType.number,
//           maxLength: 1,
//           style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           decoration: InputDecoration(
//             counterText: '',
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//           ),
//           onChanged: (value) {
//             if (value.isNotEmpty && index < 5) {
//               // روح للخانة اللي بعدها
//               FocusScope.of(context)
//                   .requestFocus(_controller.otpFocusNodes[index + 1]);
//             } else if (value.isEmpty && index > 0) {
//               // ارجع للخانة اللي قبلها لو مسحت
//               FocusScope.of(context)
//                   .requestFocus(_controller.otpFocusNodes[index - 1]);
//             }
//             // آخر خانة تحافظ على الفوكس حتى لو تم كتابة رقم
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:first_project/controllers/login_controller.dart';
import 'package:first_project/values/colors.dart';
import 'package:first_project/views/provider%20views/provider_dashboard.dart';
import 'package:first_project/views/user_views/main_user_page.dart';
import 'package:flutter/services.dart';

class OtpView extends StatefulWidget {
  final String otp;
  const OtpView({super.key, required this.otp});

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  final LoginController _controller = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.otpFocusNodes[0].requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr, // ثابت دايمًا من اليسار لليمين
      child: Scaffold(
        appBar: AppBar(
          title: Text('Verify OTP'.tr),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Enter the 6-digit OTP sent to your phone'.tr,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (index) => _buildOtpField(index),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
                onPressed: () {
                  final box = GetStorage();
                  String userType = box.read('userType');
                  if (userType == 'User') {
                    Get.off(MainUserPage());
                  } else {
                    Get.off(ProviderDashboard());
                  }
                },
                child: Text(
                  'Verify OTP'.tr,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
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
      ),
    );
  }

  Widget _buildOtpField(int index) {
    return SizedBox(
      width: 50,
      height: 60,
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event) {
          if (event is RawKeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            final currentText = _controller.otpControllers[index].text;
            if (currentText.isEmpty && index > 0) {
              _controller.otpControllers[index - 1].clear();
              FocusScope.of(context)
                  .requestFocus(_controller.otpFocusNodes[index - 1]);
            }
          }
        },
        child: TextField(
          controller: _controller.otpControllers[index],
          focusNode: _controller.otpFocusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            counterText: '',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onChanged: (value) {
            if (value.isNotEmpty && index < 5) {
              FocusScope.of(context)
                  .requestFocus(_controller.otpFocusNodes[index + 1]);
            }
          },
        ),
      ),
    );
  }
}

