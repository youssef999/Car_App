import 'package:first_project/controllers/login_controller.dart';
import 'package:get/get.dart';

class MyBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(LoginController());
  }
}
