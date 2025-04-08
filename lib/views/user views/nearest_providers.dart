import 'package:first_project/controllers/near_provider_controller.dart';
import 'package:first_project/values/colors.dart';
import 'package:first_project/views/user%20views/provider_detailed_bottomSheet.dart';
import 'package:first_project/views/user%20views/provider_detailed_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';


 class NearestProvidersPage extends StatefulWidget {

  @override
  State<NearestProvidersPage> createState() => _NearestProvidersPageState();
}

class _NearestProvidersPageState extends State<NearestProvidersPage> {


   NearProviderController controller=Get.put(NearProviderController());
   @override
  void initState() {
     controller.getServiceProviders();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NearProviderController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Nearest Car Transporters'.tr,
              style: const TextStyle(
                  color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
            ),
          ),
          body: FutureBuilder(
            future: requestLocationPermission(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return FutureBuilder<LatLng>(
                  future: getCurrentLocation(),
                  builder: (context, locationSnapshot) {
                    if (locationSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (locationSnapshot.hasError) {
                      return Center(
                          child: Text('Error: ${locationSnapshot.error}'));
                    } else {
                      final currentLocation = locationSnapshot.data!;
                      // Calculate distance for each provider
                      for (var provider in controller.providers) {
                        provider.calculateDistanceFrom(currentLocation);
                      }
                      // Sort providers by distance
                      controller.providers.sort((a, b) => a.distance.compareTo(b.distance));

                      return Column(
                        children: [
                          // Map Section
                          Expanded(
                            flex: 3,
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target:
                                    currentLocation, // Default to current location
                                zoom: 12,
                              ),
                              markers:controller. providers.map((provider) {
                                return Marker(
                                  markerId: MarkerId(provider.id),
                                  position: provider.location,
                                  infoWindow: InfoWindow(
                                    title: provider.name,
                                    snippet:
                                        '${provider.distance.toStringAsFixed(2)} km away'
                                            .tr,
                                  ),
                                  onTap: () {
                                    // Show bottom sheet with provider details
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return ProviderDetailsBottomSheet(
                                            provider: provider);
                                      },
                                    );
                                  },
                                );
                              }).toSet(),
                            ),
                          ),
                          // List of Nearby Providers
                          Expanded(
                            flex: 3,
                            child: ListView.builder(
                              itemCount: controller.providers.length,
                              itemBuilder: (context, index) {
                                final provider =controller. providers[index];
                                return Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    leading: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.orangeAccent.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: const Icon(Icons.car_crash,
                                          color: Colors.orangeAccent),
                                    ),
                                    title: Text(
                                      provider.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '${provider.distance.toStringAsFixed(2)} ',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: primary,
                                              ),
                                            ),
                                            Text(
                                              "km away".tr,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${'Status'.tr}: ${provider.status}",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: (provider.status == 'متاح')
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${'Car_transporter_sizes:'.tr} "
                                              "${provider.carTransporterSizes.join(', ')}"
                                              .replaceAll('small','صغيرة')
                                              .replaceAll('meduim','متوسطة')
                                              .replaceAll('large','كبيرة'),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                          softWrap: true,
                                        ),
                                      ],
                                    ),
                                    trailing: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(6),
                                      child: const Icon(Icons.arrow_forward_ios,
                                          size: 16, color: Colors.black54),
                                    ),
                                    onTap: () {
                                      Get.to(() =>
                                          ProviderDetailsPage(provider: provider));
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  },
                );
              }
            },
          ),
        );
      }
    );
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (!status.isGranted)
    // this operator '!' means that if status is not granted .. مهم جدا
    {
      throw 'Location permission denied';
    }
  }

  Future<LatLng> getCurrentLocation() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, prompt the user to enable them
      throw 'Location services are disabled. Please enable location services.';
    }

    // Check location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request location permissions
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, show a message to the user
      throw 'Location permissions are permanently denied. Please enable them in the app settings.';
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Return the current location as a LatLng object
    return LatLng(position.latitude, position.longitude);
  }
}
