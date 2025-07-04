import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/main.dart';
import 'package:first_project/models/provider_model.dart';
import 'package:first_project/views/done/done_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helper/appMessage.dart';

class NearProviderController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<Provider> providers = [];

  final box=GetStorage();


  // Future<void> getServiceProviders() async {
  //   try {
  //     // Get user's current location
  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );
  //     double userLat = position.latitude;
  //     double userLng = position.longitude;

  //     // Fetch all providers
  //     QuerySnapshot querySnapshot =
  //     await _firestore.collection('providers').get();
  //     print("Fetched providers: ${querySnapshot.docs.length}");

  //     // Filter providers within 50 km
  //     List<Provider> nearbyProviders = querySnapshot.docs.map((doc) {
  //       var data = doc.data() as Map<String, dynamic>;
  //       return Provider.fromMap(data);
  //     }).where((provider) {
  //       double distance = Geolocator.distanceBetween(
  //        userLat,
  //         userLng,
  //         provider.location.latitude,
  //         provider.location.longitude,
  //       ) / 1000; // Convert meters to km

  //       return distance <= 5000; // Only keep providers within 50 km
  //     }).toList();

  //     // Update the providers list
  //     providers.assignAll(nearbyProviders);
  //     print("PROVIDERR===$providers");
  //     update();
  //   } catch (e) {
  //     print("Error fetching providers: $e");
  //   }
//   // }



//   Future<void> getServiceProviders({bool useLocation = false}) async {
//   try {
//     double userLat = 0.0;
//     double userLng = 0.0;

//     if (useLocation) {
//       // Get user's current location
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       userLat = position.latitude;
//       userLng = position.longitude;
//     }

//     // Fetch all providers
//     QuerySnapshot querySnapshot =
//         await _firestore.collection('providers').get();
//     print("Fetched providers: ${querySnapshot.docs.length}");

//     // Convert all documents to Provider model
//     List<Provider> allProviders = querySnapshot.docs.map((doc) {
//       var data = doc.data() as Map<String, dynamic>;
//       return Provider.fromMap(data);
//     }).toList();

//     List<Provider> filteredProviders = [];

//     if (useLocation) {
//       // Filter providers within 50 km only if location is enabled
//       filteredProviders = allProviders.where((provider) {
//         double distance = Geolocator.distanceBetween(
//               userLat,
//               userLng,
//               provider.location.latitude,
//               provider.location.longitude,
//             ) /
//             1000; // Convert meters to km

//         return distance <= 50; // Filter within 50 km
//       }).toList();
//     } else {
//       // No filtering – just return all providers
//       filteredProviders = allProviders;
//     }

//     // Update observable list
//     providers.assignAll(filteredProviders);
//     print("PROVIDERS FOUND: ${providers.length}");
//     update();
//   } catch (e) {
//     print("Error fetching providers: $e");
//   }
// }
Future<void> getServiceProviders({
  bool useLocation = false,
  String? requestedCarType, // small, medium, large
}) async {

  print("GETTING PROVIDERS WITH REQUESTED CAR TYPE: $requestedCarType");
  try {
    double userLat = 0.0;
    double userLng = 0.0;

    if (useLocation) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      userLat = position.latitude;
      userLng = position.longitude;
    }

    Query query = _firestore.collection('providers');

    // ✅ فلترة حسب نوع النقل إذا تم تحديده
    if (requestedCarType != null && requestedCarType.isNotEmpty) {
      query = query.where('carTransporterSizes', arrayContainsAny: [requestedCarType]);
    }

    QuerySnapshot querySnapshot = await query.get();
    print("Fetched providers: ${querySnapshot.docs.length}");

    List<Provider> allProviders = querySnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return Provider.fromMap(data);
    }).toList();

    // ✅ فلترة حسب الموقع لو مفعل
    // List<Provider> filteredProviders = [];

    // if (useLocation) {
    //   filteredProviders = allProviders.where((provider) {
    //     double distance = Geolocator.distanceBetween(
    //           userLat,
    //           userLng,
    //           provider.location.latitude,
    //           provider.location.longitude,
    //         ) / 1000;
    //     return distance <= 50;
    //   }).toList();
    // } else {
    //   filteredProviders = allProviders;
    // }

    // providers.assignAll(filteredProviders);
     providers.assignAll(allProviders);
    print("Filtered providers: ${providers.length}");
    update();
  } catch (e) {
    print("Error fetching providers: $e");
  }
}




  bool check = false;
  Timer? _timer;

  @override
  void onInit() {
    getCurrentLocation();
    getCurrentTrips();
   // getProvidersIdFromOffers();
    //_startRepeatingCheck();
    // TODO: implement onInit
    super.onInit();
  }

  List<Map<String, dynamic>> currentTrips = [];
 bool isCurrentTrip=false;
  Future<List<Map<String, dynamic>>> getCurrentTrips() async {
    print("GETTING CURRENT TRIPS");
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('userId', isEqualTo: '1')
          .where('status', isEqualTo: 'accepted')
          .get();
      List<Map<String, dynamic>> trips = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      currentTrips=trips;

      print("currentTrips==${currentTrips.toString()}");
      print("LENGTH==${trips.length}");
      if(currentTrips.isNotEmpty){
        isCurrentTrip=true;
      }
      update();
      return trips;
    } catch (e) {
      print('Error getting current trips: $e');
      return [];
    }
  }


  // void _checkStatus() {
  //   getCurrentLocation();
  //   getProvidersIdFromOffers();
  // }

  void startRepeatingCheck() {
    // print("STARTEDREAPEATING CHECKK,,,,");
    // // Call immediately once
    // _checkStatus();
    // // Then repeat every 4 seconds
    // _timer = Timer.periodic(Duration(seconds: 4), (_) {
    //   print("CHECK......SS");
    //   _checkStatus();
    // });
  }

  @override
  void onClose() {
    countdownTimer?.cancel();
    super.onClose();
  }


  //providerId
  //providers
  //id from providers to get lat and lng
  // Future<void> checkForOrder() async {
  //   try {
  //     // Get a reference to the Firestore collection
  //     final querySnapshot = await FirebaseFirestore.instance
  //         .collection('requests')
  //         .where('userId', isEqualTo: '1')
  //         .where('status', isEqualTo: 'accepted')
  //         .limit(1)  // We only need to know if at least one exists
  //         .get();
  //     // If there are any documents in the query result, set check to true
  //     check = querySnapshot.docs.isNotEmpty;
  //     update();
  //     // Optional: print for debugging
  //     print('User has pending requests: $check');
  //     calculateDistanceAndEstimatedTime();
  //   } catch (e) {
  //     // Handle any errors that might occur
  //     print('Error checking for orders: $e');
  //     check = false;  // Set to false in case of error
  //   }
  // }

  List<String> providerIds = [];

  // Future<void> getProvidersIdFromOffers() async {
  //   try {
  //     final querySnapshot = await FirebaseFirestore.instance
  //         .collection('offers')
  //         .where('status', isEqualTo: 'Pending')
  //         .where('userId', isEqualTo: "1")
  //         .get();
  //     providerIds = querySnapshot.docs
  //         .map((doc) => doc['providerId'].toString())
  //         .toSet()
  //         .toList(); // .toSet() to remove duplicates
  //     print("Accepted providerIds: $providerIds");
  //     update();
  //   } catch (e) {
  //     print("Error fetching offers: $e");
  //   }
  // }

  String requestId = '';

  Future<void> cancelRequestToProvider(String providerId) async {
    final firestore = FirebaseFirestore.instance;
    try {
      // Step 1: Find the request
      final querySnapshot = await firestore
          .collection('requests')
          .where('providerId', isEqualTo: providerId)
          .where('userId', isEqualTo: '1')
          .where('statuses', arrayContainsAny: ['pending', 'requestStart'])
          .get();

      if (querySnapshot.docs.isEmpty) {
        box.remove('providerReqId');
        print("EEmpty");
        //getProvidersIdFromOffers();
       // Get.snackbar('Error'.tr, 'No pending request found'.tr);
        return;
      }

      final doc = querySnapshot.docs.first;
      requestId = doc['id'];

      // Step 2: Delete request document
      await doc.reference.delete();

      // Step 3: Delete related offer
      await deleteOfferByRequestId(requestId);

      // Step 4: Update local storage
      List providerIds = box.read('providerReqId') ?? [];
      providerIds.remove(providerId);
      box.write('providerReqId', providerIds);


      appMessage(text: 'Request Deleted Successfully'.tr, context: Get.context!);



      getCurrentLocation();
      //getProvidersIdFromOffers();

      print('Request and offer successfully cancelled.');
    } catch (e) {
      print('Error cancelling request: $e');
      Get.snackbar('Error'.tr, 'Failed to cancel the request'.tr);


    }
  }

  Future<void> deleteOfferByRequestId(String requestId) async {
    final firestore = FirebaseFirestore.instance;

    try {
      final offerSnapshot = await firestore
          .collection('offers')
          .where('requestId', isEqualTo: requestId)
          .get();

      for (var doc in offerSnapshot.docs) {
        await doc.reference.delete();
      }

      print('Offers deleted for requestId: $requestId');

      triggerNotification('  تم الغا المهمة من قبل المستخدم  ');

    } catch (e) {
      print('Error deleting offers: $e');
    }

  }




  double lat=0;
  double lng=0;

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      await Geolocator.openLocationSettings();
      throw Exception('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever
      throw Exception('Location permissions are permanently denied.');
    }

    // If all checks pass, get the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    print('Current location: Lat=${position.latitude}, Lng=${position.longitude}');
    lat=position.latitude;
    lng=position.longitude;
    update();
    // checkForOrder(position.latitude,position.longitude);
    // checkForOrderIsStarted(position.latitude,position.longitude);
    return position;
  }


  Provider ? selectedProvider;


 // String requestId='';
  Future<void> checkForOrder(double userLat, double userLng) async {
    try {
      // Step 1: Query the 'requests' collection
      final querySnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('userId', isEqualTo: '1') // Replace '1' with real userId if dynamic
          .where('status', isEqualTo: 'accepted')
          .limit(1)
          .get();

      check = querySnapshot.docs.isNotEmpty;

      print('User has pending requests: $check');

      if (check) {
        // Step 2: Get providerId and requestId from the request
        final doc = querySnapshot.docs.first;
        final providerId = doc.data()['providerId'];
       requestId = doc.id; // <-- get requestId here

        print('Provider ID: $providerId');
        print('Request ID: $requestId');

        if (providerId != null) {
          // Step 3: Fetch provider data from 'providers' collection
          final providerSnapshot = await FirebaseFirestore.instance
              .collection('providers')
              .doc(providerId)
              .get();

          if (providerSnapshot.exists) {
            // Step 4: Build Provider object
            final providerData = providerSnapshot.data();
            if (providerData != null) {
              Provider provider = Provider.fromMap(providerData);
              selectedProvider = provider;
              // Step 5: Now calculate distance and estimated time
              calculateDistanceAndEstimatedTime(provider, userLat, userLng, requestId); // pass requestId
            }
          }
        }
      }
    } catch (e) {
      print('Error checking for orders: $e');
      check = false;
    }
    update();
  }

  Future<void> checkForOrderIsStarted(double userLat, double userLng) async {
    try {
      // Step 1: Query the 'requests' collection
      final querySnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('userId', isEqualTo: '1') // Replace '1' with real userId if dynamic
          .where('status', isEqualTo: 'requestStart')
          .limit(1)
          .get();

      check = querySnapshot.docs.isNotEmpty;

     print('User has pending requests: $check');

     // if (check) {
        // Step 2: Get providerId and requestId from the request
        final doc = querySnapshot.docs.first;
        final providerId = doc.data()['providerId'];
        requestId = doc.id; // <-- get requestId here

        print('Provider ID: $providerId');
        print('Request ID: $requestId');

        if (providerId != null) {
          // Step 3: Fetch provider data from 'providers' collection
          final providerSnapshot = await FirebaseFirestore.instance
              .collection('providers')
              .doc(providerId)
              .get();

          if (providerSnapshot.exists) {
            // Step 4: Build Provider object
            final providerData = providerSnapshot.data();
            if (providerData != null) {
              Provider provider = Provider.fromMap(providerData);
              selectedProvider = provider;
              // Step 5: Now calculate distance and estimated time
              calculateDistanceAndEstimatedTime(provider, userLat, userLng, requestId); // pass requestId
            }
       //   }
        }
      }
    } catch (e) {
      print('Error checking for orders: $e');
      //check = false;
    }
    update();
  }

  String status = '';


  int estimatedTime = 0;
  double distance = 0;


  Future<String> getOfferId(String requestId, String providerId) async {
    String offerId = '';
    String price = '';

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('offers')
          .where('requestId', isEqualTo: requestId)
          .where('providerId', isEqualTo: providerId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        offerId = querySnapshot.docs.first.id;
        price= querySnapshot.docs.first['price'].toString();
        rateProvider(providerId,requestId,offerId,price);
      }
    } catch (e) {
      print('Error getting offerId: $e');
    }

    return offerId;
  }


  Future<void> rateProvider(String providerId,String requestId,String offerId,String price) async {

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
    markRequestAsDone(requestId);
    // 3. Add comment to comments collection
    await firestore.collection('comments').add({
      'userId': '1',
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


    Get.offAll(DoneView(price:price,
    providerId: providerId,
    ));
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

    } catch (e) {
      print('Error marking offer as Done: $e');
      // Optional: Show error message
      // Get.snackbar('Error', 'Failed to update offer status');
      rethrow; // Re-throw if you want to handle the error upstream
    }
  }

  Future<void> markRequestAsDone(String requestId) async {

    print("OFFER ID===$requestId");
    try {
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(requestId)
          .update({
        'status': 'Done',
        // '//completedAt': FieldValue.serverTimestamp(),
      });
      print('Request $requestId marked as Done');
      // Optional: Show success message
      // Get.snackbar('Success', 'Offer completed successfully');
    } catch (e) {
      print('Error marking offer as Done: $e');
      // Optional: Show error message
      // Get.snackbar('Error', 'Failed to update offer status');
      rethrow; // Re-throw if you want to handle the error upstream
    }
    getCurrentLocation();
  }



  calculateDistanceAndEstimatedTime(Provider provider, double lat, double lng,String requestId) async {

    double toRadians(double degree) => degree * pi / 180;
    double lat1 = lat;
    double lon1 = lng;
    double lat2 = provider.location.latitude;
    double lon2 = provider.location.longitude;

    print("l====${lat1}==${lon1}==${lat2}==${lon2}");

    const double earthRadiusKm = 6371;

    double dLat = toRadians(lat2 - lat1);
    double dLon = toRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(toRadians(lat1)) * cos(toRadians(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    distance = earthRadiusKm * c;
    distance = double.parse(distance.toStringAsFixed(2)); // round to 2 decimal places
    estimatedTime = (distance * 10).ceil(); // Each 1km = 10 minutes
    makeStopWatch(requestId);
    update();
    print('Distance to provider: $distance km');
    print('Estimated time: $estimatedTime minutes');
  }


  Timer? countdownTimer;

  void makeStopWatch(String requestId) {

    checkIfRequestIsStarted(requestId);
    countdownTimer?.cancel(); // Cancel any previous timer if running
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (estimatedTime > 0 && distance > 0) {
        estimatedTime--;
        distance = (distance - 0.1).clamp(0.0, double.infinity);
        distance = double.parse(distance.toStringAsFixed(2)); // Keep 2 decimals
        update();
        print('Updated - Distance: $distance km, Estimated Time: $estimatedTime minutes');
      } else {
        timer.cancel();
        print('Countdown finished');
      }
      if(estimatedTime==0){

        updateRequestToBeStarted(requestId);

      }
    });
  }


  Future<void> checkForOrderStatus() async {
    try {
      String requestId = box.read('request_id') ?? 'x';

      if (requestId != 'x') {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('requests')
            .doc(requestId)
            .get();
        if (doc.exists) {
          status = doc['status'] ?? 'not_found'; // Get status field or default
          print('Current order status: $status');
        } else {
          status = 'not_found';
          print('Request document not found');
        }
      } else {
        status = 'no_request_id';
        print('No request ID found in local storage');
      }
      update(); // Notify listeners if using GetX
    } catch (e) {
      status = 'error';
      print('Error checking order status: $e');
      // You might want to show an error to the user
      // Get.snackbar('Error', 'Failed to check order status');
    }
  }


  // Future<void> cancelOrder() async {
  //   try {
  //     // Get pending requests for the user
  //     final querySnapshot = await FirebaseFirestore.instance
  //         .collection('requests')
  //         .where('userId', isEqualTo: '1')
  //         .where('status', isEqualTo: 'pending')
  //         .limit(1)
  //         .get();
  //     if (querySnapshot.docs.isNotEmpty) {
  //       // Get the first document ID (request ID)
  //       final requestId = querySnapshot.docs.first.id;
  //
  //       // Delete the request document
  //       await FirebaseFirestore.instance
  //           .collection('requests')
  //           .doc(requestId)
  //           .delete();
  //
  //       print('Successfully deleted request: $requestId');
  //       check = false; // Update status since request was deleted
  //     } else {
  //       print('No pending requests found to cancel');
  //       check = false;
  //     }
  //
  //     update(); // Notify listeners
  //   } catch (e) {
  //     print('Error cancelling order: $e');
  //     check = false; // Set to false in case of error
  //     update();
  //     // Consider showing an error message to the user
  //     // Get.snackbar('Error', 'Failed to cancel order: ${e.toString()}');
  //   }
  // }


  Future<void> openWhatsAppChat(Provider provider) async {
    final String phoneNumber = provider.phone; // تأكد أن phone موجود في Provider
    final Uri whatsappUrl = Uri.parse('https://wa.me/$phoneNumber');

    print(phoneNumber);
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      throw Exception('Could not open WhatsApp chat');
    }
  }

  Future<void> makeCall(Provider provider) async {
    final String phoneNumber = provider.phone;
    final Uri callUrl = Uri.parse('tel:$phoneNumber');

    if (await canLaunchUrl(callUrl)) {
      await launchUrl(callUrl, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(callUrl, mode: LaunchMode.externalApplication);
      throw Exception('Could not make a call');
    }
  }






  Future<void> updateRequestToBeStarted(String requestId) async {
    try {
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(requestId)
          .update({
        'status': 'requestStart',
      });
      print('Request updated successfully.');
    } catch (e) {
      print('Error updating request: $e');
    }
  }

  bool isCheckStart = false;

  Future<void> checkIfRequestIsStarted(String requestId) async {

    print("CHECK REQUEST IS STARTED");
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .doc(requestId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data['status'] == 'requestStart') {
          isCheckStart = true;
        } else {
          isCheckStart = false;
        }
      } else {
        isCheckStart = false;
      }
    } catch (e) {
      print('Error checking if request is started: $e');
      isCheckStart = false;
    }
    print("CHECK REQUEST IS STARTED $isCheckStart");
    update();
  }




}
