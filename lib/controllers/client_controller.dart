import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:first_project/helper/send_notification.dart';
import 'package:first_project/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/models/provider_offer_model.dart';
import 'package:get/get.dart';

class ClientController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = 'user123'; // Replace with the actual user ID

  // Observable variable to track the current index of the bottom navigation bar
  var currentIndex = 0.obs;

  // Method to change the current index
  void changePage(int index) {
    currentIndex.value = index;
  }

  @override
  void onInit() {
    fetchOffers();
    super.onInit();
  }

  var offers = <ProviderOfferModel>[].obs;

// Fetch offers as objects
  Future<void> fetchOffers() async {

    print("FETCH OFFFERRRSSS");

    try {
      final querySnapshot = await _firestore
          .collection('offers')
          .where('userId', isEqualTo: '1')
          .where('status', isNotEqualTo: 'Rejected')
          // .orderBy('timeOfOffer', descending: true)
          // مش عايز يتعمل الترتيب بالوقت للاسف
          .get();

      offers.value = querySnapshot.docs
          .map((doc) => ProviderOfferModel.fromSnapshot(doc))
          .toList();



    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch offers: $e');
      print("EEEE===$e");
    }
  }

  // Update status using Offer object
  Future<void> rejectOffer(ProviderOfferModel offer, String status) async {

    try {
      await _firestore.collection('offers').doc(offer.id).update({
        'status': status,
      });
      Get.snackbar('Success', 'Offer $status');

      fetchOffers();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update offer status: $e');
    }
  }

  // Negotiate price using Offer object
  Future<void> negotiateOfferPrice(
      ProviderOfferModel offer, String newPrice) async {
    String? token = await FirebaseMessaging.instance.getToken();
    try {
      await _firestore.collection('offers').doc(offer.id).update({
        'price': int.parse(newPrice),
        'status': 'Negotiated',
      });
      Get.snackbar('Success'.tr, "${'Price updated to'.tr}$newPrice" );
      // NotificationService.sendNotification
      //   (token!, 'تفاوض','تم ارسال طلب تفاوض ');
      triggerNotification('تم ارسال طلب تفاوض');

      fetchOffers();
    } catch (e) {
      Get.snackbar('Error', 'Failed to negotiate: $e');
    }
  }

  Future<void> sendPushNotification(String providerToken) async {
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=YOUR_SERVER_KEY', // Replace with your Firebase Server Key
    };
    final body = {
      'to': providerToken,
      'notification': {
        'title': 'طلب جديد',
        //'New Order Accepted',
        'body': 'طلب جديد بانتظار الموافقة ',
      },
      'data': {
        'orderId': 'order123', // Replace with actual order ID
        'type': 'order_accepted',
      },
    };

    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));

    if (response.statusCode == 200) {
      print('Push notification sent successfully');
    } else {
      print('Failed to send push notification: ${response.body}');
    }
  }

  Future<void> changeOfferStatus(
      ProviderOfferModel offer, String status) async {

    String? token = await FirebaseMessaging.instance.getToken();
    try {
      // Update the offer status to 'accepted'
      await _firestore.collection('offers').doc(offer.id).update({
        'status': status,
        'acceptedAt': FieldValue.serverTimestamp(),
      });
      fetchOffers();
      // Send a notification to the provider
      await _firestore.collection('notifications').add({
        'type': 'order_accepted',
        'orderId': offer.id,
        'userId': offer.userId, // The client's ID
        'providerId': offer.providerId, // The provider's ID
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
        'carSize': offer.carSize, // Add car size if available
        'placeOfLoading':
            offer.placeOfLoading, // Add loading location if available
        'destination': offer.destination, // Add destination if available
      });
      // Send a push notification to the provider
      final providerDoc =
          await _firestore.collection('providers').doc(offer.providerId).get();
      final providerToken = providerDoc.data()?['fcmToken'];
      if (providerToken != null) {
        await sendPushNotification(providerToken);
      }

      if (status == 'Accepted') {

        Get.snackbar('Success'.tr, 'Offer accepted and provider notified'.tr,
        colorText:Colors.white,
        backgroundColor:Colors.green,
        );
        triggerNotification('تمت الموافقة علي عرضك من قبل العميل ');
        //
        // NotificationService.sendNotification(token.toString()
        //     , 'موافقة علي طلبك ', 'تمت الموافقة ');
      } else {
        Get.snackbar('Success'.tr, 'Offer rejected and provider notified'.tr);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to accept offer: $e');
    }
  }

  Future<void> sendOrderToFirestore({
    required String userId,
    required String providerId,
    required String carSize,
    required String carProblem,
    required String placeOfLoading1,
    required String placeOfLoading2,
    required String placeOfLoading3,
    required String placeToGo1,
    required String placeToGo2,
    required String placeToGo3,
  }) async {
    try {
      // Reference to the Firestore collection
      CollectionReference orders = FirebaseFirestore.instance.collection('requests');

      // Create a new document with an empty data object to get the auto-generated ID
      DocumentReference docRef = orders.doc(); // Creates a document with an auto-generated ID

      // Get the auto-generated document ID
      String documentId = docRef.id;

      // Add data to the document, including the document ID
      await docRef.set({
        'id': documentId, // Include the document ID in the stored data
        'userId': userId,
        'providerId': providerId,
        'carSize': carSize,
        'carProblem': carProblem,
        'placeOfLoading1': placeOfLoading1,
        'placeOfLoading2': placeOfLoading2,
        'placeOfLoading3': placeOfLoading3,
        'placeToGo1': placeToGo1,
        'placeToGo2': placeToGo2,
        'placeToGo3': placeToGo3,
        'hiddenByProvider': false,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(), // Add a timestamp
      });

      print('Order sent to Firestore successfully! Document ID: $documentId');
    } catch (e) {
      print('Error sending order to Firestore: $e');
    }
  }
}
