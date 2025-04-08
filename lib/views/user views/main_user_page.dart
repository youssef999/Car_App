import 'package:first_project/controllers/client_controller.dart';
import 'package:first_project/views/user%20views/nearest_providers.dart';
import 'package:first_project/views/user%20views/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'offers_page.dart'; // New page for offers

class MainUserPage extends StatelessWidget {
  final ClientController clientController =
      Get.put(ClientController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        // Display the selected page based on the current index
        switch (clientController.currentIndex.value) {
          case 0:
            return NearestProvidersPage();
          case 1:
            return OffersPage();
          case 2:
            return SettingsPage();
          default:
            return NearestProvidersPage();
        }
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: clientController.currentIndex.value,
          onTap: (index) {
            clientController.changePage(index);
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard),
              label: 'Dashboard'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.local_offer),
              label: 'Offers'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: 'settings'.tr,
            ),
          ],
        );
      }),
    );
  }
}
