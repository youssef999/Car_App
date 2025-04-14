import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/models/provider_model.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';

class NearProviderController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<Provider> providers = [];

  final box=GetStorage();
  @override
  // ignore: unnecessary_overrides
  void onInit() {
    super.onInit();
   // getServiceProviders();
  }

  Future<void> getServiceProviders() async {
    try {
      // Get user's current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      double userLat = position.latitude;
      double userLng = position.longitude;

      // Fetch all providers
      QuerySnapshot querySnapshot =
      await _firestore.collection('providers').get();

      // Filter providers within 50 km
      List<Provider> nearbyProviders = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return Provider.fromMap(data);
      }).where((provider) {
        double distance = Geolocator.distanceBetween(
          userLat,
          userLng,
          provider.location.latitude,
          provider.location.longitude,
        ) / 1000; // Convert meters to km

        return distance <= 5000; // Only keep providers within 50 km
      }).toList();

      // Update the providers list
      providers.assignAll(nearbyProviders);
      print("PROVIDERR===$providers");
      update();
    } catch (e) {
      print("Error fetching providers: $e");
    }
  }

  bool check = false;

  Future<void> checkForOrder() async {


    try {
      // Get a reference to the Firestore collection
      final querySnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('userId', isEqualTo: '1')
          .where('status', isEqualTo: 'pending')
          .limit(1)  // We only need to know if at least one exists
          .get();

      // If there are any documents in the query result, set check to true
      check = querySnapshot.docs.isNotEmpty;
      update();
      // Optional: print for debugging
      print('User has pending requests: $check');
    } catch (e) {
      // Handle any errors that might occur
      print('Error checking for orders: $e');
      check = false;  // Set to false in case of error
    }
  }

  String status = '';

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


  Future<void> cancelOrder() async {
    try {
      // Get pending requests for the user
      final querySnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('userId', isEqualTo: '1')
          .where('status', isEqualTo: 'pending')
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document ID (request ID)
        final requestId = querySnapshot.docs.first.id;

        // Delete the request document
        await FirebaseFirestore.instance
            .collection('requests')
            .doc(requestId)
            .delete();

        print('Successfully deleted request: $requestId');
        check = false; // Update status since request was deleted
      } else {
        print('No pending requests found to cancel');
        check = false;
      }

      update(); // Notify listeners
    } catch (e) {
      print('Error cancelling order: $e');
      check = false; // Set to false in case of error
      update();
      // Consider showing an error message to the user
      // Get.snackbar('Error', 'Failed to cancel order: ${e.toString()}');
    }
  }




}
