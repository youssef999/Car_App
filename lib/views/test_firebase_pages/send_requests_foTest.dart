// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:first_project/controllers/provider_controller.dart';
// import 'package:first_project/models/client_request_model.dart';
// import 'package:flutter/material.dart';
//
// import 'package:get/get.dart';
// // Adjust the import path
// // Adjust the import path
//
// class TestRequestsPage extends StatelessWidget {
//   final ProviderController _controller = Get.put(ProviderController(
//       providerId: '123456789')); // Get the existing ProviderController instance
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Send Requests to Firestore'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 onPressed: () async {
//                   await _sendDummyRequests(); // Send 20 dummy requests
//                 },
//                 child: Text('Send 20 Dummy Requests'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Get.toNamed('/ProviderDashboard');
//                 },
//                 child: Text('Go to provider dashboard'),
//               )
//             ],
//           ),
//         ));
//   }
//
//   // Method to send 20 dummy requests to Firestore
//   Future<void> _sendDummyRequests() async {
//     print(
//         '=============================Sending dummy requests...'); // Debug log
//     try {
//       // Generate 20 dummy requests
//       final List<RequestModel> dummyRequests = List.generate(
//         20,
//         (index) => RequestModel(
//             id: 'request_${index + 1}', // Unique ID for each request
//             time:
//                 DateTime.now().subtract(Duration(hours: index)), // Use DateTime
//             destination: 'Location ${index + 1}',
//             carSize: ['Small', 'Medium', 'Large'][index % 3], // Random car size
//             carStatus: [
//               'Broken Engine',
//               'Flat Tire',
//               'Dead Battery'
//             ][index % 3], // Random car status
//             servicePricing: '0', // Initial price
//             placeOfLoading: 'Loading Point ${index + 1}',
//             providerId: _controller.providerId, // Use the provider's unique ID
//             status: 'accomplished',
//             hiddenByProvider: false),
//       );
//
//       // Send each request to Firestore
//       for (final request in dummyRequests) {
//         print('==================Adding request: ${request.id}'); // Debug log
//         await _controller.addRequest(request);
//       }
//
//       Get.snackbar('Success', '20 dummy requests sent to Firestore');
//     } catch (e, stackTrace) {
//       print('==========================Error: $e'); // Debug log
//       print('Stack Trace: $stackTrace'); // Log the full stack trace
//       Get.snackbar('Error', 'Failed to send requests: $e');
//     }
//   }
//
//   ////////////////////////////////
//   ///
//
//   ///
// }
