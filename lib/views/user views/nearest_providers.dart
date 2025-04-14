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
    // controller.checkForOrder();
     super.initState();
  }
  @override
  Widget build(BuildContext context) {

    Locale? currentLocale = Get.locale;

// Get language code (returns 'en' or 'ar')
    String languageCode = Get.locale?.languageCode ?? 'ar';


    return GetBuilder<NearProviderController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(

            title: Text(
              'Nearest Car Transporters'.tr,
            ),
          ),
          body:

          FutureBuilder(
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

                          (controller.check == false)
                              ? Expanded(
                            flex: 3,
                            child: ListView.builder(
                              itemCount: controller.providers.length,
                              itemBuilder: (context, index) {
                                final provider = controller.providers[index];
                                return Container(
                                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Card(
                                    elevation: 0, // Using custom shadow instead
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    margin: EdgeInsets.zero,
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      leading: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.orangeAccent.withOpacity(0.8),
                                              Colors.deepOrange.withOpacity(0.8),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.orange.withOpacity(0.4),
                                              blurRadius: 8,
                                              spreadRadius: 2,
                                            )
                                          ],
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        child: const Icon(Icons.local_shipping_rounded,
                                            color: Colors.white, size: 24),
                                      ),
                                      title: Text(
                                        provider.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            letterSpacing: 0.2),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.location_on_outlined,
                                                  size: 16, color: primary),
                                              const SizedBox(width: 4),
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
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              Icon(
                                                provider.status == 'متاح'
                                                    ? Icons.check_circle_outline
                                                    : Icons.highlight_off_outlined,
                                                size: 16,
                                                color: provider.status == 'متاح'
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                "${'Status'.tr}: ${provider.status}",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: provider.status == 'متاح'
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Icon(Icons.directions_car_filled_outlined,
                                                  size: 16, color: Colors.black87),
                                              const SizedBox(width: 4),
                                              (languageCode=='en')?
                                              Expanded(
                                                child: Text(
                                                  "${'Car_transporter_sizes:'.tr} "
                                                      "${provider.carTransporterSizes
                                                      .join(', ')}",
                                                      // .replaceAll('small', 'صغيرة')
                                                      // .replaceAll('meduim', 'متوسطة')
                                                      // .replaceAll('large', 'كبيرة'),
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black87,
                                                  ),
                                                  softWrap: true,
                                                ),
                                              ): Expanded(
                                                child: Text(
                                                  "${'Car_transporter_sizes:'.tr} "
                                                      "${provider.carTransporterSizes
                                                      .join(', ')}"
                                                  .replaceAll('small', 'صغيرة')
                                                  .replaceAll('meduim', 'متوسطة')
                                                  .replaceAll('large', 'كبيرة'),
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black87,
                                                  ),
                                                  softWrap: true,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.grey.withOpacity(0.1),
                                              Colors.grey.withOpacity(0.3),
                                            ],
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        child: const Icon(Icons.arrow_forward_ios_rounded,
                                            size: 16, color: Colors.black54),
                                      ),
                                      onTap: () {
                                        Get.to(() =>
                                            ProviderDetailsPage(provider: provider));
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                              : Container(
                            width: MediaQuery.of(context).size.width*0.98,
                           // height: 100,
                            margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.grey[200],
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.hourglass_top_rounded,
                                    size: 48,
                                    color: primary,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    "Your Order Is Waiting To Be Accepted".tr,
                                    style: TextStyle(
                                      color: textColorDark,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 2,
                                          color: Colors.white.withOpacity(0.8),
                                          offset: const Offset(1, 1),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton(onPressed: (){
                                   controller.cancelOrder();
                                  }, child:
                                  Text("cancelOrder".tr)),
                                  const SizedBox(height: 8),
                                  // CircularProgressIndicator(
                                  //   strokeWidth: 2,
                                  //   color: primary,
                                  // ),
                                ],
                              ),
                            ),
                          )
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
