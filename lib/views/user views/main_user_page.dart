import 'package:first_project/controllers/client_controller.dart';
import 'package:first_project/values/colors.dart';
import 'package:first_project/views/user%20views/nearest_providers.dart';
import 'package:first_project/views/user%20views/requests_view.dart';
import 'package:first_project/views/user%20views/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'offers_page.dart'; // New page for offers

class MainUserPage extends StatelessWidget {
  final int index;

  MainUserPage({this.index = 0, Key? key}) : super(key: key);

  final ClientController clientController =
  Get.put(ClientController());

  @override
  Widget build(BuildContext context) {
    // Set the index only the first time build is called (not on every rebuild)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (clientController.currentIndex.value != index) {
        clientController.changePage(index);
      }
    });

    return Scaffold(
      backgroundColor: primary,
      body: Obx(() {
        switch (clientController.currentIndex.value) {
          case 0:
            return NearestProvidersPage();
          case 1:
            return OffersPage();
          case 2:
            return const RequestsView();
          case 3:
            return SettingsPage();
          default:
            return NearestProvidersPage();
        }
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          backgroundColor: primary,
          selectedLabelStyle: const TextStyle(color: Colors.white),
          unselectedItemColor: Colors.white,
          unselectedLabelStyle: const TextStyle(color: Colors.black),
          selectedItemColor: Colors.white,
          showSelectedLabels: true,
          currentIndex: clientController.currentIndex.value,
          onTap: (index) {
            clientController.changePage(index);
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard),
              label: 'Dashboard'.tr,
              backgroundColor: primary,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.local_offer_outlined),
              label: 'Offers'.tr,
              backgroundColor: primary,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.request_page_outlined),
              label: 'Requests'.tr,
              backgroundColor: primary,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings_outlined),
              label: 'settings'.tr,
              backgroundColor: primary,
            ),
          ],
        );
      }),
    );
  }
}

