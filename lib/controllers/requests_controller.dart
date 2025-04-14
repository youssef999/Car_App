

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/models/client_request_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RequestsController extends GetxController{



  List<RequestModel>userRequestList=[];
  final box=GetStorage();


  Future<void> getUserRequests() async {

    userRequestList=[];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('userId', isEqualTo: "1")
          //.orderBy('createdAt', descending: true) // Optional: sort by date
          .get();

      userRequestList = querySnapshot.docs.map((doc) {
        return RequestModel.fromFirestore(doc);
      }).toList();

      update(); // Notify listeners (if using GetX)

      print('Fetched ${userRequestList.length} requests for user 1');
    } catch (e) {
      print('Error fetching user requests: $e');
      // Optionally show error to user
      // Get.snackbar('Error', 'Failed to load requests');
    }
  }

  Future<void> cancelRequest(String requestId) async {
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

      print('Successfully deleted request: $requestId');
      getUserRequests();
      // Optional: Show success message to user
      Get.snackbar(
        'Success'.tr,
        'Request cancelled successfully'.tr,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );


    } catch (e) {
      print('Error cancelling request: $e');

      // Show error message to user
      Get.snackbar(
        'Error'.tr,
        'Failed to cancel request: ${e.toString()}'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      // Re-throw the error if you want calling code to handle it
      throw e;
    }
  }



}