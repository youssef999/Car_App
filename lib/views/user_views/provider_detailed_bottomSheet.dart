import 'package:first_project/models/provider_model.dart';
import 'package:first_project/values/colors.dart';
import 'package:first_project/views/user_views/provider_detailed_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProviderDetailsBottomSheet extends StatelessWidget {
  final Provider provider;

  ProviderDetailsBottomSheet({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(provider.name,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${provider.distance.toStringAsFixed(2)} ',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              Text(
                "km away".tr,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Text(
            "${'Status'.tr}: ${provider.status}",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: (provider.status == 'متاح') ?
               Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style:ButtonStyle(
              backgroundColor: WidgetStateProperty.all(buttonColor),
            ),
            onPressed: () {
              Get.to(() => ProviderDetailsPage(provider: provider));
            },
            child:  Text('View Details'.tr,
            style:const TextStyle(color:Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
