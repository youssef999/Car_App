import 'package:first_project/controllers/provider_controller.dart';
import 'package:first_project/helper/custom_appbar.dart';
import 'package:first_project/values/colors.dart';
import 'package:first_project/views/provider%20views/settings/provider_settings.dart';
import 'package:first_project/views/provider%20views/widgets/dashboard_content.dart';
import 'package:first_project/views/provider%20views/widgets/providers_orders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class ProviderDashboard extends StatelessWidget {
  final ProviderController _controller =
  Get.put(ProviderController(providerId: 'FggHT4Zv4CdEmX4RQqZx'), permanent: true);

  final RxInt _selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'provider_dashboard'.tr),
      body: Obx(() {
        switch (_selectedIndex.value) {
          case 0:
            return DashboardContent();
          case 1:
            return ProviderOrders();
          case 2:
            return ProviderSettingsPage();
          default:
            return DashboardContent();
        }
      }),
      bottomNavigationBar: Obx(
            () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CurvedNavigationBar(
              index: _selectedIndex.value,
              height: 65.0,
              items: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.dashboard,
                      size: 28,
                      color: _selectedIndex.value == 0 ? Colors.white : Colors.white.withOpacity(0.7),
                    ),
                    SizedBox(height: 2),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        'Dashboard'.tr,
                        style: TextStyle(
                          color: _selectedIndex.value == 0 ? Colors.white : Colors.white.withOpacity(0.7),
                          fontSize: 12,
                          fontWeight: _selectedIndex.value == 0 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_turned_in,
                      size: 28,
                      color: _selectedIndex.value == 1 ? Colors.white : Colors.white.withOpacity(0.7),
                    ),
                    SizedBox(height: 2),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        'orders'.tr,
                        style: TextStyle(
                          color: _selectedIndex.value == 1 ? Colors.white : Colors.white.withOpacity(0.7),
                          fontSize: 12,
                          fontWeight: _selectedIndex.value == 1 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.settings,
                      size: 28,
                      color: _selectedIndex.value == 2 ? Colors.white : Colors.white.withOpacity(0.7),
                    ),
                    SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        'settings'.tr,
                        style: TextStyle(
                          color: _selectedIndex.value == 2 ? Colors.white : Colors.white.withOpacity(0.7),
                          fontSize: 12,
                          fontWeight: _selectedIndex.value == 2 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              color: primary,
              buttonBackgroundColor: primary.withOpacity(0.8),
              backgroundColor: Colors.transparent,
              animationCurve: Curves.easeInOut,
              animationDuration: Duration(milliseconds: 300),
              onTap: (index) => _selectedIndex.value = index,
              letIndexChange: (index) => true,
            ),
          ],
        ),
      ),
    );
  }
}