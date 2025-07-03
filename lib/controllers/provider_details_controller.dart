
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/models/provider_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../helper/appMessage.dart';
import '../main.dart';
import '../views/user_views/main_user_page.dart';

class ProviderDetailsController extends GetxController{

  final box=GetStorage();
  final formKey = GlobalKey<FormState>();
  final carSize = 'Small'.obs;
  final malfunctionCause = 'Traffic Accident'.obs;
  final isSubmitting = false.obs;

  final RxString loadingRegion = ''.obs;
  final RxString loadingCity = ''.obs;
  final RxString loadingDistrict = ''.obs;

  final RxString destinationRegion = ''.obs;
  final RxString destinationCity = ''.obs;
  final RxString destinationDistrict = ''.obs;


  String userName = '';

  Future<void> getUserName() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: '1')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        userName = querySnapshot.docs.first['name'];
        print("User name: $userName");
      } else {
        print("No user found with id '1'.");
      }
    } catch (e) {
      print("Error fetching user name: $e");
    }
  }

  void submitRequest(Provider provider) {

    sendRequestToProvider(
      providerId: provider.id,
      userId:'1',
      carProblem: malfunctionCause.value,
      carSize: carSize.value,
      placeOfLoading1: loadingRegion.value,
      placeOfLoading2: loadingCity.value,
      placeOfLoading3:  loadingDistrict.value,
      placeToGo1:   destinationRegion.value,
      placeToGo2: destinationCity.value,
      placeToGo3: destinationDistrict.value,
      // servicePricing: _servicePricing.value,
    );
    // Simulate a network request
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAll(MainUserPage());
      //Get.back();
      isSubmitting.value = false;

      appMessage(text:   'Request submitted successfully'.tr, context: Get.context!,
      );


    });
    triggerNotification('طلب جديد ');

   List providerIdList=box.read('providerReqId')??[];

    providerIdList.add(provider.id);

    box.write('providerReqId', providerIdList);
  }


  Future<void> sendRequestToProvider({
    required String providerId,
    required String userId,
    required String carProblem,
    required String carSize,
    required String placeOfLoading1,
    required String placeOfLoading2,
    required String placeOfLoading3,
    required String placeToGo1,
    required String placeToGo2,
    required String placeToGo3,
    // required String servicePricing,
  }) async {
    try {
      // Get a reference to the Firestore instance
      final firestore = FirebaseFirestore.instance;

      // Create a new document in the 'requests' collection with an auto-generated ID
      final docRef = firestore.collection('requests').doc();

      // Get the current timestamp
      final timestamp = DateTime.now();

      // Format the timestamp if needed (optional)
      final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp);

      // Create the request data map
      final requestData = {
        'id': docRef.id, // Use the auto-generated document ID
        'providerId': providerId,
        'userId': userId,
        "userName": userName,
        'carProblem': carProblem,
        'carSize': carSize,
        'hiddenByProvider': false, // Default value
        'placeOfLoading1': placeOfLoading1,
        'placeOfLoading2': placeOfLoading2,
        'placeOfLoading3': placeOfLoading3,
        'placeToGo1': placeToGo1,
        'placeToGo2': placeToGo2,
        'placeToGo3': placeToGo3,
        // 'servicePricing': servicePricing,
        'status': 'pending', // Default status
        'timestamp': timestamp, // Store as Firestore Timestamp
        'formattedDate': formattedDate, // Optional: human-readable date
      };

      // Set the data in the document
      await docRef.set(requestData);



      box.write("request_id",docRef.id.toString());

      print('Request sent successfully with ID: ${docRef.id}');

    } catch (e) {
      print('Error sending request: $e');
      // You might want to rethrow the error or handle it differently
      throw e;
    }
  }
}