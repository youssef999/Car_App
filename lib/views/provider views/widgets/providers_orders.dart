// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:first_project/controllers/provider_controller.dart';
import 'package:first_project/models/client_request_model.dart';
import 'package:first_project/models/provider_offer_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProviderOrders extends StatelessWidget {
  final ProviderController _controller = Get.find();

  @override
  Widget build(BuildContext context) {

    Widget _buildRadioOption({
      required String label,
      required String value,
      required ProviderController controller,
    }) {
      return Obx(() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ChoiceChip(
          label: Text(label),
          selected: controller.selectedFilter == value,
          onSelected: (selected) {

        
            if (selected) controller.updateFilter(value);

//             if(controller.selectedFilter=='pending'
            
//             ||controller.selectedFilter=='Pending'){


//            if (selected)    controller.loadPendingRequests();

            
//             }
            
//             else{

//  if (selected) controller.updateFilter(value);
          
//             }
           
          },
          selectedColor: Colors.amber.shade700,
          backgroundColor: Colors.grey.shade200,
          labelStyle: TextStyle(
            color: controller.selectedFilter == value
                ? Colors.white
                : Colors.black,
          ),
        ),
      ));
    }

  return Scaffold(
  body: Column(
    children: [
      // Filter Section with RadioButtons
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'filter_by'.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildRadioOption(
                    label: 'accomplished'.tr,
                    value: 'Done',
                    controller: _controller,
                  ),
                  _buildRadioOption(
                    label: 'pending'.tr,
                    value: 'Pending',
                    controller: _controller,
                  ),
                   _buildRadioOption(
                    label: 'Negotiated'.tr,
                    value: 'Negotiated',
                    controller: _controller,
                  ),
                  //Negotiated
                  _buildRadioOption(
                    label: 'rejected'.tr,
                    value: 'Rejected',
                    controller: _controller,
                  ),
                  _buildRadioOption(
                    label: 'accepted'.tr,
                    value: 'Accepted',
                    controller: _controller,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      const Divider(thickness: 1, color: Colors.grey),

      /// ✅ التعامل مع العرض حسب الفلتر داخل Obx
      Obx(() {
        if (_controller.isLoading) {
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 172, 62, 54),
              ),
            ),
          );
        }

        final filter = _controller.selectedFilter;

        // عرض الطلبات بناءً على الفلتر المختار
        if (filter == 'Pending') {
          if (_controller.servicePendingRequests.isEmpty) {
            return _noOrdersWidget();
          }
          return Expanded(
            child: ListView.builder(
              itemCount: _controller.servicePendingRequests.length,
              itemBuilder: (context, index) {
                final order = _controller.servicePendingRequests[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PendingCardrequest(order: order),
                );
              },
            ),
          );
        } else if (filter == 'Done') {
          if (_controller.accomplishedOrders.isEmpty) {
            return _noOrdersWidget();
          }
          return Expanded(
            child: ListView.builder(
              itemCount: _controller.accomplishedOrders.length,
              itemBuilder: (context, index) {
                final order = _controller.accomplishedOrders[index];
                return OrderCard(order: order);
              },
            ),
          );
        } else {
          // لو Accepted أو Rejected
          final filteredOrders = _controller.accomplishedOrders
              .where((order) => order.status == filter)
              .toList();

          if (filteredOrders.isEmpty) {
            return _noOrdersWidget();
          }

          return Expanded(
            child: ListView.builder(
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                return OrderCard(order: order);
              },
            ),
          );
        }
      }),
    ],
  ),
);

  }
}

Widget _noOrdersWidget() {
  return Expanded(
    child: Center(
      child: Text(
        'no_orders_found'.tr,
        style: const TextStyle(fontSize: 18, color: Colors.grey),
      ),
    ),
  );
}


class OrderCard extends StatelessWidget {
  final ProviderOfferModel order;

  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format the Timestamp to a human-readable string
    final formattedTime = DateFormat('MMMM d, y, h:mm a').format(
      order.timeOfOffer.toDate(),
    );


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 4, // Add shadow for depth
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10), // Rounded corners for InkWell
          onTap: () {
            // Add navigation or action when the card is tapped
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order ID
                Text(
                  '${'order_id'.tr}: ${order.id}',
                  style: const TextStyle(
                    fontSize: 13,
                    color:Colors.grey,
                    fontWeight: FontWeight.w500,

                  ),
                ),
                const SizedBox(height: 8), // Spacing

                // Time of Offer
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.orange),
                    const SizedBox(width: 8), // Spacing
                    Text(
                      '${'time'.tr}: $formattedTime',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8), // Spacing

                // Destination
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.orange),
                    const SizedBox(width: 8), // Spacing
                    Text(
                      '${'destination'.tr}: ${order.destination.tr}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8), // Spacing

                // Car Size
                Row(
                  children: [
                    const Icon(Icons.directions_car, size: 16, color: Colors.orange),
                    const SizedBox(width: 8), // Spacing
                    Text(
                      '${'car_size'.tr}: ${order.carSize.tr}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                  (order.status=='Negotiated')?
                 Text(
                      '${'New Price (SAR)'.tr}: ${order.price}',
                      style: const TextStyle(fontSize: 14),
                    ):const SizedBox(),
                    //pacing

                     (order.status!='Negotiated')?
                 Text(
                      '${'price'.tr}: ${order.price}',
                      style: const TextStyle(fontSize: 14),
                    ):const SizedBox(),

                // Status
                Row(
                  children: [
                    const Icon(Icons.info, size: 16, color: Colors.orange),
                    const SizedBox(width: 8), // Spacing
                    Text(
                      '${'status'.tr}: ',
                      style: const TextStyle(fontSize: 14),
                    ),
                    (order.status=='Done')?
                        Text('accomplished'.tr,
                        style:const TextStyle(color:Colors.green,fontSize: 16)
                        ):const SizedBox(),

                    (order.status=='Pending')?
                    Text('pending'.tr,
                        style:const TextStyle(color:Colors.orange,fontSize: 16)
                    ):const SizedBox(),

                    (order.status=='Accepted')?
                    Text('accepted'.tr,
                        style:const TextStyle(color:Colors.green,fontSize: 16)
                    ):const SizedBox(),


                  (order.status=='Negotiated')?
                    Text('Negotiated'.tr,
                        style:const TextStyle(color:Colors.amber,fontSize: 16)
                    ):const SizedBox(),


                    (order.status=='Rejected')?
                    Text('rejected'.tr,
                        style:const TextStyle(color:Colors.red,fontSize: 16)
                    ):const SizedBox(),



                    // (order.status == 'Pending')?
                    // Text(
                    //   'بانتظار الموافقة ',
                    //   style: TextStyle(
                    //     fontSize: 14,
                    //     color: order.status == 'accomplished'
                    //         ? Colors.green
                    //         : Colors.orange, // Dynamic status color
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ):const SizedBox(),
                  ],
                ),
                const SizedBox(height: 16),


                (order.status=='Pending'||order.status=='Accepted')?
             Row(
                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                  children: [
                  const Icon(Icons.call, size: 16, color: Colors.green),

                  ElevatedButton(

                      onPressed:(){

                  } , child: const Text("اتصل الان",style:TextStyle(
                    color:Colors.green,
                  ),)),


                    ElevatedButton(

                        onPressed:(){

                        } , child: const Text("اتصل بي ",style:TextStyle(
                      color:Colors.green,
                    ),))




                ],):const SizedBox(),

                // Call-to-Action Button
                // Center(
                //   child: ElevatedButton(
                //     onPressed: () {
                //       // Add action for the button
                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.blue, // Button color
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(8), // Rounded corners
                //       ),
                //     ),
                //     child: Text(
                //       'view_details'.tr,
                //       style: const TextStyle(color: Colors.white),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}



class PendingCardrequest extends StatelessWidget {
  final RequestModel order;

  const PendingCardrequest({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format the Timestamp to a human-readable string
    final formattedTime = DateFormat('MMMM d, y, h:mm a').format(
      order.time,
    );


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 4, // Add shadow for depth
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10), // Rounded corners for InkWell
          onTap: () {
            // Add navigation or action when the card is tapped
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order ID
                Text(
                  '${'order_id'.tr}: ${order.id}',
                  style: const TextStyle(
                    fontSize: 13,
                    color:Colors.grey,
                    fontWeight: FontWeight.w500,

                  ),
                ),
                const SizedBox(height: 8), // Spacing

                // Time of Offer
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.orange),
                    const SizedBox(width: 8), // Spacing
                    Text(
                      '${'time'.tr}: $formattedTime',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8), // Spacing

                // Destination
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.orange),
                    const SizedBox(width: 8), // Spacing
                    Text(
                      '${'destination'.tr}: ${order.destination.tr}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8), // Spacing

                // Car Size
                Row(
                  children: [
                    const Icon(Icons.directions_car, size: 16, color: Colors.orange),
                    const SizedBox(width: 8), // Spacing
                    Text(
                      '${'car_size'.tr}: ${order.carSize.tr}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8), // Spacing

                // Status
                Row(
                  children: [
                    const Icon(Icons.info, size: 16, color: Colors.orange),
                    const SizedBox(width: 8), // Spacing
                    Text(
                      '${'status'.tr}: ',
                      style: const TextStyle(fontSize: 14),
                    ),
                    (order.status=='Done')?
                        Text('accomplished'.tr,
                        style:const TextStyle(color:Colors.green,fontSize: 16)
                        ):const SizedBox(),

                    (order.status=='Pending'||order.status=='pending')?
                    Text('pending'.tr,
                        style:const TextStyle(color:Colors.orange,fontSize: 16)
                    ):const SizedBox(),

                    (order.status=='Accepted')?
                    Text('accepted'.tr,
                        style:const TextStyle(color:Colors.green,fontSize: 16)
                    ):const SizedBox(),

                    (order.status=='Rejected')?
                    Text('rejected'.tr,
                        style:const TextStyle(color:Colors.red,fontSize: 16)
                    ):const SizedBox(),



                    // (order.status == 'Pending')?
                    // Text(
                    //   'بانتظار الموافقة ',
                    //   style: TextStyle(
                    //     fontSize: 14,
                    //     color: order.status == 'accomplished'
                    //         ? Colors.green
                    //         : Colors.orange, // Dynamic status color
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ):const SizedBox(),
                  ],
                ),
                const SizedBox(height: 16),


                (order.status=='Pending'||order.status=='Accepted')?
             Row(
                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                  children: [
                  const Icon(Icons.call, size: 16, color: Colors.green),

                  ElevatedButton(

                      onPressed:(){

                  } , child: const Text("اتصل الان",style:TextStyle(
                    color:Colors.green,
                  ),)),


                    ElevatedButton(

                        onPressed:(){

                        } , child: const Text("اتصل بي ",style:TextStyle(
                      color:Colors.green,
                    ),))




                ],):const SizedBox(),

                // Call-to-Action Button
                // Center(
                //   child: ElevatedButton(
                //     onPressed: () {
                //       // Add action for the button
                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.blue, // Button color
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(8), // Rounded corners
                //       ),
                //     ),
                //     child: Text(
                //       'view_details'.tr,
                //       style: const TextStyle(color: Colors.white),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
