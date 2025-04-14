import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settingsTitle'.tr,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Theme.of(context).textTheme.titleLarge?.color)),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
              title: 'John Doe',
              subtitle: 'personalInfoSubtitle'.tr,
              onTap: () {},
            ),
            const SizedBox(height: 20),

            // Account Settings
            _buildSectionHeader('accountSettings'.tr),
            _buildSettingItem(
              context,
              icon: Icons.language_rounded,
              title: 'language'.tr,
              value: 'English',
              onTap: () => _showLanguageDialog(context),
            ),
            _buildSettingItem(
              context,
              icon: Icons.notifications_active_rounded,
              title: 'notifications'.tr,
              trailing: Switch(
                value: true,
                onChanged: (val) {},
                activeColor: Colors.amber,
              ),
            ),
            _buildSettingItem(
              context,
              icon: Icons.security_rounded,
              title: 'privacySecurity'.tr,
              onTap: () {},
            ),
            const SizedBox(height: 20),

            // App Settings
            _buildSectionHeader('appSettings'.tr),
            _buildSettingItem(
              context,
              icon: Icons.help_center_rounded,
              title: 'helpCenter'.tr,
              onTap: () {},
            ),
            _buildSettingItem(
              context,
              icon: Icons.info_rounded,
              title: 'aboutApp'.tr,
              onTap: () {},
            ),
            const SizedBox(height: 20),

            // Actions
            _buildActionButton(
              context,
              text: 'logout'.tr,
              icon: Icons.logout_rounded,
              color: Colors.redAccent,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
      ),
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
                child: Icon(icon, color: Colors.orange, size: 20),
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