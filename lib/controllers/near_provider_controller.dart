import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/models/provider_model.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class NearProviderController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<Provider> providers = [];

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
}
