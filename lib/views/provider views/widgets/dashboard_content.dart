import 'package:first_project/controllers/provider_controller.dart';
import 'package:first_project/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardContent extends StatefulWidget {

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  final ProviderController _controller = Get.find();

  @override
  void initState() {
    _controller.loadRequests();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16), // Consistent spacing
        // Provider status
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Load Requests Button
            ElevatedButton(
              onPressed: () {
                _controller.loadRequests();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:buttonColor,
                ///const Color.fromARGB(255, 172, 62, 54), // Custom button color
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
              ),
              child: Text(
                'load_requests'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            // Provider Status Text
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() => Text(
                _controller.isAvailable
                    ? 'status_available'.tr
                    : 'status_busy'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _controller.isAvailable ? Colors.green : Colors.red,
                ),
              )),
            ),
          ],
        ),
        const Divider(
          thickness: 1,
          color: Colors.grey, // Subtle divider color
        ),
        // List of service requests
        Expanded(
          child: Obx(() {
            if (_controller.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 172, 62, 54), // Custom loading color
                ),
              );
            } else if (_controller.serviceRequests.isEmpty) {
              return Center(
                child: Text(
                  'no_requests_found'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: _controller.visibleRequests,
                itemBuilder: (context, index) {
                  if (index >= _controller.serviceRequests.length) {
                    return const SizedBox();
                  }
                  final request = _controller.serviceRequests[index];
                  return Padding(
                      padding: const EdgeInsets.only(left:21,right: 21,top:10,bottom: 10),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                            children: [
                        // Header with request ID
                        Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${'request_id'.tr}: ',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              request.id,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Main content
                      Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              // Time information
                              _buildInfoRow(Icons.access_time, '${'time'.tr}: ${request.time}'),
                          const SizedBox(height: 12),

                          // Destinations section
                          _buildSectionHeader('Location of Loading'.tr),
                          Row(children: [
                            _buildLocationItem(request.destination),
                            if (request.destination2 != null && request.destination2!.isNotEmpty)
                              _buildLocationItem(request.destination2!),
                            if (request.destination3 != null && request.destination3!.isNotEmpty)
                              _buildLocationItem(request.destination3!),
                          ],),

                  const SizedBox(height: 12),

                  // Loading places section
                  _buildSectionHeader('destination'.tr),

                  Row(children: [
                    _buildLocationItem(request.placeOfLoading),
                    if (request.placeOfLoading2 != null && request.placeOfLoading2!.isNotEmpty)
                      _buildLocationItem(request.placeOfLoading2!),
                    if (request.placeOfLoading3 != null && request.placeOfLoading3!.isNotEmpty)
                      _buildLocationItem(request.placeOfLoading3!),
                  ],),



                  const SizedBox(height: 12),

                  // Car information
                  Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                  _buildInfoChip(Icons.directions_car, '${'car_size'.tr}: ${request.carSize}'),
                  _buildInfoChip(Icons.info_outline, '${'car_status'.tr}: ${request.carStatus}'),
                  ],
                  ),

                  const SizedBox(height: 16),

                  // Pricing input
                  TextField(
                  decoration: InputDecoration(
                  labelText: 'service_pricing'.tr,
                  labelStyle: const TextStyle(color: Color(0xffB48481)),
                  hintText: 'enter_amount'.tr,
                  prefixIcon:  Icon(Icons.money, color: primary),
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xffB48481)),
                  //errorText: request.servicePricing == null ||
                //  (request.servicePricing!.isEmpty ||
                  //double.tryParse(request.servicePricing!) == null ||
                  //double.parse(request.servicePricing!) <= 0)
                  //? 'valid_price_error'.tr
                    //  : null,
                  )
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) => request.servicePricing = value,
                  ),
                  ],
                  ),
                  ),

                  // Action buttons
                  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  OutlinedButton.icon(
                  icon: const Icon(Icons.visibility_off, size: 18),
                  label: Text('hide'.tr),
                  style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey,
                  side: const BorderSide(color: Colors.grey),
                  ),
                  onPressed: () => _controller.hideRequest(request.id),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                  icon: const Icon(Icons.send, size: 18),
                  label: Text('send_offer'.tr),
                  style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                  print("req==${request.id}");
                  _controller.sendOffer(request.id, request.servicePricing);
                  _controller.sendOfferToClient(request.id, request.servicePricing, request);
                  },
                  ),
                  ],
                  ),
                  ),
                  ],
                  ),
                  ),
                  );
                },
              );
            }
          }),
        ),
        // Load More Button
        Obx(() {
          if (_controller.visibleRequests < _controller.serviceRequests.length) {
            return Padding(
              padding: const EdgeInsets.all(7.0),
              child: ElevatedButton(
                onPressed: _controller.loadMoreRequests,
                style: ElevatedButton.styleFrom(
                  backgroundColor:buttonColor,
                  //const Color.fromARGB(255, 172, 62, 54),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                ),
                child: Text(
                  'more'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        }),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildLocationItem(String location) {
    return Container(
      width: 105,
      height: 88,
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              location,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(text, style: const TextStyle(fontSize: 12)),
      backgroundColor: Colors.grey[100],
      visualDensity: VisualDensity.compact,
    );
  }
}
