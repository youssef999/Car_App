import 'package:first_project/controllers/near_provider_controller.dart';
import 'package:first_project/helper/custom_appbar.dart';
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
  final NearProviderController controller = Get.put(NearProviderController());

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
          backgroundColor: backColor,
          appBar: CustomAppBar(title: 'Nearest Car Transporters'.tr),
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
                    if (locationSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (locationSnapshot.hasError) {
                      return Center(child: Text('Error: ${locationSnapshot.error}'));
                    } else {
                      final currentLocation = locationSnapshot.data!;

                      for (var provider in controller.providers) {
                        provider.calculateDistanceFrom(currentLocation);
                      }
                      controller.providers.sort((a, b) => a.distance.compareTo(b.distance));

                      return ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: SizedBox(
                                height: 250,
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: currentLocation,
                                    zoom: 12,
                                  ),
                                  markers: controller.providers.map((provider) {
                                    return Marker(
                                      markerId: MarkerId(provider.id),
                                      position: provider.location,
                                      infoWindow: InfoWindow(
                                        title: provider.name,
                                        snippet: '${provider.distance.toStringAsFixed(2)} km away'.tr,
                                      ),
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                          ),
                                          builder: (_) => ProviderDetailsBottomSheet(provider: provider),
                                        );
                                      },
                                    );
                                  }).toSet(),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: controller.check == false
                                ? ListView.builder(
                              shrinkWrap: true,
                              physics:const NeverScrollableScrollPhysics(),
                              itemCount: controller.providers.length,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemBuilder: (context, index) {
                                final provider = controller.providers[index];
                                return Container(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 2,
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(16),
                                    leading: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF00BFA5).withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.car_rental_sharp,
                                          color: Color(0xFF00BFA5), size: 28),
                                    ),
                                    title: Text(
                                      provider.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            const Icon(Icons.location_on_outlined,
                                                size: 16, color: Color(0xFF0C3C78)),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${provider.distance.toStringAsFixed(2)} km',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF0C3C78),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(
                                              provider.status == 'نشط'
                                                  ? Icons.check_circle_outline
                                                  : Icons.highlight_off_outlined,
                                              size: 16,
                                              color: provider.status == 'نشط'
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              "${'Status'.tr}: ${provider.status}",
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: provider.status == 'نشط'
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
                                            Expanded(
                                              child: Text(
                                                "${'Car_transporter_sizes:'.tr} ${provider.carTransporterSizes.join(', ')}"
                                                    .replaceAll('small', 'صغيرة')
                                                    .replaceAll('meduim', 'متوسطة')
                                                    .replaceAll('large', 'كبيرة'),
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    trailing: const Icon(Icons.arrow_forward_ios_rounded,
                                        size: 16, color: Colors.black54),
                                    onTap: () {
                                      Get.to(() => ProviderDetailsPage(provider: provider));
                                    },
                                  ),
                                );
                              },
                            )
                                : Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.hourglass_top_rounded,
                                      size: 48, color: Color(0xFF0C3C78)),
                                  const SizedBox(height: 16),
                                  Text(
                                    "Your Order Is Waiting To Be Accepted".tr,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0C3C78),
                                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: controller.cancelOrder,
                                    child: Text(
                                      "Cancel Order".tr,
                                      style: const TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                         const SizedBox(height: 20,)
                        ],
                      );
                    }
                  },
                );
              }
            },
          ),
        );
      },
    );
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (!status.isGranted) {
      throw 'Location permission denied';
    }
  }

  Future<LatLng> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled. Please enable location services.';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied.';
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied. Please enable them in app settings.';
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return LatLng(position.latitude, position.longitude);
  }
}
