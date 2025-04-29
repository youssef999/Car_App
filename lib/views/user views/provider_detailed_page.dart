import 'package:first_project/controllers/provider_details_controller.dart';
import 'package:first_project/helper/custom_appbar.dart';
import 'package:first_project/models/KSA_places.dart';
import 'package:first_project/models/provider_model.dart';
import 'package:first_project/values/colors.dart';
import 'package:first_project/views/user%20views/provider_reviews.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ProviderDetailsPage extends StatelessWidget {
  final Provider provider;

  ProviderDetailsPage({required this.provider});


  ProviderDetailsController controller = Get.put(ProviderDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Provider Details'.tr, back: true,),
      bottomNavigationBar:  Padding(
        padding: const EdgeInsets.only(left:40.0,right: 40,bottom: 30,top: 20),
        child: _buildSubmitButton(),
      ),
      body: GetBuilder<ProviderDetailsController>(
        // init:ProviderDetailsController(),
          builder: (controller) {
            return Container(
              color: Colors.grey[100],
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProviderInfo(),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Please enter the following data:'.tr),
                      const SizedBox(height: 16),

                      _buildSectionTitle('Car Size'.tr),
                      _buildCarSizeSelection(),
                      const SizedBox(height: 16),

                      _buildSectionTitle('Car Malfunction Cause'.tr),
                      _buildMalfunctionCauseSelection(),
                      const SizedBox(height: 16),

                      _buildSectionTitle('Location of Loading'.tr),
                      Obx(() {
                        return Column(
                          children: [
                            _buildLocationDropdowns(),
                            const SizedBox(height: 16),

                          //  _buildSectionTitle('Destination'.tr),
                            Row(
                              children: [
                                Text("Destination".tr,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                              ],
                            ),
                            _buildDestinationDropdowns(),
                            const SizedBox(height: 32),
                          ],
                        );
                      }),



                    ],
                  ),
                ),
              ),
            );
          }
      ),
    );
  }

  Widget _buildProviderInfo() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      provider.name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey[600],
                            size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${provider.distance.toStringAsFixed(2)}' + " " +
                              'km away'.tr,
                          style: TextStyle(
                              fontSize: 16, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: provider.status == 'نشط'
                                ? Colors.green[100]
                                : Colors.red[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${'Status'.tr}: ${provider.status}',
                            style: TextStyle(
                              color: provider.status == 'نشط'
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      ],
                    ),

                  ],
                ),
                Column(
                  children: [
                    Row(children: [
                      const Icon(Icons.star, color: Colors.amberAccent,
                        size: 20,
                      ),
                      const SizedBox(width: 5,),
                      Text(provider.rate.toStringAsFixed(2),
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),),
                    ],),
                    const SizedBox(height: 6,),
                    InkWell(
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: buttonColor
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("VIEW REVIEWS".tr,
                              style: const TextStyle(color: Colors.white),),
                          )),
                      onTap:(){
                        Get.to(ProviderReviews(
                          provider: provider,
                        ));
                      },
                    ),
                  ],
                ),
                //   const SizedBox(height: 10,)
              ],
            ),


          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildCarSizeSelection() {
    return Obx(() =>
        Column(
          children: ['Small'.tr, 'Medium'.tr, 'Large'.tr].map((size) {
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: RadioListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 0),
                title: Text(size),
                value: size,
                groupValue: controller.carSize.value,
                onChanged: (value) => controller.carSize.value = value!,
              ),
            );
          }).toList(),
        ));
  }

  Widget _buildMalfunctionCauseSelection() {
    return Obx(() =>
        Column(
          children: ['Traffic Accident'.tr, 'Technical Malfunction'.tr].map((
              cause) {
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: RadioListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 0),
                title: Text(cause),
                value: cause,
                groupValue: controller.malfunctionCause.value,
                onChanged: (value) =>
                controller.malfunctionCause.value = value!,
              ),
            );
          }).toList(),
        ));
  }

  Widget _buildLocationDropdowns() {
    return _buildDropdownSection(
      regionValue: controller.loadingRegion,
      cityValue: controller.loadingCity,
      districtValue: controller.loadingDistrict,
    );
  }

  Widget _buildDestinationDropdowns() {
    return _buildDropdownSection(
      regionValue: controller.destinationRegion,
      cityValue: controller.destinationCity,
      districtValue: controller.destinationDistrict,
    );
  }

  Widget _buildDropdownSection({
    required RxString regionValue,
    required RxString cityValue,
    required RxString districtValue,
  }) {
    return Column(
      children: [
        _buildDropdown(
          label: 'Region'.tr,
          value: regionValue,
          items: KSA.regions.keys.toList(),
          onChanged: (value) {
            regionValue.value = value!;
            cityValue.value = '';
            districtValue.value = '';
          },
        ),
        const SizedBox(height: 12),
        _buildDropdown(
          label: 'City'.tr,
          value: cityValue,
          items: regionValue.value.isEmpty
              ? []
              : KSA.regions[regionValue.value]!.keys.toList(),
          onChanged: (value) {
            cityValue.value = value!;
            districtValue.value = '';
          },
        ),
        const SizedBox(height: 12),
        _buildDropdown(
          label: 'District'.tr,
          value: districtValue,
          items: cityValue.value.isEmpty
              ? []
              : KSA.regions[regionValue.value]![cityValue.value]!,
          onChanged: (value) => districtValue.value = value!,
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required RxString value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Obx(() =>
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonFormField<String>(
              value: value.value.isEmpty ? null : value.value,
              onChanged: onChanged,
              items: items.map((item) =>
                  DropdownMenuItem(value: item, child: Text(item))).toList(),
              decoration: InputDecoration(
                labelText: label,
                border: InputBorder.none,
              ),
            ),
          ),
        ));
  }

  Widget _buildSubmitButton() {
    return Obx(() =>
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: controller.isSubmitting.value
                ? null
                : () {
              if (controller.formKey.currentState!.validate()) {
                controller.isSubmitting.value = true;
                controller.submitRequest(provider);
              }
            },
            child: controller.isSubmitting.value
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
              'Send Request'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ));
  }


// submitRequest() and sendRequestToProvider() methods stay the same as you wrote them.
}
