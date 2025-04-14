import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/main.dart';
import 'package:first_project/models/KSA_places.dart';
import 'package:first_project/models/provider_model.dart';
import 'package:first_project/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import 'main_user_page.dart';

class ProviderDetailsPage extends StatelessWidget {
  final Provider provider;

  ProviderDetailsPage({required this.provider});

  final _formKey = GlobalKey<FormState>();
  final _carSize = 'Small'.obs;
  final _malfunctionCause = 'Traffic Accident'.obs;
  final _isSubmitting = false.obs;

  // For Location of Loading
  final RxString _loadingRegion = ''.obs;
  final RxString _loadingCity = ''.obs;
  final RxString _loadingDistrict = ''.obs;

// For Destination
  final RxString _destinationRegion = ''.obs;
  final RxString _destinationCity = ''.obs;
  final RxString _destinationDistrict = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Provider Details'.tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Provider Information
              _buildProviderInfo(),
              const SizedBox(height: 24),
              Text('Please enter the following data : '.tr),

              // Car Size Selection
              _buildSectionTitle('Car Size'.tr),
              _buildCarSizeSelection(),
              const SizedBox(height: 16),

              // Malfunction Cause Selection
              _buildSectionTitle('Car Malfunction Cause'.tr),
              _buildMalfunctionCauseSelection(),
              const SizedBox(height: 16),

              // Location of Loading (Dropdowns)
              _buildSectionTitle('Location of Loading'.tr),
              _buildLocationDropdowns(),
              const SizedBox(height: 16),

              // Destination (Dropdowns)
              _buildSectionTitle('Destination'.tr),
              _buildDestinationDropdowns(),
              const SizedBox(height: 24),

              // Submit Button
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationDropdowns() {
    return Column(
      children: [
        // Region Dropdown
        Obx(() => DropdownButtonFormField<String>(
              value: _loadingRegion.value.isEmpty ? null : _loadingRegion.value,
              onChanged: (value) {
                _loadingRegion.value = value!;
                _loadingCity.value = ''; // Reset city when region changes
                _loadingDistrict.value =
                    ''; // Reset district when region changes
              },
              items: KSA.regions.keys.map((region) {
                return DropdownMenuItem(
                  value: region,
                  child: Text(region),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Region'.tr,
                border: const OutlineInputBorder(),
              ),
            )),
        const SizedBox(height: 16),

        // City Dropdown
        Obx(() => DropdownButtonFormField<String>(
              value: _loadingCity.value.isEmpty ? null : _loadingCity.value,
              onChanged: (value) {
                _loadingCity.value = value!;
                _loadingDistrict.value = ''; // Reset district when city changes
              },
              items: _loadingRegion.value.isEmpty
                  ? []
                  : KSA.regions[_loadingRegion.value]!.keys.map((city) {
                      return DropdownMenuItem(
                        value: city,
                        child: Text(city),
                      );
                    }).toList(),
              decoration: InputDecoration(
                labelText: 'City'.tr,
                border: const OutlineInputBorder(),
              ),
            )),
        const SizedBox(height: 16),

        // District Dropdown
        Obx(() => DropdownButtonFormField<String>(
              value: _loadingDistrict.value.isEmpty
                  ? null
                  : _loadingDistrict.value,
              onChanged: (value) {
                _loadingDistrict.value = value!;
              },
              items: _loadingCity.value.isEmpty
                  ? []
                  : KSA.regions[_loadingRegion.value]![_loadingCity.value]!
                      .map((district) {
                      return DropdownMenuItem(
                        value: district,
                        child: Text(district),
                      );
                    }).toList(),
              decoration: InputDecoration(
                labelText: 'District'.tr,
                border: const OutlineInputBorder(),
              ),
            )),
      ],
    );
  }

  Widget _buildDestinationDropdowns() {
    return Column(
      children: [
        // Region Dropdown
        Obx(() => DropdownButtonFormField<String>(
              value: _destinationRegion.value.isEmpty
                  ? null
                  : _destinationRegion.value,
              onChanged: (value) {
                _destinationRegion.value = value!;
                _destinationCity.value = ''; // Reset city when region changes
                _destinationDistrict.value =
                    ''; // Reset district when region changes
              },
              items: KSA.regions.keys.map((region) {
                return DropdownMenuItem(
                  value: region,
                  child: Text(region),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Region'.tr,
                border: const OutlineInputBorder(),
              ),
            )),
        const SizedBox(height: 16),

        // City Dropdown
        Obx(() => DropdownButtonFormField<String>(
              value: _destinationCity.value.isEmpty
                  ? null
                  : _destinationCity.value,
              onChanged: (value) {
                _destinationCity.value = value!;
                _destinationDistrict.value =
                    ''; // Reset district when city changes
              },
              items: _destinationRegion.value.isEmpty
                  ? []
                  : KSA.regions[_destinationRegion.value]!.keys.map((city) {
                      return DropdownMenuItem(
                        value: city,
                        child: Text(city),
                      );
                    }).toList(),
              decoration: InputDecoration(
                labelText: 'City'.tr,
                border: const OutlineInputBorder(),
              ),
            )),
        const SizedBox(height: 16),

        // District Dropdown
        Obx(() => DropdownButtonFormField<String>(
              value: _destinationDistrict.value.isEmpty
                  ? null
                  : _destinationDistrict.value,
              onChanged: (value) {
                _destinationDistrict.value = value!;
              },
              items: _destinationCity.value.isEmpty
                  ? []
                  : KSA.regions[_destinationRegion.value]![
                          _destinationCity.value]!
                      .map((district) {
                      return DropdownMenuItem(
                        value: district,
                        child: Text(district),
                      );
                    }).toList(),
              decoration: InputDecoration(
                labelText: 'District'.tr,
                border: const OutlineInputBorder(),
              ),
            )),
      ],
    );
  }

  // Other methods (_buildProviderInfo, _buildCarSizeSelection, etc.) remain unchanged

  Widget _buildProviderInfo() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              provider.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${provider.distance.toString().substring(0, 4)} ',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                Text(
                  'km away'.tr,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "${'Status'.tr}: ${provider.status}",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: (provider.status == 'متاح') ? Colors.green : Colors.red,
              ),
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
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCarSizeSelection() {
    return Obx(() => Column(
          children: ['Small'.tr, 'Medium'.tr, 'Large'.tr].map((size) {
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: RadioListTile(
                title: Text(size),
                value: size,
                groupValue: _carSize.value,
                onChanged: (value) {
                  _carSize.value = value!;
                },
              ),
            );
          }).toList(),
        ));
  }

  Widget _buildMalfunctionCauseSelection() {
    return Obx(() => Column(
          children:
              ['Traffic Accident'.tr, 'Technical Malfunction'.tr].map((cause) {
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: RadioListTile(
                title: Text(cause),
                value: cause,
                groupValue: _malfunctionCause.value,
                onChanged: (value) {
                  _malfunctionCause.value = value!;
                },
              ),
            );
          }).toList(),
        ));
  }

  Widget _buildStaticLocationText() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'العبور',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildStaticDestinationText() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'مدينة نصر',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() => SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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
                      fontSize: 16,
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




}
