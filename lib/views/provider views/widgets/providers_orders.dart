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
          },
          selectedColor: Colors.amber.shade700,
          backgroundColor: Colors.grey.shade200,
          labelStyle: TextStyle(
            color: controller.selectedFilter == value
                ? Colors.white
                : Colors.black,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: controller.selectedFilter == value
                  ? Colors.amber.shade800
                  : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.2),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      
      
      body: Column(
        children: [
         const SizedBox(height: 9,),
          // Filter Section with RadioButtons
          Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      'filter_by'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                        _buildRadioOption(
                          label: 'rejected'.tr,
                          value: 'Rejected',
                          controller: _controller,
                        ),
                        _buildRadioOption(
                          label: 'accepted'.tr,
                          value: 'Started',
                          controller: _controller,
                        ),
                         _buildRadioOption(
                          label: 'startOrder'.tr,
                          value: 'Started',
                          controller: _controller,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          /// ✅ التعامل مع العرض حسب الفلتر داخل Obx
          Expanded(
            child: Obx(() {
              if (_controller.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 172, 62, 54),
                  ),
                );
              }

              final filter = _controller.selectedFilter;

              // عرض الطلبات بناءً على الفلتر المختار
              if (filter == 'Pending') {
                if (_controller.servicePendingRequests.isEmpty) {
                  return _noOrdersWidget();
                }
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: _controller.servicePendingRequests.length,
                  itemBuilder: (context, index) {
                    final order = _controller.servicePendingRequests[index];
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: PendingCardrequest(order: order),
                    );
                  },
                );
              } else if (filter == 'Done') {
                if (_controller.accomplishedOrders.isEmpty) {
                  return _noOrdersWidget();
                }
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: _controller.accomplishedOrders.length,
                  itemBuilder: (context, index) {
                    final order = _controller.accomplishedOrders[index];
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: OrderCard(order: order),
                    );
                  },
                );
              } else {
                // لو Accepted أو Rejected
                final filteredOrders = _controller.accomplishedOrders
                    .where((order) => order.status == filter)
                    .toList();

                if (filteredOrders.isEmpty) {
                  return _noOrdersWidget();
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = filteredOrders[index];
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: OrderCard(order: order),
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}

Widget _noOrdersWidget() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
        const SizedBox(height: 16),
        Text(
          'no_orders_found'.tr,
          style: TextStyle(
            fontSize: 18, 
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        // Text(
        //   'try_changing_filters'.tr,
        //   style: TextStyle(
        //     fontSize: 14, 
        //     color: Colors.grey.shade500,
        //   ),
        // ),
      ],
    ),
  );
}

class OrderCard extends StatelessWidget {
  final ProviderOfferModel order;

  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProviderController _controller = Get.find();
    final formattedTime = DateFormat('MMMM d, y, h:mm a').format(
      order.timeOfOffer.toDate(),
    );

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      shadowColor: Colors.black.withOpacity(0.1),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: _getStatusColor(order.status),
                width: 6,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order ID
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${'order_id'.tr}: #${order.id.substring(0, 8)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.status).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getStatusText(order.status),
                        style: TextStyle(
                          color: _getStatusColor(order.status),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Divider
                Divider(color: Colors.grey.shade200, height: 1),
                const SizedBox(height: 12),

                // Order Details
                _buildDetailRow(
                  icon: Icons.access_time,
                  color: Colors.amber.shade600,
                  title: 'time'.tr,
                  value: formattedTime,
                ),
                _buildDetailRow(
                  icon: Icons.location_on,
                  color: Colors.red.shade400,
                  title: 'destination'.tr,
                  value: order.destination.tr,
                ),
                _buildDetailRow(
                  icon: Icons.directions_car,
                  color: Colors.blue.shade400,
                  title: 'car_size'.tr,
                  value: order.carSize.tr,
                ),
                
                if (order.status == 'Negotiated')
                  _buildDetailRow(
                    icon: Icons.price_change,
                    color: Colors.green.shade600,
                    title: 'New Price'.tr,
                    value: order.price.toString(),
                  )
                else
                  _buildDetailRow(
                    icon: Icons.price_change,
                    color: Colors.green.shade600,
                    title: 'price'.tr,
                    value: '${order.price} SAR',
                  ),

                const SizedBox(height: 16),

                // Action Buttons
                if (order.status == 'Negotiated')
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(color: Colors.red.shade400),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            _controller.updateOfferStatus('Rejected', order.id,
                            order.requestId);
                          },
                          child: Text(
                            'reject_offer'.tr,
                            style: TextStyle(
                              color: Colors.red.shade400,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                            shadowColor: Colors.green.withOpacity(0.3),
                          ),
                          onPressed: () {
                            _controller.updateOfferStatus('Started', order.id,
                            order.requestId
                            );
                          },
                          child: Text(
                            'confirm_offer'.tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else if (order.status == 'Pending' || order.status == 'Accepted')

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                  ),
                  onPressed: (){

                    _controller.updateOfferStatus('Started', order.id,
                      order.requestId
                    
                    );

                }, child: Text('accept_offer_start_task'.tr,
                style:const TextStyle(color:Colors.white,fontWeight: FontWeight.bold,
                fontSize: 18
                ),
                ))
                
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: ElevatedButton.icon(
                  //         icon: const Icon(Icons.call, size: 20, color: Colors.white),
                  //         label: Text("call_now".tr),
                  //         style: ElevatedButton.styleFrom(
                  //           backgroundColor: Colors.green.shade600,
                  //           padding: const EdgeInsets.symmetric(vertical: 12),
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(8),
                  //           ),
                  //           elevation: 2,
                  //           shadowColor: Colors.green.withOpacity(0.3),
                  //         ),
                  //         onPressed: () {},
                  //       ),
                  //     ),
                  //     const SizedBox(width: 12),
                  //     Expanded(
                  //       child: OutlinedButton.icon(
                  //         icon: Icon(Icons.call_made, size: 20, color: Colors.green.shade600),
                  //         label: Text("call_me".tr,
                  //           style: TextStyle(color: Colors.green.shade600)),
                  //         style: OutlinedButton.styleFrom(
                  //           padding: const EdgeInsets.symmetric(vertical: 12),
                  //           side: BorderSide(color: Colors.green.shade600),
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(8),
                  //           ),
                  //         ),
                  //         onPressed: () {},
                  //       ),
                  //     ),
                  //   ],
                  // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Done':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Accepted':
        return Colors.blue;
      case 'Negotiated':
        return Colors.purple;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'Done':
        return 'accomplished'.tr;
      case 'Pending':
        return 'pending'.tr;
      case 'Accepted':
        return 'accepted'.tr;
      case 'Negotiated':
        return 'Negotiated'.tr;
      case 'Rejected':
        return 'rejected'.tr;
      default:
        return status;
    }
  }
}

class PendingCardrequest extends StatelessWidget {
  final RequestModel order;

  const PendingCardrequest({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('MMMM d, y, h:mm a').format(order.time);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      shadowColor: Colors.black.withOpacity(0.1),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: _getStatusColor(order.status),
                width: 6,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order ID
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${'order_id'.tr}: #${order.id.substring(0, 8)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.status).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getStatusText(order.status),
                        style: TextStyle(
                          color: _getStatusColor(order.status),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Divider
                Divider(color: Colors.grey.shade200, height: 1),
                const SizedBox(height: 12),

                // Order Details
                _buildDetailRow(
                  icon: Icons.access_time,
                  color: Colors.amber.shade600,
                  title: 'time'.tr,
                  value: formattedTime,
                ),
                _buildDetailRow(
                  icon: Icons.location_on,
                  color: Colors.red.shade400,
                  title: 'destination'.tr,
                  value: order.destination.tr,
                ),
                _buildDetailRow(
                  icon: Icons.directions_car,
                  color: Colors.blue.shade400,
                  title: 'car_size'.tr,
                  value: order.carSize.tr,
                ),

                const SizedBox(height: 16),

                // Action Buttons
                if (order.status == 'Pending' || order.status == 'Accepted')
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.call, size: 20, color: Colors.white),
                          label: Text("call_now".tr),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                            shadowColor: Colors.green.withOpacity(0.3),
                          ),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: Icon(Icons.call_made, size: 20, color: Colors.green.shade600),
                          label: Text("call_me".tr,
                            style: TextStyle(color: Colors.green.shade600)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(color: Colors.green.shade600),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Done':
        return Colors.green;
      case 'Pending':
      case 'pending':
        return Colors.orange;
      case 'Accepted':
        return Colors.blue;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'Done':
        return 'accomplished'.tr;
      case 'Pending':
      case 'pending':
        return 'pending'.tr;
      case 'Accepted':
        return 'accepted'.tr;
      case 'Rejected':
        return 'rejected'.tr;
      default:
        return status;
    }
  }
}