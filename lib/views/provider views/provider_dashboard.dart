// ignore_for_file: use_key_in_widget_constructors

import 'package:first_project/controllers/provider_controller.dart';
import 'package:first_project/views/provider%20views/widgets/dashboard_content.dart';
import 'package:first_project/views/provider%20views/widgets/notifications.dart';
import 'package:first_project/views/provider%20views/widgets/providers_orders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProviderDashboard extends StatelessWidget {
  final ProviderController _controller =
      Get.put(ProviderController(providerId: 'FggHT4Zv4CdEmX4RQqZx'), permanent: true);

  final RxInt _selectedIndex =
      0.obs; // Track the selected index for bottom navigation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('provider_dashboard'.tr),
        centerTitle: true,
        actions: [
          Row(
            children: [
              // Text(_controller.isAvailable ? "status_available".tr : "status_busy".tr),
              GetBuilder<ProviderController>(builder: (_) {
                return Switch(
                  value: _controller.isAvailable,
                  onChanged: (value) => _controller.toggleAvailability(),
                  activeColor: _controller.toogleColor,
                  //Colors.green,
                  inactiveThumbColor: Colors.red,
                );
              }),
            ],
          ),

          // IconButton(
          //   icon: Obx(() => Icon(
          //     _controller.isAvailable ? Icons.work : Icons.pause_circle_filled, // Work icon for available, Pause icon for busy
          //     color: _controller.isAvailable ? Colors.green : Colors.red, // Green for available, Red for busy
          //   )),
          //   onPressed: _controller.toggleAvailability,
          // ),
          // IconButton(
          //   icon: Obx(() => Icon(
          //         _controller.isAvailable ? Icons.check_circle : Icons.block,
          //       )),
          //   onPressed: _controller.toggleAvailability,
          // ),
          const SizedBox(
            width: 20,
          ),
          // DropdownButton<String>(
          //   iconEnabledColor: Colors.white,
          //   dropdownColor: const Color.fromARGB(255, 172, 62, 54),
          //   iconDisabledColor: const Color.fromARGB(255, 180, 132, 129),
          //   value: _controller.selectedLanguage.value,
          //   onChanged: (String? newValue) {
          //     _controller.changeLanguage(newValue!);
          //   },
          //   items: <String>['en', 'ar', 'ur']
          //       .map<DropdownMenuItem<String>>(
          //         (String value) => DropdownMenuItem(
          //           value: value,
          //           child: Text(value.tr),
          //         ),
          //       )
          //       .toList(),
          //   style: const TextStyle(color: Colors.white),
          // ),
        ],
      ),
      body: Obx(() {
        if (_selectedIndex.value == 0) {
          return DashboardContent(); // Show the dashboard content
        } else if (_selectedIndex.value == 1) {
          return ProviderOrders(); // Show the accomplished orders screen
        } else if (_selectedIndex.value == 2) {
          return NotificationsPage();
        } else {
          return const Placeholder(); // Placeholder for the third tab
        }
      }),
      bottomNavigationBar: Obx(() => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 5),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex.value,
          onTap: (index) => _selectedIndex.value = index,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          elevation: 0,
          items:  [
            BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard),
              label: 'dashboard'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.assignment_turned_in),
              label: 'orders'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.notifications),
              label: 'Notifications'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: 'settings'.tr,
            ),
          ],
        ),
      )),

      // bottomNavigationBar: Obx(() => BottomNavigationBar(
      //       currentIndex: _selectedIndex.value,
      //       onTap: (index) =>
      //           _selectedIndex.value = index, // Update the selected index
      //       items: [
      //         BottomNavigationBarItem(
      //           icon: const Icon(Icons.dashboard),
      //           label: 'dashboard'.tr,
      //         ),
      //         BottomNavigationBarItem(
      //           icon: const Icon(Icons.assignment_turned_in),
      //           label: 'orders'.tr,
      //         ),
      //         BottomNavigationBarItem(
      //           icon: const Icon(Icons.notifications),
      //           label: 'Notifications'.tr,
      //         ),
      //         BottomNavigationBarItem(
      //           icon: const Icon(Icons.settings),
      //           label: 'settings'.tr,
      //         ),
      //       ],
      //     )),
    );
  }
}



// ================================================================

// import 'package:first_project/controllers/provider_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ProviderDashboard extends StatelessWidget {
//   final ProviderController _controller =
//       Get.put(ProviderController(providerId: '123456789'));
//   // Set provider ID during login

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Provider Dashboard'),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Obx(() => Icon(
//                   _controller.isAvailable ? Icons.check_circle : Icons.block,
//                 )),
//             onPressed: _controller.toggleAvailability,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Provider status
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton(
//                   onPressed: () {
//                     _controller.loadRequests();
//                   },
//                   child: Text('Load requests')),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Obx(() => Text(
//                       _controller.isAvailable
//                           ? 'Status: Available'
//                           : 'Status: Busy',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color:
//                             _controller.isAvailable ? Colors.green : Colors.red,
//                       ),
//                     )),
//               ),
//             ],
//           ),
//           Divider(),
//           // List of service requests
//           Expanded(
//             child: Obx(() {
//               if (_controller.isLoading) {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               } else if (_controller.serviceRequests.isEmpty) {
//                 return Center(child: Text('No requests found'));
//               } else {
//                 return ListView.builder(
//                   itemCount: _controller.visibleRequests,
//                   itemBuilder: (context, index) {
//                     if (index >= _controller.serviceRequests.length) {
//                       return SizedBox();
//                     }
//                     final request = _controller.serviceRequests[index];
//                     return Card(
//                       margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                       child: ListTile(
//                         title: Text('Request #${request.id}'),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Time: ${request.time}'),
//                             Text('Destination: ${request.destination}'),
//                             Text('Car Size: ${request.carSize}'),
//                             Text('Car Status: ${request.carStatus}'),
//                             Text('Place of Loading: ${request.placeOfLoading}'),
//                             TextField(
//                               decoration: InputDecoration(
//                                 labelText: 'Service Pricing',
//                                 labelStyle: TextStyle(color: Color(0xffB48481)),
//                                 hintText: 'Enter amount',
//                                 errorText: request.servicePricing == null &&
//                                         (request.servicePricing!.isEmpty ||
//                                             double.tryParse(
//                                                     request.servicePricing!) ==
//                                                 null ||
//                                             double.parse(
//                                                     request.servicePricing!) <=
//                                                 0)
//                                     ? 'Enter a valid price greater than zero'
//                                     : null,
//                               ),
//                               keyboardType: TextInputType.number,
//                               onChanged: (value) {
//                                 request.servicePricing = value;
//                               },
//                             ),
//                           ],
//                         ),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: Icon(Icons.visibility_off),
//                               onPressed: () =>
//                                   _controller.hideRequest(request.id),
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.send),
//                               onPressed: () => _controller.sendOffer(
//                                   request.id, request.servicePricing),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               }
//             }),
//           ),
//           Obx(() {
//             if (_controller.visibleRequests <
//                 _controller.serviceRequests.length) {
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ElevatedButton(
//                   onPressed: _controller.loadMoreRequests,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color.fromARGB(255, 172, 62, 54),
//                     elevation: 5,
//                   ),
//                   child: Text(
//                     'MORE',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               );
//             } else {
//               return SizedBox();
//             }
//           }),
//         ],
//       ),
//     );
//   }
// }





// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:first_project/controllers/provider_controller.dart';

// class ProviderDashboard extends StatelessWidget {
//   final ProviderController _controller = Get.put(ProviderController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Provider Dashboard'),
//         centerTitle: true,
//         actions: [
//           // Toggle availability
//           IconButton(
//             icon: Obx(() => Icon(
//                   _controller.isAvailable ? Icons.check_circle : Icons.block,
//                 )),
//             onPressed: _controller.toggleAvailability,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Provider status
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Obx(() => Text(
//                   _controller.isAvailable
//                       ? 'Status: Available'
//                       : 'Status: Busy',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: _controller.isAvailable ? Colors.green : Colors.red,
//                   ),
//                 )),
//           ),
//           Divider(),
//           // List of service requests
//           Expanded(
//             child: Obx(() => ListView.builder(
//                   itemCount: _controller.visibleRequests,
//                   itemBuilder: (context, index) {
//                     final request = _controller.serviceRequests[index];
//                     return Card(
//                       margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                       child: ListTile(
//                         title: Text('Request #${request.id}'),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Time: ${request.time}'),
//                             Text('Place of Loading: ${request.placeOfLoading}'),
//                             Text('Destination: ${request.destination}'),
//                             Text('Car Size: ${request.carSize}'),
//                             Text('Car Status: ${request.carStatus}'),
//                             TextField(
//                               decoration: InputDecoration(
//                                 labelText: 'Service Pricing',
//                                 labelStyle: TextStyle(color: Color(0xffB48481)),
//                                 hintText: 'Enter amount',
//                               ),
//                               keyboardType: TextInputType.number,
//                               onChanged: (value) {
//                                 request.servicePricing = value;
//                               },
//                             ),
//                           ],
//                         ),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: Icon(Icons.visibility_off),
//                               onPressed: () => _controller.hideRequest(index),
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.send),
//                               onPressed: () => _controller.sendOffer(index),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 )),
//           ),
//           // MORE button
//           Obx(() {
//             if (_controller.visibleRequests <
//                 _controller.serviceRequests.length) {
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ElevatedButton(
//                   onPressed: _controller.loadMoreRequests,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color.fromARGB(255, 172, 62, 54),
//                     elevation: 5,
//                   ),
//                   child: Text(
//                     'MORE',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               );
//             } else {
//               return SizedBox();
//             }
//           }),
//         ],
//       ),
//     );
//   }
// }

