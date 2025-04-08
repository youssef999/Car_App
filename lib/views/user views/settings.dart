import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'.tr),
      ),
      body: Center(
        child: Text('Settings will be displayed here.'.tr),
      ),
    );
  }
}
