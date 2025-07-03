

 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController{


  List<Map<String, dynamic>> userData = [];
  List<Map<String, dynamic>> providerData = [];

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

  Future<void> getProviderData() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('providers')
          .where('id', isEqualTo: 'FggHT4Zv4CdEmX4RQqZx')
          .get();

      providerData
      = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      print("Provider data loaded: $userData");
      update();

    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

}