import 'package:first_project/controllers/client_controller.dart';
import 'package:first_project/views/user%20views/nearest_providers.dart';
import 'package:first_project/views/user%20views/requests_view.dart';
import 'package:first_project/views/user%20views/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'offers_page.dart'; // New page for offers

class MainUserPage extends StatelessWidget {

  int index=0;

  MainUserPage({ this.index=0});


  final ClientController clientController =
      Get.put(ClientController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.amber,
      body: Obx(() {
        // Display the selected page based on the current index
        switch (clientController.currentIndex.value) {
          case 0:
            return NearestProvidersPage();
          case 1:
            return const RequestsView();
          case 2:
            return OffersPage();
          case 3:
            return SettingsPage();
          default:
            return NearestProvidersPage();
        }
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          backgroundColor: Colors.amber,
          selectedLabelStyle:const TextStyle(color: Colors.black),
          unselectedItemColor:(Colors.white),
          unselectedLabelStyle: const TextStyle(color:Colors.black),
          selectedItemColor:Colors.black,
          showSelectedLabels: true,

          currentIndex: clientController.currentIndex.value,
          onTap: (index) {
            clientController.changePage(index);
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard),
              label: 'Dashboard'.tr,backgroundColor: Colors.amber
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.request_page_outlined),
              label: 'Requests'.tr,backgroundColor: Colors.amber
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.local_offer_outlined),
              label: 'Offers'.tr,backgroundColor: Colors.amber
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings_outlined),backgroundColor: Colors.amber,
              label: 'settings'.tr,
            ),
          ],
        );
      }),
    );
  }
}
