

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/helper/appMessage.dart';
import 'package:first_project/models/client_request_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../views/user_views/main_user_page.dart';

class RequestsController extends GetxController{



  List<RequestModel>userRequestList=[];
  final box=GetStorage();


  Future<void> getUserRequests() async {
   userRequestList=[];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('userId', isEqualTo: "1")
          .orderBy('timestamp', descending: true) // Optional: sort by date
          .get();

      userRequestList = querySnapshot.docs.map((doc) {
        return RequestModel.fromFirestore(doc);
      }).toList();

      update(); // Notify listeners (if using GetX)

      print('Fetched ${userRequestList.length} requests for user 1');
      print('Fetched data=== ${userRequestList.toString()} requests for user 1');

       // for(int i=0;i<userRequestList.length;i++){
       //   print('Fetched data=== ${userRequestList[i].providerId} requests for user 1');
       //   print('Fetched data=== ${userRequestList[i].placeOfLoading} requests for user 1');
       //   print('Fetched data=== ${userRequestList[i].placeOfLoading2} requests for user 1');
       //   print('Fetched data=== ${userRequestList[i].placeOfLoading3} requests for user 1');
       // }
    } catch (e) {
      print('Error fetching user requests: $e');
      // Optionally show error to user
      // Get.snackbar('Error', 'Failed to load requests');
    }
  }

  Future<void> cancelRequest(String requestId,String providerId) async {
    try {
      // First check if the request exists
      final docSnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .doc(requestId)
          .get();

      if (!docSnapshot.exists) {
        throw Exception('Request not found');
      }

      // Delete the request document
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(requestId)
          .delete();

      final querySnapshot = await FirebaseFirestore.instance
          .collection('offers')
          .where('requestId', isEqualTo: requestId)
          .get();

// Step 2: Delete each document in a batch (for efficiency)
      final batch = FirebaseFirestore.instance.batch();
      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

// Step 3: Commit the batch
      await batch.commit();


      print('Successfully deleted request: $requestId');
      getUserRequests();
      // Optional: Show success message to user


      appMessage(text:  'Request cancelled successfully'.tr , context: Get.context!,
      );


      List providerIds = box.read('providerReqId') ?? [];

      providerIds.remove(providerId);
      await box.write('providerReqId', providerIds);
      print("ProviderReqId=========="+providerIds.toString());

      Get.offAll(MainUserPage(
        index: 0,
      ));

    } catch (e) {
      print('Error cancelling request: $e');

      appMessage(text:   'Failed to cancel request: ${e.toString()}'.tr, context: Get.context!,
success: false
      );

      // Re-throw the error if you want calling code to handle it
      throw e;
    }
  }



}