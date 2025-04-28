


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/helper/custom_appbar.dart';
import 'package:first_project/helper/custom_button.dart';
import 'package:first_project/models/KSA_places.dart';
import 'package:first_project/models/provider_model.dart';
import 'package:first_project/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../../main.dart';
import 'main_user_page.dart';

class ProviderDetailsPage extends StatelessWidget {
  final Provider provider;

  ProviderDetailsPage({required this.provider});

  final _formKey = GlobalKey<FormState>();
  final _carSize = 'Small'.obs;
  final _malfunctionCause = 'Traffic Accident'.obs;
  final _isSubmitting = false.obs;

  final RxString _loadingRegion = ''.obs;
  final RxString _loadingCity = ''.obs;
  final RxString _loadingDistrict = ''.obs;

  final RxString _destinationRegion = ''.obs;
  final RxString _destinationCity = ''.obs;
  final RxString _destinationDistrict = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar(title: 'Provider Details'.tr,),
      body: Container(
        color: Colors.grey[100],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
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
                _buildLocationDropdowns(),
                const SizedBox(height: 16),

                _buildSectionTitle('Destination'.tr),
                _buildDestinationDropdowns(),
                const SizedBox(height: 32),

                _buildSubmitButton(),
              ],
            ),
          ),
        ),
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
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey[600], size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${provider.distance.toStringAsFixed(2)}'+" "+'km away'.tr,
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: provider.status == 'نشط' ? Colors.green[100] : Colors.red[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${'Status'.tr}: ${provider.status}',
                            style: TextStyle(
                              color: provider.status == 'نشط' ? Colors.green : Colors.red,
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
                      const Icon(Icons.star,color: Colors.amberAccent,
                      size: 20,
                      ),
                    const  SizedBox(width: 5,),
                      Text(provider.rate.toStringAsFixed(2),
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                    ],),
                    const SizedBox(height: 6,),
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color:buttonColor
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("VIEW REVIEWS".tr,style:TextStyle(color:Colors.white),),
                        )),
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
    return Obx(() => Column(
      children: ['Small'.tr, 'Medium'.tr, 'Large'.tr].map((size) {
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: RadioListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            title: Text(size),
            value: size,
            groupValue: _carSize.value,
            onChanged: (value) => _carSize.value = value!,
          ),
        );
      }).toList(),
    ));
  }

  Widget _buildMalfunctionCauseSelection() {
    return Obx(() => Column(
      children: ['Traffic Accident'.tr, 'Technical Malfunction'.tr].map((cause) {
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: RadioListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            title: Text(cause),
            value: cause,
            groupValue: _malfunctionCause.value,
            onChanged: (value) => _malfunctionCause.value = value!,
          ),
        );
      }).toList(),
    ));
  }

  Widget _buildLocationDropdowns() {
    return _buildDropdownSection(
      regionValue: _loadingRegion,
      cityValue: _loadingCity,
      districtValue: _loadingDistrict,
    );
  }

  Widget _buildDestinationDropdowns() {
    return _buildDropdownSection(
      regionValue: _destinationRegion,
      cityValue: _destinationCity,
      districtValue: _destinationDistrict,
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
    return Obx(() => Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonFormField<String>(
          value: value.value.isEmpty ? null : value.value,
          onChanged: onChanged,
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
        ),
      ),
    ));
  }

  Widget _buildSubmitButton() {
    return Obx(() => SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: _isSubmitting.value
            ? null
            : () {
          if (_formKey.currentState!.validate()) {
            _isSubmitting.value = true;
            submitRequest();
          }
        },
        child: _isSubmitting.value
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


  void submitRequest() {

    sendRequestToProvider(
      providerId: provider.id,
      userId:'1',
      carProblem: _malfunctionCause.value,
      carSize: _carSize.value,
      placeOfLoading1: _loadingRegion.value,
      placeOfLoading2: _loadingCity.value,
      placeOfLoading3:  _loadingDistrict.value,
      placeToGo1:   _destinationRegion.value,
      placeToGo2: _destinationCity.value,
      placeToGo3: _destinationDistrict.value,
      // servicePricing: _servicePricing.value,
    );
    // Simulate a network request
    Future.delayed(const Duration(seconds: 2), () {
      Get.off(MainUserPage());
      _isSubmitting.value = false;
      Get.snackbar(
        'Success'.tr,
        'Request submitted successfully'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    });
    triggerNotification('طلب جديد ');
  }


  Future<void> sendRequestToProvider({
    required String providerId,
    required String userId,
    required String carProblem,
    required String carSize,
    required String placeOfLoading1,
    required String placeOfLoading2,
    required String placeOfLoading3,
    required String placeToGo1,
    required String placeToGo2,
    required String placeToGo3,
    // required String servicePricing,
  }) async {
    try {
      // Get a reference to the Firestore instance
      final firestore = FirebaseFirestore.instance;

      // Create a new document in the 'requests' collection with an auto-generated ID
      final docRef = firestore.collection('requests').doc();

      // Get the current timestamp
      final timestamp = DateTime.now();

      // Format the timestamp if needed (optional)
      final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp);

      // Create the request data map
      final requestData = {
        'id': docRef.id, // Use the auto-generated document ID
        'providerId': providerId,
        'userId': userId,
        'carProblem': carProblem,
        'carSize': carSize,
        'hiddenByProvider': false, // Default value
        'placeOfLoading1': placeOfLoading1,
        'placeOfLoading2': placeOfLoading2,
        'placeOfLoading3': placeOfLoading3,
        'placeToGo1': placeToGo1,
        'placeToGo2': placeToGo2,
        'placeToGo3': placeToGo3,
        // 'servicePricing': servicePricing,
        'status': 'pending', // Default status
        'timestamp': timestamp, // Store as Firestore Timestamp
        'formattedDate': formattedDate, // Optional: human-readable date
      };

      // Set the data in the document
      await docRef.set(requestData);

      final box=GetStorage();

      box.write("request_id",docRef.id.toString());

      print('Request sent successfully with ID: ${docRef.id}');

    } catch (e) {
      print('Error sending request: $e');
      // You might want to rethrow the error or handle it differently
      throw e;
    }
  }



// submitRequest() and sendRequestToProvider() methods stay the same as you wrote them.
}
