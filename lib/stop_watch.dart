

 import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';


 class CurrentTripWidget extends StatefulWidget {
   final List<Map<String, dynamic>> currentTrips;
   final double currentLat;
   final double currentLng;
   final Map<String, dynamic>? providerData;
   final Future<String> Function(String providerId) getProviderName;

   const CurrentTripWidget({
     super.key,
     required this.currentTrips,
     required this.currentLat,
     required this.currentLng,
     required this.providerData,
     required this.getProviderName,
   });

   @override
   State<CurrentTripWidget> createState() => _CurrentTripWidgetState();
 }

 class _CurrentTripWidgetState extends State<CurrentTripWidget> {
   final Map<String, int> _remainingTime = {};
   final Map<String, Timer> _timers = {};

   // Localization strings
   static const Map<String, Map<String, String>> _localizedStrings = {
     'en': {
       'current_trips': 'Current Trips',
       'car_size': 'Car Size',
       'provider_on_way': 'Provider On The Way',
       'distance': 'Distance',
       'eta': 'ETA',
       'minutes': 'minutes',
       'km': 'km',
     },
     'ar': {
       'current_trips': 'الرحلات الحالية',
       'car_size': 'حجم السيارة',
       'provider_on_way': 'مزود الخدمة في الطريق',
       'distance': 'المسافة',
       'eta': 'الوقت المتوقع',
       'minutes': 'دقيقة',
       'km': 'كم',
     },
   };

   String _tr(String key) {
     return _localizedStrings[Get.locale?.languageCode ?? 'en']?[key] ?? key;
   }

   @override
   void initState() {
     super.initState();
     _initCountdowns();
   }

   void _initCountdowns() {
     for (var trip in widget.currentTrips) {
       final tripId = trip['id'].toString();
       if (!_remainingTime.containsKey(tripId)) {
         final lat = widget.providerData?['lat'] ?? 0.0;
         final lng = widget.providerData?['lng'] ?? 0.0;
         final distance = calculateDistanceKm(widget.currentLat, widget.currentLng, lat, lng);
         // More accurate ETA calculation considering average speed (40 km/h)
         final eta = (distance * 60 / 40).ceil(); // Convert hours to minutes

         _remainingTime[tripId] = eta;
         _startTimer(tripId);
       }
     }
   }

   void _startTimer(String tripId) {
     if (_timers.containsKey(tripId)) return;
     _timers[tripId] = Timer.periodic(const Duration(seconds: 30), (timer) {
       if (!mounted) return;
       if (_remainingTime[tripId] == null) return;

       setState(() {
         if (_remainingTime[tripId]! > 0) {
           _remainingTime[tripId] = _remainingTime[tripId]! - 1;
         } else {
           _timers[tripId]?.cancel();
         }
       });
     });
   }

   @override
   void dispose() {
     _timers.forEach((_, timer) => timer.cancel());
     super.dispose();
   }

   @override
   Widget build(BuildContext context) {
     return Container(
       padding: const EdgeInsets.all(20),
       decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(25),
         color: Colors.white,
         boxShadow: [
           BoxShadow(
             color: Colors.black.withOpacity(0.1),
             spreadRadius: 2,
             blurRadius: 20,
             offset: const Offset(0, 10),
           ),
         ],
       ),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text(
             _tr('current_trips'),
             style: const TextStyle(
               fontSize: 20,
               fontWeight: FontWeight.bold,
               color: Colors.black87,
             ),
           ),
           const SizedBox(height: 16),
           if (widget.currentTrips.isEmpty)
             Center(
               child: Text(
                 'No current trips'.tr,
                 style: TextStyle(
                   color: Colors.grey[600],
                   fontSize: 16,
                 ),
               ),
             ),
           ...widget.currentTrips.map((trip) {
             final tripId = trip['id'].toString();
             final eta = _remainingTime[tripId] ?? 0;

             return FutureBuilder<String>(
               future: widget.getProviderName(trip['providerId']),
               builder: (context, snapshot) {
                 final providerName = snapshot.data ?? 'Loading...'.tr;

                 return Container(
                   margin: const EdgeInsets.only(bottom: 16),
                   padding: const EdgeInsets.all(16),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(20),
                     gradient: LinearGradient(
                       begin: Alignment.topLeft,
                       end: Alignment.bottomRight,
                       colors: [
                         Colors.blue.shade50,
                         Colors.green.shade50,
                       ],
                     ),
                     boxShadow: [
                       BoxShadow(
                         color: Colors.black.withOpacity(0.05),
                         spreadRadius: 1,
                         blurRadius: 10,
                         offset: const Offset(0, 5),
                       ),
                     ],
                   ),
                   child: Column(
                     children: [
                       Row(
                         children: [
                           Container(
                             padding: const EdgeInsets.all(8),
                             decoration: BoxDecoration(
                               color: Theme.of(context).primaryColor.withOpacity(0.2),
                               shape: BoxShape.circle,
                             ),
                             child: const Icon(
                               Icons.directions_car,
                               color: Colors.blue,
                               size: 28,
                             ),
                           ),
                           const SizedBox(width: 12),
                           Expanded(
                             child: Text(
                               providerName,
                               style: const TextStyle(
                                 fontSize: 18,
                                 fontWeight: FontWeight.w600,
                                 color: Colors.black87,
                               ),
                             ),
                           ),
                         ],
                       ),
                       const SizedBox(height: 12),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text(
                             "${_tr('car_size')}: ${trip['carSize'].toString().tr}",
                             style: TextStyle(
                               color: Theme.of(context).primaryColor,
                               fontSize: 16,
                               fontWeight: FontWeight.w500,
                             ),
                           ),
                           Container(
                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                             decoration: BoxDecoration(
                               color: Colors.green.withOpacity(0.2),
                               borderRadius: BorderRadius.circular(12),
                             ),
                             child: Text(
                               _tr('provider_on_way'),
                               style: const TextStyle(
                                 color: Colors.green,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                           ),
                         ],
                       ),
                       const SizedBox(height: 16),
                       // ETA Countdown - Center piece
                       Container(
                         padding: const EdgeInsets.symmetric(vertical: 12),
                         decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.circular(15),
                           boxShadow: [
                             BoxShadow(
                               color: Colors.black.withOpacity(0.05),
                               spreadRadius: 1,
                               blurRadius: 8,
                               offset: const Offset(0, 3),
                             ),
                           ],
                         ),
                         child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Column(
                             children: [
                               Text(
                                 _tr('eta'),
                                 style: TextStyle(
                                   fontSize: 14,
                                   color: Colors.grey[600],
                                 ),
                               ),
                               const SizedBox(height: 4),
                               Text(
                                 '$eta ${_tr('minutes')}',
                                 style: const TextStyle(
                                   fontSize: 28,
                                   fontWeight: FontWeight.bold,
                                   color: Colors.black87,
                                 ),
                               ),
                             ],
                           ),
                         ),
                       ),
                       const SizedBox(height: 12),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text(
                             "${_tr('distance')}: ${calculateDistanceKm(widget.currentLat, widget.currentLng, widget.providerData?['lat'], widget.providerData?['lng']).toStringAsFixed(2)} ${_tr('km')}",
                             style: TextStyle(
                               color: Colors.grey[700],
                               fontSize: 14,
                             ),
                           ),
                           const Icon(
                             Icons.timer,
                             color: Colors.green,
                             size: 20,
                           ),
                         ],
                       ),
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
 }
