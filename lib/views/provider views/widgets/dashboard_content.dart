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
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 4, // Add shadow for depth
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                      child: ListTile(
                        title: Row(
                          children: [
                            Text(
                              'request_id'.tr,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ), Text(
                        request.id,
                              style: const TextStyle(
                                fontSize: 10,
                                color:Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8), // Spacing
                            Text('${'time'.tr}: ${request.time}'),
                            Text('${'destination'.tr}: ${request.destination}'),
                            Text('${'car_size'.tr}: ${request.carSize}'),
                            Text('${'car_status'.tr}: ${request.carStatus}'),
                            Text('${'place_of_loading'.tr}: ${request.placeOfLoading}'),
                            const SizedBox(height: 8), // Spacing
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'service_pricing'.tr,
                                labelStyle: const TextStyle(color: Color(0xffB48481)),
                                hintText: 'enter_amount'.tr,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8), // Rounded corners
                                  borderSide: const BorderSide(color: Colors.grey),
                                ),
                                errorText: request.servicePricing == null ||
                                    (request.servicePricing!.isEmpty ||
                                        double.tryParse(request.servicePricing!) == null ||
                                        double.parse(request.servicePricing!) <= 0)
                                    ? 'valid_price_error'.tr
                                    : null,
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                request.servicePricing = value;
                              },
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility_off, color: Colors.grey),
                              onPressed: () => _controller.hideRequest(request.id),
                            ),
                            IconButton(
                              icon: const Icon(Icons.send, color: Colors.amber),
                              onPressed: () {
                                  // ignore: avoid_print
                                  print("req==${request.id}");
                                _controller.sendOffer(request.id, request.servicePricing);
                          _controller.sendOfferToClient(request.id,request.servicePricing,request);
                              }
                            ),
                          ],
                        ),
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
}
