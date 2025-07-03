import 'package:first_project/controllers/requests_controller.dart';
import 'package:first_project/values/colors.dart';
import 'package:first_project/views/user_views/offers_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'main_user_page.dart'; // For date formatting

class RequestsView extends StatefulWidget {
  const RequestsView({super.key});

  @override
  State<RequestsView> createState() => _RequestsViewState();
}

class _RequestsViewState extends State<RequestsView> {
  final RequestsController controller = Get.put(RequestsController());

  @override
  void initState() {
    controller.getUserRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //backgroundColor: Colors.orange,
          toolbarHeight: 60,
          title: Text(
            "Requests".tr,
            style: const TextStyle(
              //color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: true,
          elevation: 4,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
          )),
          body: GetBuilder<RequestsController>(
            builder: (_) {
              if (controller.userRequestList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.list_alt, size: 60, color: Colors.grey[400]),
                      const SizedBox(height: 20),
                      Text(
                        "No requests found".tr,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () => controller.getUserRequests(),
                        child: Text("Refresh".tr),
                      ),
                    ],
                  ),
                );
              }else{


                print("data===="+controller.userRequestList[0].placeOfLoading);
                print("data===="+controller.userRequestList[0].placeOfLoading2);
                print("data===="+controller.userRequestList[0].placeOfLoading3);
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.separated(
                    itemCount: controller.userRequestList.length,
                    separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final request = controller.userRequestList[index];
                      final dateFormat = DateFormat('MMM dd, yyyy - hh:mm a');
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Card(
                          elevation: 0, // Using custom shadow instead
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Request Header with improved shadow
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.greenAccent.withOpacity(0.1),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${" "}${"Request".tr} #  ${request.id.toString()}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(request.status),
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: _getStatusColor(request.status).withOpacity(0.3),
                                              blurRadius: 4,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          (request.status=='accepted')?
                                          'providerSentOffer'.tr:
                                          (request.status).tr.toUpperCase().tr,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Divider with subtle shadow
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        blurRadius: 2,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Divider(color: Colors.grey[300], height: 1),
                                ),
                                const SizedBox(height: 12),

                                // Loading Information with improved layout
                                Row(
                                  mainAxisAlignment:MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      width: 122,
                                      child: _buildLocationSection(
                                        icon: Icons.upload,
                                        title: "loadingPoints".tr,
                                        locations: [
                                          request.placeOfLoading,

                                          if (request.placeOfLoading2.isNotEmpty) request.placeOfLoading2,
                                          if (request.placeOfLoading3.isNotEmpty) request.placeOfLoading3,
                                        ],
                                      ),
                                    ),


                                    SizedBox(
                                      width: 110,
                                      child: _buildLocationSection(
                                        icon: Icons.location_on,
                                        title: "destinations".tr,
                                        locations: [
                                          request.destination,
                                          if (request.destination2.isNotEmpty) request.destination2,
                                          if (request.destination3.isNotEmpty) request.destination3,
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                // Destinations section


                                const SizedBox(height: 2),
                                _buildInfoCard(
                                  icon: Icons.directions_car,
                                  title: "vehicleStatus".tr,
                                  value: request.carStatus,
                                ),

                                // Vehicle and Date Info with improved cards
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildInfoCard(
                                        icon: Icons.directions_car,
                                        title: "vehicleSize".tr,
                                        value: request.carSize,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _buildInfoCard(
                                        icon: Icons.calendar_today,
                                        title: "requestDate".tr,
                                        value: dateFormat.format(request.time),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4,),
                                (request.status=='accepted')?
                                Center(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: buttonColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        elevation: 4, // إضافة ظل للزر
                                      ),
                                      onPressed: (){
                                        Get.to(OffersPage());
                                      }, child: Text(
                                    "viewProviderOffer".tr,style:TextStyle(color:textColorLight),
                                  )),
                                ):const SizedBox(),
                                const SizedBox(height: 4,),
                                ( request.status=='pending'||request.status=='Pending')?
                                Center(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:buttonColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        elevation: 4, // إضافة ظل للزر
                                      ),
                                      onPressed: (){
                                        Get.to(OffersPage());

                                      }, child: Text(
                                    "view offers".tr,style:TextStyle(color:textColorLight),
                                  )),
                                ):SizedBox(),


                                (request.status!='done'&&request.status!='Done')? Text(dateFormat.format(request.time),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ):const SizedBox(),


                                // Center(
                                //   child: ElevatedButton(
                                //       style: ElevatedButton.styleFrom(
                                //         backgroundColor: Colors.red,
                                //         shape: RoundedRectangleBorder(
                                //           borderRadius: BorderRadius.circular(12),
                                //         ),
                                //         elevation: 4, // إضافة ظل للزر
                                //       ),
                                //       onPressed: (){


                                //         controller.cancelRequest(request.id,
                                //         request.providerId
                                //         );
                                //       }, child: Text(
                                //     "cancelRequest".tr,style:TextStyle(color:textColorLight),
                                //   )),
                                // )
                               // :const SizedBox(),



                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }


            },
          ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom:52.0),
        child: FloatingActionButton(
          backgroundColor: appBarColor2,
          onPressed: () => controller.getUserRequests(),
          child: const Icon(Icons.refresh, color: Colors.white),
        ),
      ),
    );
  }


  Widget _buildLocationSection({
    required IconData icon,
    required String title,
    required List<String> locations,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.orange),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...locations.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${entry.key + 1}.",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    entry.value,
                    style: const TextStyle(
                      fontSize: 14,
                      color:Colors.black
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 12),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.purple;
    }
  }
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.orange),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value.isNotEmpty ? value : "Not specified".tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


}
