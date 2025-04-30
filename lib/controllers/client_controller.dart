// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:first_project/helper/send_notification.dart';
import 'package:first_project/main.dart';
import 'package:first_project/views/user%20views/main_user_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/models/provider_offer_model.dart';
import 'package:get/get.dart';

import '../helper/appMessage.dart';

class ClientController extends GetxController {


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = '1'; // Replace with the actual user ID

  // Observable variable to track the current index of the bottom navigation bar
  var currentIndex = 0.obs;

  // Method to change the current index
  void changePage(int index) {
    currentIndex.value = index;
  }

  // @override
  // void onInit() {
  //
  //   super.onInit();
  // }

  var offers = <ProviderOfferModel>[].obs;



 Future<void> rateProvider(String providerId,String requestId,String offerId) async {
  
  final firestore = FirebaseFirestore.instance;
  TextEditingController commentController = TextEditingController();

  double widgetRate=1.0;
  // 1. Show rating dialog
  final result = await Get.dialog(
    AlertDialog(
      title:  Text('Rate Provider'.tr),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('How would you rate this provider?'.tr),
          const SizedBox(height: 16),
          RatingBar.builder(
            initialRating: 3,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              widgetRate=rating;
            },
          ),
          const SizedBox(height: 16),
           TextField(
            controller: commentController,
            decoration: InputDecoration(
              labelText: 'Comment (optional)'.tr,
              border: const OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: (){
Get.back();
          } ,
          child:  Text('Cancel'.tr),
        ),
        TextButton(
          onPressed: () => 
          Get.back(
            result: {
            'rating': widgetRate, // This should come from the rating bar
            'comment': commentController.text, // This should come from the text field
          }),
          child: Text('Submit'.tr),
        ),
      ],
    ),
  );

  if (result == null) return; // User cancelled

  // final rating = result['rate'] as double;
  // final comment = result['comment'] as String;

  // 2. Update provider's average rating
  final providerRef = firestore.collection('providers').doc(providerId);
  await firestore.runTransaction((transaction) async {
    final snapshot = await transaction.get(providerRef);
    final currentData = snapshot.data() as Map<String, dynamic>;
    final currentRating = currentData['rate'] ?? 0.0;
    //final currentRatingsCount = currentData['ratingsCount'] ?? 0;
 print("CURRENT RATE==$currentRating");
  final newRating =( currentRating+widgetRate)/2;
  
  //  ((currentRating * currentRatingsCount) + rating) / 
  //       (currentRatingsCount + 1);

    // final newRating = ((currentRating * currentRatingsCount) + rating) / 
    //     (currentRatingsCount + 1);

    transaction.update(providerRef, {
      'rate': newRating,
     // 'ratingsCount': currentRatingsCount + 1,
    });
  });
  markOfferAsDone(offerId);
  // 3. Add comment to comments collection
  await firestore.collection('comments').add({
    'userId': userId,
    'providerId': providerId,
    'rate': widgetRate,
    //rating,
    'comment': commentController.text,
    'timestamp': FieldValue.serverTimestamp(),
  });
  // updateOffersByRequestId(offerId: offerId
  // , requestId: requestId, updateData: {
  //   'status': 'Rejected'
  // });



  appMessage(text: 'Thank you for your feedback!'.tr, context: Get.context!);
}



Future<void> updateOffersByRequestId({
  required String offerId,
  required String requestId,
  required Map<String, dynamic> updateData,
}) async {

  print("UPDATE OFFERS TO REJETCEDDDDD....");
  try {
    final firestore = FirebaseFirestore.instance;
    
    // First update the specific offer by ID
    await firestore.collection('offers').doc(offerId).update(updateData);
    
    // Then update all other offers with matching requestId
    // that are neither 'Done' nor 'Started'
    final querySnapshot = await firestore.collection('offers')
        .where('requestId', isEqualTo: requestId)
        .where('status', whereNotIn: ['Done', 'Started']) // Correct way to exclude multiple statuses
        .where(FieldPath.documentId, isNotEqualTo: offerId)
        .get();

    // Batch update all matching offers
    final batch = firestore.batch();
    for (final doc in querySnapshot.docs) {
      batch.update(doc.reference, updateData);
    }
    
    await batch.commit();
    
    print('Successfully updated ${querySnapshot.size + 1} offers');
  ///  Get.snackbar('Success', 'Offers updated successfully'); // Show success message

    appMessage(text: 'Offers updated successfully'.tr, context: Get.context!);

  } catch (e) {
    print('Error updating offers: $e');
  //  Get.snackbar('Error', 'Failed to update offers: ${e.toString()}'); // Show error message

    appMessage(text: 'Failed to update offers: ${e.toString()}', context: Get.context!,success: false);
    rethrow;
  }
}
  
  Future<void> markOfferAsDone(String offerId) async {

    print("OFFER ID===$offerId");
  try {
    await FirebaseFirestore.instance
        .collection('offers')
        .doc(offerId)
        .update({
          'status': 'Done',
         // '//completedAt': FieldValue.serverTimestamp(),
        });
    print('Offer $offerId marked as Done');

    fetchOffers();
    // Optional: Show success message
    // Get.snackbar('Success', 'Offer completed successfully');
  } catch (e) {
    print('Error marking offer as Done: $e');
    // Optional: Show error message
    // Get.snackbar('Error', 'Failed to update offer status');
    rethrow; // Re-throw if you want to handle the error upstream
  }
}
// Fetch offers as objects
  Future<void> fetchOffers() async {

    print("FETCH OFFFERRRSSS");

    try {
      final querySnapshot = await _firestore
          .collection('offers')
          .where('userId', isEqualTo: '1')
          .where('status', isNotEqualTo: 'Rejected')
         // .where('show', isNotEqualTo: false)
          // .orderBy('timeOfOffer', descending: true)
          // مش عايز يتعمل الترتيب بالوقت للاسف
          .get();
      offers.value = querySnapshot.docs
          .map((doc) => ProviderOfferModel.fromSnapshot(doc))
          .toList();
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch offers: $e');
      print("EEEE===$e");
    }
  }

Future<void> fetchDoneOffers() async {

    print("FETCH OFFFERRRSSS");

    try {
      final querySnapshot = await _firestore
          .collection('offers')
          .where('userId', isEqualTo: '1')
          .where('status', isNotEqualTo: 'Done')
          
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


      appMessage(text: 'Offer $status', context: Get.context!);

      fetchOffers();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update offer status: $e');
    }
  }

  // Negotiate price using Offer object
  Future<void> negotiateOfferPrice(
      ProviderOfferModel offer, String newPrice) async {
        print("=====OFFER===${offer.id}");
        print("=====PRICE===$newPrice");
    //String? token = await FirebaseMessaging.instance.getToken();
    try {
      await _firestore.collection('offers').doc(offer.id).update({
        'servicePricing': (newPrice),
        "price": (newPrice),
        'status': 'Negotiated',
      });
      //Get.snackbar('Success'.tr, "${'Price updated to'.tr}$newPrice" );

      appMessage(text: "${'Price updated to'.tr}$newPrice", context: Get.context!);
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


    //String? token = await FirebaseMessaging.instance.getToken();
    try {
      // Update the offer status to 'accepted'
      await _firestore.collection('offers').doc(offer.id).update({
        'status': status,
        'acceptedAt': FieldValue.serverTimestamp(),
      });

      print("STATUS====$status");
      if(status=='Started'){
        await _firestore.collection('requests').doc(offer.requestId).update({
          'status': 'accepted',
          // 'acceptedAt': FieldValue.serverTimestamp(),
        });
        final box=GetStorage();

        List providerReqId = box.read('providerReqId')??[];

        providerReqId.remove(offer.providerId);
        box.write('providerReqId', []);

      }

      if(status=='Rejected'){
        await _firestore.collection('requests').doc(offer.requestId).update({
          'status': 'rejected',
          // 'acceptedAt': FieldValue.serverTimestamp(),
        });
        final box=GetStorage();

        List providerReqId = box.read('providerReqId')??[];

        providerReqId.remove(offer.providerId);

        box.write('providerReqId', providerReqId);

      }

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


        appMessage(text: 'Offer accepted and provider notified'.tr, context: Get.context!);
        triggerNotification('تمت الموافقة علي عرضك من قبل العميل ');
        //
        // NotificationService.sendNotification(token.toString()
        //     , 'موافقة علي طلبك ', 'تمت الموافقة ');
      } 
      //Started
        if (status == 'Started') {

        appMessage(text: 'Offer accepted and provider notified'.tr, context: Get.context!);
        triggerNotification('تمت الموافقة علي عرضك من قبل العميل ');
        //
        // NotificationService.sendNotification(token.toString()
        //     , 'موافقة علي طلبك ', 'تمت الموافقة ');
      } 
      
      else {

        appMessage(text:  'Offer rejected and provider notified'.tr, context: Get.context!);
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
