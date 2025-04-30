import 'package:first_project/controllers/near_provider_controller.dart';
import 'package:first_project/helper/custom_appbar.dart';
import 'package:first_project/helper/custom_button.dart';
import 'package:first_project/models/provider_model.dart';
import 'package:first_project/values/colors.dart';
import 'package:first_project/views/user%20views/offers_page.dart';
import 'package:first_project/views/user%20views/provider_detailed_bottomSheet.dart';
import 'package:first_project/views/user%20views/provider_detailed_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class NearestProvidersPage extends StatefulWidget {
  @override
  State<NearestProvidersPage> createState() => _NearestProvidersPageState();
}

class _NearestProvidersPageState extends State<NearestProvidersPage> {
  final NearProviderController controller = Get.put(NearProviderController());
  LatLng? currentLocation;
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    initLocationAndProviders();
   // controller.getCurrentLocation();
  //  controller.getServiceProviders();
  }

  Future<void> initLocationAndProviders() async {
    try {
      await requestLocationPermission();
      currentLocation = await getCurrentLocation();
      await controller.getServiceProviders();
      if (currentLocation != null) {
        for (var provider in controller.providers) {
          provider.calculateDistanceFrom(currentLocation!);
        }
        controller.providers.sort((a, b) => a.distance.compareTo(b.distance));
      }
    } catch (e) {
      errorMessage = e.toString();
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NearProviderController>(
      builder: (_) {
        return Scaffold(
          backgroundColor: backColor,
          appBar: CustomAppBar(title: 'Nearest Car Transporters'.tr),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(child: Text('Error: $errorMessage'))
              : currentLocation == null
              ?  const Center(child: CircularProgressIndicator())
       //   const Center(child: Text('Unable to fetch location.'))
              : buildContent(),
        );
      },
    );
  }

  Widget buildContent() {
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
                  target: currentLocation!,
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
        controller.check == false ? buildProvidersList() : buildEstimatedTimeAndKm(
          controller.selectedProvider!,''
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildProvidersList() {
    final box = GetStorage();
    List providerReqId = box.read('providerReqId') ?? [];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.providers.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {

        final provider = controller.providers[index];
        final isRequestSent = providerReqId.contains(provider.id);
        final isHaveOffer = controller.providerIds.contains(provider.id);

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
              child: const Icon(Icons.car_rental_sharp, color: Color(0xFF00BFA5), size: 28),
            ),
            title: Text(
              provider.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF0C3C78)),
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
                      provider.status == 'نشط' ? Icons.check_circle_outline : Icons.highlight_off_outlined,
                      size: 16,
                      color: provider.status == 'نشط' ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${'Status'.tr}: ${provider.status}",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: provider.status == 'نشط' ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.directions_car_filled_outlined, size: 16, color: Colors.black87),
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
                const SizedBox(height: 8),
                if (isHaveOffer)
                  Column(
                    children: [
                      Container(
                      //  width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.green, width: 1.2),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.local_offer_outlined, color: Colors.green, size: 20),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 164,
                              child: Text(
                                maxLines: 4,
                                "You have an offer from this provider".tr,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 9,),
                          ],
                        ),
                      ),
                    const  SizedBox(height: 8,),
                      CustomButton(

                          text: 'view offers'.tr, onPressed: (){

                            Get.to(OffersPage());

                      }),
                      const  SizedBox(height: 8,),
                      CustomButton(
                          width: 200,
                          color:Colors.red,
                          text: 'Cancel'.tr, onPressed: (){
                        controller.cancelRequestToProvider(provider.id);

                      }),
                    ],
                  )
                else if (isRequestSent)
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.green, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "request sent to this provider".tr,
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const  SizedBox(height: 8,),
                      CustomButton(
                        width: 200,
                          color:Colors.red,
                          text: 'Cancel'.tr, onPressed: (){
                        controller.cancelRequestToProvider(provider.id);

                      }),
                    ],
                  ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.black54),
            onTap: () {
              if (isRequestSent) {
                Get.snackbar('request sent to this provider'.tr, 'You have already sent a request to this provider.'.tr);
              } else {
                Get.to(() => ProviderDetailsPage(provider: provider));
              }
            },
          ),
        );
      },
    );
  }



  Widget buildEstimatedTimeAndKm(Provider provider,String price) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 22),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 4,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Profile + Name + Rating
          Row(
            children: [
              CircleAvatar(
                radius: 31,
                backgroundImage: NetworkImage(provider.image?? ''),
                backgroundColor: Colors.grey.shade200,
              ),
              const SizedBox(width: 12),
              Text(
                provider.name ?? '',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0C3C78),
                ),
              ),
              const SizedBox(width: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    provider.rate?.toStringAsFixed(1) ?? '0.0',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),

          // Existing Content
          (controller.estimatedTime > 0 && controller.isCheckStart==false)
              ? buildOnWayContent(provider,price)
              : buildWaitingContent(provider,price),
        ],
      ),
    );
  }

  Widget buildOnWayContent(Provider provider,String price) {
    return Container(

      decoration:BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color:Colors.grey[100]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          Text(
            "provider_on_way".tr,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0C3C78),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            "please_wait_provider".tr,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          buildDistanceTimeActions(provider,price),
        ],
      ),
    );
  }

  Widget buildWaitingContent(Provider provider,String price) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color:Colors.grey[100]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          const SizedBox(height: 20),
          Text(
            "may be operation start".tr,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0C3C78),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            "provider should be here".tr,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          buildActionButtons(provider, isSuccessButton: true,price: price),
        ],
      ),
    );
  }

  Widget buildDistanceTimeActions(Provider provider,String price) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const Icon(Icons.place_rounded, size: 30, color: Color(0xFF0C3C78)),
                const SizedBox(height: 8),
                Text(
                  "${controller.distance.toStringAsFixed(1)} ${"km_away".tr}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Icon(Icons.access_time_filled_rounded, size: 30, color: Color(0xFF0C3C78)),
                const SizedBox(height: 8),
                Text(
                  "${controller.estimatedTime} ${"minutes_estimated".tr}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        buildActionButtons(provider, isSuccessButton: false,price:price ),
      ],
    );
  }

  Widget buildActionButtons(Provider provider, {required bool isSuccessButton,required String price}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.call, size: 20, color: Colors.white),
              label: Text('Call'.tr, style: const TextStyle(fontSize: 16, color: Colors.white)),
              onPressed: () {
                controller.makeCall(provider);
              },
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.message, size: 20, color: Colors.white),
              label: Text('Message'.tr, style: const TextStyle(fontSize: 16, color: Colors.white)),
              onPressed: () {
                controller.openWhatsAppChat(provider);
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isSuccessButton ? Colors.green : Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              isSuccessButton ? 'Task Success'.tr : 'Cancel'.tr,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: () {
             if (isSuccessButton==true) {
               controller.getOfferId(controller.requestId,provider.id);
           //    controller.rateProvider(provider.id, re, offerId);
             }
             else{
               controller.cancelRequestToProvider(provider.id);
             }
              //rateProvider
              // Handle cancel or success
            },
          ),
        ),
      ],
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
