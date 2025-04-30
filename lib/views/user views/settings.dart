import 'package:first_project/controllers/settings_controller.dart';
import 'package:first_project/helper/custom_appbar.dart';
import 'package:first_project/helper/open_whats.dart';
import 'package:first_project/values/colors.dart';
import 'package:first_project/views/login_view.dart';
import 'package:first_project/views/privacy/about_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../privacy/privacy_view.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class SettingsPage extends StatefulWidget {

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  SettingsController controller=Get.put(SettingsController());
  @override
  void initState() {

    controller.getUserData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'settingsTitle'.tr,

      ),



      body: GetBuilder<SettingsController>(
        builder: (_) {

          if(controller.userData.isNotEmpty){
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  // Profile Section
                  _buildSectionHeader('profileSection'.tr),
                  _buildSettingCard(
                    context,
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.amber, Colors.orange],
                        ),
                      ),
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    title: controller.userData[0]['name'],
                    subtitle: controller.userData[0]['phone'],
                    //'personalInfoSubtitle'.tr,
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),

                  // Account Settings
                  _buildSectionHeader('accountSettings'.tr),
                  const SizedBox(height: 5,),
                  _buildSettingItem(
                    context,
                    icon: Icons.language_rounded,
                    title: 'language'.tr,
                    value: 'English',
                    onTap: () => _showLanguageDialog(context),
                  ),
                  const SizedBox(height: 10),
                  _buildSettingItem(
                    context,
                    icon: Icons.security_rounded,
                    title: 'privacySecurity'.tr,
                    onTap: () {
                      Get.to(PrivacyView());
                    },
                  ),
                  const SizedBox(height: 20),

                  // App Settings
                  _buildSectionHeader('appSettings'.tr),

                 const SizedBox(height: 5,),
                  _buildSettingItem(
                    context,
                    icon: Icons.help_center_rounded,
                    title: 'helpCenter'.tr,
                    onTap: () {
                      openWhatsAppChat("+201097970465");
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildSettingItem(
                    context,
                    icon: Icons.info_rounded,
                    title: 'aboutApp'.tr,
                    onTap: () {
                      Get.to(AboutApp());
                    },
                  ),
                  const SizedBox(height: 20),
                  // Actions
                  _buildActionButton(
                    context,
                    text: 'logout'.tr,
                    icon: Icons.logout_rounded,
                    color: Colors.redAccent,
                    onTap: () {
                      Get.offAll(LoginPage());
                    },
                  ),
                ],
              ),
            );
          }else{
            return Center(
              child:CircularProgressIndicator(),
            );
          }

        }
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingCard(
      BuildContext context, {
        required Widget leading,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).dividerColor,
          width: 0.5,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              leading,
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        String? value,
        Widget? trailing,
        VoidCallback? onTap,
      }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Theme.of(context).dividerColor,
          width: 0.5,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color:primary, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (value != null)
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              if (trailing != null) trailing,
              if (onTap != null && trailing == null)
                Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, {
        required String text,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 20),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        onPressed: onTap,
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('chooseLanguage'.tr),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: Text('english'.tr),
                onTap: () {
                  Get.updateLocale(const Locale('en'));
                  Get.back();
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text('arabic'.tr),
                onTap: () {
                  Get.updateLocale(const Locale('ar'));
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}