import 'package:first_project/controllers/client_controller.dart';
import 'package:first_project/views/user%20views/nearest_providers.dart';
import 'package:first_project/views/user%20views/requests_view.dart';
import 'package:first_project/views/user%20views/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'offers_page.dart';

class MainUserPage extends StatelessWidget {
  final int index;
  final Color primaryColor = const Color(0xFF009d88);
  final Color secondaryColor = Colors.white;
  final Color accentColor = const Color(0xFF33c9b6);
  final Color backgroundColor = const Color(0xFFf5f5f5);

  MainUserPage({this.index = 0, Key? key}) : super(key: key);

  final ClientController clientController = Get.put(ClientController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (clientController.currentIndex.value != index) {
        clientController.changePage(index);
      }
    });

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBody: true, // Important for curved navigation bar
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
        return CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          color: primaryColor,

          buttonBackgroundColor: primaryColor,
          height: 55,
          animationDuration: const Duration(milliseconds: 200),
          animationCurve: Curves.easeInOutCubic,
          index: clientController.currentIndex.value,
          items: [
            _buildNavItem(Icons.dashboard, 'Dashboard'.tr),
            _buildNavItem(Icons.local_offer_outlined, 'Offers'.tr),
            _buildNavItem(Icons.request_page_outlined, 'Requests'.tr),
            _buildNavItem(Icons.settings_outlined, 'Settings'.tr),
          ],
          onTap: (index) {
            clientController.changePage(index);
          },
        );
      }),
    );
  }

  Widget _buildNavItem(IconData icon, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 24, color: secondaryColor),
        const SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            text,
            style: TextStyle(
              color: secondaryColor,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}