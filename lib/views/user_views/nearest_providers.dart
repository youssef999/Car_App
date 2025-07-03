// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:first_project/controllers/near_provider_controller.dart';
// import 'package:first_project/helper/appMessage.dart';
// import 'package:first_project/helper/custom_appbar.dart';
// import 'package:first_project/helper/custom_button.dart';
// import 'package:first_project/models/provider_model.dart';
// import 'package:first_project/values/colors.dart';
// import 'package:first_project/views/user_views/offers_page.dart';
// import 'package:first_project/views/user_views/provider_detailed_bottomSheet.dart';
// import 'package:first_project/views/user_views/provider_detailed_page.dart';
// import 'package:first_project/views/user_views/requests_view.dart';
// // import 'package:first_project/values/colors.dart';
// // import 'package:first_project/views/user%20views/offers_page.dart';
// // import 'package:first_project/views/user%20views/provider_detailed_bottomSheet.dart';
// // import 'package:first_project/views/user%20views/provider_detailed_page.dart';
// // import 'package:first_project/views/user%20views/requests_view.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:permission_handler/permission_handler.dart';

// class NearestProvidersPage extends StatefulWidget {

//   bool isBack;
//   NearestProvidersPage({Key? key, required this.isBack}) : super(key: key);


//   @override
//   State<NearestProvidersPage> createState() => _NearestProvidersPageState();
// }

// class _NearestProvidersPageState extends State<NearestProvidersPage> {
//  final NearProviderController controller = Get.put(NearProviderController());
//   LatLng currentLocation = const LatLng(24.7136, 46.6753); // موقع ثابت في الرياض
//   bool isLoading = false;
//   String? errorMessage;
//   final box = GetStorage();

//   @override
//   void initState() {
//     controller.startRepeatingCheck();
//     initLocationAndProviders();
//     super.initState();
//   }

//   Future<void> initLocationAndProviders() async {
//     try {
//       await controller.getServiceProviders();
//       for (var provider in controller.providers) {
//         provider.calculateDistanceFrom(currentLocation);
//       }
//       controller.providers.sort((a, b) => a.distance.compareTo(b.distance));
//     } catch (e) {
//       errorMessage = e.toString();
//     }
//     setState(() {});
//   }



//   List<String> providerIds = [];

//   Future<void> checkProviderLocal() async {
//     print("CHECK PROVIDER LOCAL");
//     // Clear previous data
//     providerIds.clear();
//     // Get all requests where userId is "1"
//     final requestsSnapshot = await FirebaseFirestore.instance
//         .collection('requests')
//         .where('userId', isEqualTo: "1")
//         .get();

//     // Extract all request IDs
//     final requestIds = requestsSnapshot.docs.map((doc) => doc.id).toList();
//     print("RequestIds: $requestIds");

//     if (requestIds.isEmpty) return;

//     // Get all checkLocal documents to delete
//     final checkLocalSnapshot = await FirebaseFirestore.instance
//         .collection('checkLocal')
//         .where('requestId', whereIn: requestIds)
//         .get();

//     print("Documents to delete: ${checkLocalSnapshot.docs.length}");

//     // Batch delete for better performance
//     final batch = FirebaseFirestore.instance.batch();
//     for (final doc in checkLocalSnapshot.docs) {
//       batch.delete(doc.reference);
//     }
//     await batch.commit();

//     // Extract providerIds before deleting (if still needed)
//     providerIds = checkLocalSnapshot.docs
//         .map((doc) => doc['providerId'] as String)
//         .toList();
//     print("ProviderIds:::::::: $providerIds");


//     if(providerIds.isNotEmpty){
//       for(int i=0;i<providerIds.length;i++){
//         print("ProviderIdsVal: ${providerIds[i]}");
//         providerIds.remove(providerIds[i]);
//       }
//       // Clear local storage
//       await box.write('providerReqId', providerIds);
//       print("ProviderReqId=========="+providerIds.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<NearProviderController>(
//       builder: (_) {
//         return Scaffold(
//           backgroundColor: backColor,
//           appBar: CustomAppBar(title: 'Nearest Car Transporters'.tr,
//           back:widget.isBack,
//           ),
//           body: isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : errorMessage != null
//               ? Center(child: Text('Error: $errorMessage'))
//               : currentLocation == null
//               ?  const Center(child: CircularProgressIndicator())
//        //   const Center(child: Text('Unable to fetch location.'))
//               : buildContent(),
//         );
//       },
//     );
//   }

//   Widget buildContent() {
//     return ListView(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(20),
//             child: SizedBox(
//               height: 250,
//               child: GoogleMap(
//                 initialCameraPosition: CameraPosition(
//                   target: currentLocation!,
//                   zoom: 12,
//                 ),
//                 markers: controller.providers.map((provider) {
//                   return Marker(
//                     markerId: MarkerId(provider.id),
//                     position: provider.location,
//                     infoWindow: InfoWindow(
//                       title: provider.name,
//                       snippet: '${provider.distance.toStringAsFixed(2)} km away'.tr,
//                     ),
//                     onTap: () {
//                       showModalBottomSheet(
//                         context: context,
//                         shape: const RoundedRectangleBorder(
//                           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                         ),
//                         builder: (_) => ProviderDetailsBottomSheet(provider: provider),
//                       );
//                     },
//                   );
//                 }).toSet(),
//               ),
//             ),
//           ),
//         ),
//         controller.check == false ? buildProvidersList()
//             : buildEstimatedTimeAndKm(
//           controller.selectedProvider!,''
//         ),

//         const SizedBox(height: 20),
//       ],
//     );
//   }

//   Widget buildProvidersList() {
//     final box = GetStorage();
//     List providerReqId = box.read('providerReqId') ?? [];

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: controller.providers.length,
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       itemBuilder: (context, index) {

//         final provider = controller.providers[index];
//         final isRequestSent = providerReqId.contains(provider.id);
//         final isHaveOffer = controller.providerIds.contains(provider.id);

//         return Container(
//           margin: const EdgeInsets.symmetric(vertical: 8),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.3),
//                 spreadRadius: 2,
//                 blurRadius: 12,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: ListTile(
//             contentPadding: const EdgeInsets.all(16),
//             leading: Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF00BFA5).withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(Icons.car_rental_sharp, color: Color(0xFF00BFA5), size: 28),
//             ),
//             title: Text(
//               provider.name,
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 6),
//                 Row(
//                   children: [
//                     const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF0C3C78)),
//                     const SizedBox(width: 4),
//                     Text(
//                       '${provider.distance.toStringAsFixed(2)} km',
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xFF0C3C78),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 6),
//                 Row(
//                   children: [
//                     Icon(
//                       provider.status == 'نشط' ? Icons.check_circle_outline : Icons.highlight_off_outlined,
//                       size: 16,
//                       color: provider.status == 'نشط' ? Colors.green : Colors.red,
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       "${'Status'.tr}: ${provider.status}",
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                         color: provider.status == 'نشط' ? Colors.green : Colors.red,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 6),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Icon(Icons.directions_car_filled_outlined, size: 16, color: Colors.black87),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       child: Text(
//                         "${'Car_transporter_sizes:'.tr} ${provider.carTransporterSizes.join(', ')}"
//                             .replaceAll('small', 'صغيرة')
//                             .replaceAll('meduim', 'متوسطة')
//                             .replaceAll('large', 'كبيرة'),
//                         style: const TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 if (isHaveOffer)
//                   Column(
//                     children: [
//                       Container(
//                       //  width: double.infinity,
//                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                         decoration: BoxDecoration(
//                           color: Colors.green.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(color: Colors.green, width: 1.2),
//                         ),
//                         child: Row(
//                           children: [
//                             const Icon(Icons.local_offer_outlined, color: Colors.green, size: 20),
//                             const SizedBox(width: 8),
//                             SizedBox(
//                               width: 164,
//                               child: Text(
//                                 maxLines: 4,
//                                 "You have an offer from this provider".tr,
//                                 style: const TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 9,),
//                           ],
//                         ),
//                       ),
//                     const  SizedBox(height: 8,),
//                       CustomButton(

//                           text: 'view offers'.tr, onPressed: (){

//                             Get.to(OffersPage());

//                       }),
//                       const  SizedBox(height: 8,),

//                       CustomButton(
//                           width: 260,
//                           color:Colors.orange,
//                           text: 'View Order Details'.tr, onPressed: (){

//                         Get.to(const RequestsView());

//                         // controller.cancelRequestToProvider(provider.id);
//                       }),
//                       // CustomButton(
//                       //     width: 200,
//                       //     color:Colors.red,
//                       //     text: 'Cancelxx'.tr, onPressed: (){
//                       //   controller.cancelRequestToProvider(provider.id);
//                       //
//                       // }),
//                     ],
//                   )
//                 else if (isRequestSent)
//                   Column(
//                     children: [
//                       Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                         decoration: BoxDecoration(
//                           color: Colors.green.withOpacity(0.15),
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(color: Colors.green, width: 1.5),
//                         ),
//                         child: Row(
//                           children: [
//                             const Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
//                             const SizedBox(width: 8),
//                             Expanded(
//                               child: Text(
//                                 "request sent to this provider".tr,
//                                 style: const TextStyle(
//                                   color: Colors.green,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const  SizedBox(height: 8,),
//                       CustomButton(
//                         width: 200,
//                           color:Colors.orange,
//                           text: 'View Order Details'.tr, onPressed: (){

//                           Get.to(RequestsView());

//                        // controller.cancelRequestToProvider(provider.id);
//                       }),
//                     ],
//                   ),
//               ],
//             ),
//             trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.black54),
//             onTap: () {
//               if (isRequestSent) {
//                 appMessage(text: 'You have already sent a request to this provider.'.tr, context: context,success: false);
//               } else {
//                 Get.to(() => ProviderDetailsPage(provider: provider));
//               }
//             },
//           ),
//         );
//       },
//     );
//   }



//   Widget buildEstimatedTimeAndKm(Provider provider,String price) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 22),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             spreadRadius: 4,
//             blurRadius: 15,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Profile + Name + Rating
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 31,
//                 backgroundImage: NetworkImage(provider.image?? ''),
//                 backgroundColor: Colors.grey.shade200,
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 provider.name ?? '',
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF0C3C78),
//                 ),
//               ),
//               const SizedBox(width: 6),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.star, color: Colors.amber, size: 20),
//                   const SizedBox(width: 4),
//                   Text(
//                     provider.rate.toStringAsFixed(1) ?? '0.0',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),

//           // Existing Content
//           (controller.estimatedTime > 0 && controller.isCheckStart==false)
//               ? buildOnWayContent(provider,price)
//               : buildWaitingContent(provider,price),

//         ],
//       ),
//     );
//   }

//   Widget buildOnWayContent(Provider provider,String price) {
//     return Container(

//       decoration:BoxDecoration(
//         borderRadius: BorderRadius.circular(24),
//         color:Colors.grey[100]
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const SizedBox(height: 20),
//           Text(
//             "provider_on_way".tr,
//             style: const TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF0C3C78),
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 12),
//           Text(
//             "please_wait_provider".tr,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: Colors.black54,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 24),
//           buildDistanceTimeActions(provider,price),
//         ],
//       ),
//     );
//   }

//   Widget buildWaitingContent(Provider provider,String price) {
//     return Container(
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(24),
//           color:Colors.grey[100]
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [

//           const SizedBox(height: 20),
//           Text(
//             "may be operation start".tr,
//             style: const TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF0C3C78),
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 12),
//           Text(
//             "provider should be here".tr,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: Colors.black54,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 24),
//           buildActionButtons(provider, isSuccessButton: true,price: price),
//         ],
//       ),
//     );
//   }

//   Widget buildDistanceTimeActions(Provider provider,String price) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Column(
//               children: [
//                 const Icon(Icons.place_rounded, size: 30, color: Color(0xFF0C3C78)),
//                 const SizedBox(height: 8),
//                 Text(
//                   "${controller.distance.toStringAsFixed(1)} ${"km_away".tr}",
//                   style: const TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ],
//             ),
//             Column(
//               children: [
//                 const Icon(Icons.access_time_filled_rounded, size: 30, color: Color(0xFF0C3C78)),
//                 const SizedBox(height: 8),
//                 Text(
//                   "${controller.estimatedTime} ${"minutes_estimated".tr}",
//                   style: const TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         buildActionButtons(provider, isSuccessButton: false,price:price ),
//       ],
//     );
//   }

//   Widget buildActionButtons(Provider provider, {required bool isSuccessButton,required String price}) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               icon: const Icon(Icons.call, size: 20, color: Colors.white),
//               label: Text('Call'.tr, style: const TextStyle(fontSize: 16, color: Colors.white)),
//               onPressed: () {
//                 controller.makeCall(provider);
//               },
//             ),
//             ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               icon: const Icon(Icons.message, size: 20, color: Colors.white),
//               label: Text('Message'.tr, style: const TextStyle(fontSize: 16, color: Colors.white)),
//               onPressed: () {
//                 controller.openWhatsAppChat(provider);
//               },
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         ( isSuccessButton==true)?
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: isSuccessButton ? Colors.green : Colors.red,
//               padding: const EdgeInsets.symmetric(vertical: 14),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: Text(
//               'Task Success'.tr ,
//               style: const TextStyle(fontSize: 18, color: Colors.white),
//             ),
//             onPressed: () {
//               if (isSuccessButton==true) {
//                 controller.getOfferId(controller.requestId,provider.id);
//                 //    controller.rateProvider(provider.id, re, offerId);
//               }
//               // else{
//               //   print("gggg");
//               //   controller.cancelRequestToProvider(provider.id);
//               // }
//               //rateProvider
//               // Handle cancel or success
//             },
//           ),
//         ):SizedBox(),
//         // SizedBox(
//         //   width: double.infinity,
//         //   child: ElevatedButton(
//         //     style: ElevatedButton.styleFrom(
//         //       backgroundColor: isSuccessButton ? Colors.green : Colors.red,
//         //       padding: const EdgeInsets.symmetric(vertical: 14),
//         //       shape: RoundedRectangleBorder(
//         //         borderRadius: BorderRadius.circular(12),
//         //       ),
//         //     ),
//         //     child: Text(
//         //       isSuccessButton ? 'Task Success'.tr : 'Cancel'.tr,
//         //       style: const TextStyle(fontSize: 18, color: Colors.white),
//         //     ),
//         //     onPressed: () {
//         //      if (isSuccessButton==true) {
//         //        controller.getOfferId(controller.requestId,provider.id);
//         //    //    controller.rateProvider(provider.id, re, offerId);
//         //      }
//         //      // else{
//         //      //   print("gggg");
//         //      //   controller.cancelRequestToProvider(provider.id);
//         //      // }
//         //       //rateProvider
//         //       // Handle cancel or success
//         //     },
//         //   ),
//         // ),
//       ],
//     );
//   }


//   Future<void> requestLocationPermission() async {
//     final status = await Permission.location.request();
//     if (!status.isGranted) {
//       throw 'Location permission denied';
//     }
//   }

//    Future<LatLng> getCurrentLocation() async {
//   //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   //   if (!serviceEnabled) {
//   //     throw 'Location services are disabled. Please enable location services.';
//   //   }

//   //   LocationPermission permission = await Geolocator.checkPermission();
//   //   if (permission == LocationPermission.denied) {
//   //     permission = await Geolocator.requestPermission();
//   //     if (permission == LocationPermission.denied) {
//   //       throw 'Location permissions are denied.';
//   //     }
//   //   }
//   //   if (permission == LocationPermission.deniedForever) {
//   //     throw 'Location permissions are permanently denied. Please enable them in app settings.';
//   //   }

//   //   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     return currentLocation;
//     //LatLng(position.latitude, position.longitude);
//   }
// }

import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/controllers/near_provider_controller.dart';
import 'package:first_project/helper/appMessage.dart';
import 'package:first_project/helper/custom_appbar.dart';
import 'package:first_project/helper/custom_button.dart';
import 'package:first_project/models/provider_model.dart';
import 'package:first_project/values/colors.dart';
import 'package:first_project/views/user_views/offers_page.dart';
import 'package:first_project/views/user_views/provider_detailed_bottomSheet.dart';
import 'package:first_project/views/user_views/provider_detailed_page.dart';
import 'package:first_project/views/user_views/requests_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../stop_watch.dart';

class NearestProvidersPage extends StatefulWidget {
  final bool isBack;
  const NearestProvidersPage({Key? key, required this.isBack}) : super(key: key);

  @override
  State<NearestProvidersPage> createState() => _NearestProvidersPageState();
}

class _NearestProvidersPageState extends State<NearestProvidersPage> {
  final NearProviderController controller = Get.put(NearProviderController());
  final box = GetStorage();
  bool isLoading = false;
  String? errorMessage;
  
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  LatLng currentLocation = const LatLng(24.7136, 46.6753);
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    controller.startRepeatingCheck();
    initLocationAndProviders();
    getProviderDataWhereIdIsOne();
  }


   Map<String,dynamic>provData={};

  Future<Map<String, dynamic>?> getProviderDataWhereIdIsOne() async {

       List<String> providerId = box.read('providerId') ?? [];
       String provId='FggHT4Zv4CdEmX4RQqZx';
       if(providerId.isEmpty){

       }else{
       provId = providerId[0];
       }

       print("ddd===$provId");
    // Reference to the 'providers' collection
    final collection = FirebaseFirestore.instance.collection('providers');

    // Query for documents where providerId == 1
    final querySnapshot = await collection.where('id',
        isEqualTo: provId).get();

    // Check if any documents were found
    if (querySnapshot.docs.isNotEmpty) {
      provData=querySnapshot.docs.first.data();

      print("pp==$provData");
      // Return the data of the first matching document as Map<String, dynamic>
      return querySnapshot.docs.first.data();

    } else {
      print("pp3333==");
      // No document found, return null
      return null;
    }
  }
 //  Future<List<Map<String, dynamic>>> getProviderData() async {
 //
 //    print("GET PROVIDER DATA.......");
 // //   box.write('providerReqId', providerReqId);
 //
 //    final box = GetStorage();
 //    List<String> providerId = box.read('providerId') ?? [];
 //    String provId='';
 //    if(providerId.isEmpty){
 //
 //    }else{
 //      String provId = providerId[0];
 //    }
 //
 //
 //    List<Map<String, dynamic>> providerList = [];
 //
 //    try {
 //      final doc = await FirebaseFirestore.instance
 //          .collection('providers')
 //          .doc(provId)
 //         // .doc('FggHT4Zv4CdEmX4RQqZx')
 //          .get();
 //
 //      if (doc.exists) {
 //        providerList.add(doc.data()!..['id'] = doc.id); // Optionally include the document ID
 //      } else {
 //        print('Provider not found');
 //      }
 //    } catch (e) {
 //      print('Error fetching provider: $e');
 //    }
 //
 //    return providerList;
 //  }





  Future<void> initLocationAndProviders() async {
    setState(() => isLoading = true);
    
    try {
      await controller.getServiceProviders();
      _updateDistancesAndMarkers();
    } catch (e) {
      errorMessage = e.toString();
    }
    
    setState(() => isLoading = false);
  }

  void _updateDistancesAndMarkers() {
    for (var provider in controller.providers) {
      provider.calculateDistanceFrom(currentLocation);
    }
    controller.providers.sort((a, b) => a.distance.compareTo(b.distance));
    _updateMarkers();
  }

  void _updateMarkers() {
    setState(() {
      _markers.clear();
      
      // Add providers markers
      _markers.addAll(controller.providers.map((provider) {
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
              builder: (_) => ProviderDetailsBottomSheet(provider: provider),
            );
          },
        );
      }).toSet());
      
      // Add current location marker
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: currentLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Your Location'),
          draggable: true,
          onDragEnd: (newPosition) {
            currentLocation = newPosition;
            _handleMapMoved();
          },
        ),
      );
    });
  }

  void _handleMapMoved() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _updateDistancesAndMarkers();
      _mapController.animateCamera(
        CameraUpdate.newLatLng(currentLocation),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NearProviderController>(
      builder: (_) {
        return Scaffold(
          backgroundColor: backColor,
          appBar: CustomAppBar(
            title: 'Nearest Car Transporters'.tr,
            back: widget.isBack,
           
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
                  ? Center(child: Text('Error: $errorMessage'))
                  : buildContent(),
        );
      },
    );
  }

  Widget buildContent() {
    return Stack(
      children: [
        ListView(
          children: [
         //   Expanded(
          //    child: 
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                 // borderRadius: BorderRadius.circular(20),
                   height:222,
                   // MediaQuery.of(context).size.height * 0.45,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: currentLocation,
                      zoom: 12,
                    ),
                    markers: _markers,
                    onMapCreated: (controller) {
                      _mapController = controller;
                      _updateMarkers();
                    },
                    onCameraMove: (position) {
                      currentLocation = position.target;
                    },
                    onCameraIdle: _handleMapMoved,
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                      Factory<OneSequenceGestureRecognizer>(
                        () => EagerGestureRecognizer(),
                      ),
                    }.toSet(),
                  ),
                ),
             // ),
            ),

          //  (controller.isCurrentTrip==true)?



            controller.isCurrentTrip == false
                ? buildProvidersList()
                :CurrentTripWidget(
                currentTrips: controller.currentTrips,
                currentLat: controller.lat,
                currentLng:controller.lng,
                providerData: provData, getProviderName: getProviderName,
            ),

            // buildCurrentTripWidget(
            //   currentTrips: controller.currentTrips,
            //   currentLat: controller.lat,
            //   currentLng:controller.lng,
            //   providerData: provData
            // )
            //buildEstimatedTimeAndKm(controller.selectedProvider!, ''),
          ],
        ),
        Positioned(
          bottom: 100,
          right: 20,
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.white,
            child: const Icon(Icons.my_location, color: Colors.blue),
            onPressed: () {
              _mapController.animateCamera(
                CameraUpdate.newLatLngZoom(currentLocation, 12),
              );
            },
          ),
        ),
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
                            .replaceAll('medium', 'متوسطة')
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
                            const SizedBox(height: 9),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomButton(
                          text: 'view offers'.tr, 
                          onPressed: () => Get.to(OffersPage())
                      ),
                      const SizedBox(height: 8),
                      CustomButton(
                          width: 260,
                          color: Colors.orange,
                          text: 'View Order Details'.tr, 
                          onPressed: () => Get.to(const RequestsView())
                      ),
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
                      const SizedBox(height: 8),
                      CustomButton(
                        width: 200,
                        color: Colors.orange,
                        text: 'View Order Details'.tr, 
                        onPressed: () => Get.to(const RequestsView())
                      ),
                    ],
                  ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.black54),
            onTap: () {
              if (isRequestSent) {
                appMessage(text: 'You have already sent a request to this provider.'.tr, 
                          context: context, success: false);
              } else {
                Get.to(() => ProviderDetailsPage(provider: provider));
              }
            },
          ),
        );
      },
    );
  }


  Widget buildCurrentTripWidget({
    required List<Map<String, dynamic>> currentTrips,
    required double currentLat,
    required double currentLng,
    Map<String, dynamic>? providerData,
 //   required Future<String> Function(String providerId) getProviderName,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Current Trips",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...currentTrips.map((trip) {
            final tripLat = providerData!['lat'];
            //rip['lat'] as double;
            final tripLng =providerData['lng'];
            final distanceKm = calculateDistanceKm(currentLat, currentLng, tripLat, tripLng);
            final estimatedTimeMin = distanceKm.ceil(); // 1 km = 1 minute

            return FutureBuilder<String>(
              future: getProviderName(trip['providerId']),
              builder: (context, snapshot) {
                final providerName = snapshot.data ?? 'Loading...';
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[50],
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                     // const Icon(Icons.directions_car, color: Colors.redAccent, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(
                              children: [
                              const  Icon(Icons.car_crash, color: Colors.redAccent, size: 32),
                                Text(
                                  providerName,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "${"Car Size".tr} : ${currentTrips[0]['carSize'].toString().tr}",
                              style:TextStyle(color:primary.withOpacity(0.8),fontSize: 16,fontWeight:FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Center(
                              child: Text(
                                "${"Provider In The Way".tr} ",
                                style:const TextStyle(color:Colors.black,fontSize: 16,fontWeight:FontWeight.bold),
                              ),
                            ),
                            //Provider In The Way
                            Text(
                              "Distance: ${distanceKm.toStringAsFixed(2)} km",
                              style: const TextStyle(color: Colors.black54),
                            ),
                            Text(
                              "ETA: $estimatedTimeMin minutes",
                              style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.timer, color: Colors.green),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ],
      ),
    );
  }


  Future<String> getProviderName(String providerId) async {
    final doc = await FirebaseFirestore.instance.collection('providers').doc(providerId).get();
    return doc.data()?['name'] ?? 'Unknown';
  }
  double calculateDistanceKm(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371;
    final dLat = (lat2 - lat1) * (pi / 180);
    final dLon = (lon2 - lon1) * (pi / 180);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) * cos(lat2 * pi / 180) *
            sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }
  Widget buildEstimatedTimeAndKm(Provider provider, String price) {
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
          Row(
            children: [
              CircleAvatar(
                radius: 31,
                backgroundImage: NetworkImage(provider.image ?? ''),
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
                    provider.rate.toStringAsFixed(1) ?? '0.0',
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
          (controller.estimatedTime > 0 && controller.isCheckStart == false)
              ? buildOnWayContent(provider, price)
              : buildWaitingContent(provider, price),
        ],
      ),
    );
  }

  Widget buildOnWayContent(Provider provider, String price) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.grey[100]
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
          buildDistanceTimeActions(provider, price),
        ],
      ),
    );
  }

  Widget buildWaitingContent(Provider provider, String price) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.grey[100]
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
          buildActionButtons(provider, isSuccessButton: true, price: price),
        ],
      ),
    );
  }

  Widget buildDistanceTimeActions(Provider provider, String price) {
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
        buildActionButtons(provider, isSuccessButton: false, price: price),
      ],
    );
  }

  Widget buildActionButtons(Provider provider, {required bool isSuccessButton, required String price}) {
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
              onPressed: () => controller.makeCall(provider),
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
              onPressed: () => controller.openWhatsAppChat(provider),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (isSuccessButton)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Task Success'.tr,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              onPressed: () => controller.getOfferId(controller.requestId, provider.id),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }
}
