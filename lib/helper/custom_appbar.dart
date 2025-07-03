import 'package:first_project/controllers/near_provider_controller.dart';
import 'package:first_project/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool back;

  const CustomAppBar({
    
    Key? key,
    required this.title,
    this.back = false, // default to false
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(71);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [appBarColor, appBarColor2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(33),
          bottomRight: Radius.circular(33),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: [
              if (back)
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              if (!back) const SizedBox(width: 11), // keep spacing consistent
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            //  IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list, color: Colors.white)),
             // const SizedBox(width: 11), // balance with left icon
             IconButton(
  onPressed: () {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: 200,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.local_shipping, color: Colors.black),
                title: Text('large'.tr),
                onTap: () {
                  Navigator.pop(context); // Close sheet
                  Get.find<NearProviderController>().getServiceProviders(
                    useLocation: true,
                    requestedCarType: 'large',
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.directions_car, color: Colors.black),
                title: Text('medium'.tr),
                onTap: () {
                  Navigator.pop(context);
                  Get.find<NearProviderController>().getServiceProviders(
                    useLocation: true,
                    requestedCarType: 'medium',
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.electric_car, color: Colors.black),
                title: Text('small'.tr),
                onTap: () {
                  Navigator.pop(context);
                  Get.find<NearProviderController>().getServiceProviders(
                    useLocation: true,
                    requestedCarType: 'small',
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  },
  icon: const Icon(Icons.filter_list, color: Colors.white),
)


            ],
          ),
        ),
      ),
    );
  }
}
