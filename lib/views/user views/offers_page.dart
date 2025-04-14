import 'package:first_project/controllers/client_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/provider_offer_model.dart';

class OffersPage extends StatelessWidget {
  final ClientController _controller = Get.find<ClientController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'My Tasks'.tr,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            //  color: Colors.white,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.amber,
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              color:Colors.white,
              fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: 'Active Tasks'.tr),
              Tab(text: 'Completed Tasks'.tr),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () => _controller.fetchOffers(),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // Active Tasks Tab
            _buildTaskList(filterDone: false),
            
            // Completed Tasks Tab
            _buildTaskList(filterDone: true),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList({required bool filterDone}) {
    return Obx(() {
      final offers = filterDone
          ? _controller.offers.where((o) => o.status == 'Done').toList()
          : _controller.offers.where((o) => o.status != 'Done').toList();

      if (offers.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                filterDone ? Icons.check_circle_outline : Icons.inbox_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                filterDone ? 'No completed tasks yet'.tr : 'No active tasks'.tr,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }

return Obx(() {
  // Check if any offer has status 'Started'
  final hasStartedOffer = _controller.offers.any((o) => o.status == 'Started');
  
  List<ProviderOfferModel> offers;
  
  if (filterDone) {
    // For completed tasks tab, show all done offers
    offers = _controller.offers.where((o) => o.status == 'Done').toList();
  } else {
    // For active tasks tab
    offers = hasStartedOffer
        ? _controller.offers.where((o) => o.status == 'Started').toList()
        : _controller.offers.where((o) => o.status != 'Done').toList();
  }

  if (offers.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            filterDone ? Icons.check_circle_outline : Icons.inbox_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            filterDone ? 'No completed tasks yet'.tr : 'No active tasks'.tr,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: offers.length,
    itemBuilder: (context, index) {
      final offer = offers[index];
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: _buildOfferCard(offer, showDoneButton: !filterDone),
      );
    },
  );
});
    
      // return ListView.builder(
      //   padding: const EdgeInsets.all(16),
      //   itemCount: offers.length,
      //   itemBuilder: (context, index) {
      //     final offer = offers[index];
      //     if(offer.status=='Started'){
      //     //  return Text('xxx');
      //      if(offer.status=='Started'){
      //       return Padding(
      //       padding: const EdgeInsets.only(bottom: 16),
      //       child: _buildOfferCard(offer, showDoneButton: !filterDone),
      //     );
      //   }else{
      //     return const SizedBox(height: 0);
      //   }
      //     //   return Padding(
      //     //   padding: const EdgeInsets.only(bottom: 16),
      //     //   child: _buildOfferCard(offer, showDoneButton: !filterDone),
      //     // );
      //   }else{

  
      //     return Padding(
      //       padding: const EdgeInsets.only(bottom: 16),
      //       child: _buildOfferCard(offer, showDoneButton: !filterDone),
      //     );
      //   }
      //   },
      // );
    });
  }

  Widget _buildOfferCard(ProviderOfferModel offer, {bool showDoneButton = true}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Provider Header
            Row(
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  // decoration: BoxDecoration(
                  //   shape: BoxShape.circle,
                  //   color: Colors.amber.shade100,
                  //   image: offer.providerImage != null
                  //       ? DecorationImage(
                  //           image: NetworkImage(offer.providerImage!),
                  //           fit: BoxFit.cover,
                  //         )
                  //       : null,
                  // ),
                  child: 
                //  offer.providerId= null? 
                  Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.amber.shade800,
                        )
                      //: null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.providerName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber.shade600,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            
                            '4.8 (24)',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (offer.status == 'Pending')
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'New'.tr,
                      style: TextStyle(
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Task Details
            _buildDetailRow(
              icon: Icons.work_outline,
              title: 'Service'.tr,
              value: offer.id.tr,
              color: Colors.purple.shade600,
            ),
            _buildDetailRow(
              icon: Icons.location_on_outlined,
              title: 'distance'.tr,
              value: '${offer.distance} ${'km away'.tr}',
              color: Colors.blue.shade600,
            ),
            _buildDetailRow(
              icon: Icons.attach_money,
              title: 'price'.tr,
              value: '${offer.price} ${'SAR'.tr}',
              color: Colors.green.shade600,
            ),
            const SizedBox(height: 16),

            // Status & Actions
            if (offer.status == 'Started' && showDoneButton)
              Column(
                children: [
                  _buildStatusCard(
                    icon: Icons.directions_car,
                    title: 'Provider In The Way'.tr,
                    subtitle: '${"Estimated Time".tr}: 4${"Mins".tr}',
                    color: Colors.blue.shade600,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle_outline, size: 20),
                      label: Text('DoneTask'.tr),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        _controller.rateProvider(offer.providerId,
                        offer.requestId,
                        offer.id
                        );
                      }
                      //_controller.markOfferAsDone(offer.id),
                    ),
                  ),
                ],
              ),
            
            if (offer.status == 'Pending')
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.check,
                      text: 'Accept'.tr,
                      color: Colors.green.shade600,
                      onPressed: () =>
                          _controller.changeOfferStatus(offer, 'Started'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.currency_exchange,
                      text: 'Negotiate'.tr,
                      color: Colors.orange.shade600,
                      onPressed: () => _showNegotiationDialog(offer),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.close,
                      text: 'Reject'.tr,
                      color: Colors.red.shade600,
                      onPressed: () =>
                          _controller.changeOfferStatus(offer, 'Rejected'),
                    ),
                  ),
                ],
              ),
            
            if (offer.status == 'Done')
              _buildStatusCard(
                icon: Icons.check_circle,
                title: 'Task Completed'.tr,
                subtitle:'',
                // 'Completed on ${DateFormat('MMM dd, yyyy')
               // .format(offer.timeOfOffer.toDate())}',
                color: Colors.green.shade600,
              ),

                if (offer.status == 'Negotiated')
                 _buildStatusCard(
                icon: Icons.check_circle,
                title: 'Negotiated Sent'.tr,
                subtitle:'',
                // 'Completed on ${DateFormat('MMM dd, yyyy')
               // .format(offer.timeOfOffer.toDate())}',
                color: Colors.green.shade600,
              ),



          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildStatusCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3))),
      child: Row(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: color.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _showNegotiationDialog(ProviderOfferModel offer) {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: Get.context!,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.currency_exchange,
                    color: Colors.orange.shade600,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Negotiate Price'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'New Price (SAR)'.tr,
                  hintText: 'Enter counter offer'.tr,
                  prefixIcon: Icon(Icons.attach_money,
                      color: Colors.grey.shade600),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel'.tr,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        Get.find<ClientController>()
                            .negotiateOfferPrice(offer, _controller.text);
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Submit'.tr),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  // ... [Keep all your existing helper methods (_buildDetailRow, _buildStatusCard, etc.)]
}