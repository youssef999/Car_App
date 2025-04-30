

 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController{


  List<Map<String, dynamic>> userData = [];

  Future<void> getUserData() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: '1')
          .get();

      userData = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      print("User data loaded: $userData");
      update();

    } catch (e) {
      print("Error fetching user data: $e");
    }
  }


}