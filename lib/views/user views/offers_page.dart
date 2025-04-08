import 'dart:ui';
import 'package:first_project/controllers/client_controller.dart';
import 'package:first_project/models/provider_offer_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OffersPage extends StatelessWidget {
  final ClientController _controller = Get.find<ClientController>();

  bool get hasAcceptedOffer =>
      _controller.offers.any((offer) => offer.status == 'Accepted');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
      //  backgroundColor: pr,
        title: Text(
          'Offers'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => _controller.fetchOffers(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white,
                  Colors.white, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Obx(() {
            if (_controller.offers.isEmpty) {
              return Center(
                child: Text(
                  'No offers found'.tr,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(top: kToolbarHeight + 20, bottom: 20),
              itemCount: _controller.offers.length,
              itemBuilder: (context, index) {
                final offer = _controller.offers[index];
                return Padding(
                  padding: const EdgeInsets.only(top:8.0,right: 10,left: 10),
                  child: _buildOfferCard(offer),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOfferCard(ProviderOfferModel offer) {
    final bool isDisabled = hasAcceptedOffer && offer.status != 'Accepted';

    return IgnorePointer(
      ignoring: isDisabled,
      child: Opacity(
        opacity: isDisabled ? 0.4 : 1,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            //withOpacity(0.05),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.15),
                blurRadius: 30,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white10),
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey[100]!,
                      Colors.grey[100]!,
                      Colors.white,
                          //.withOpacity(0.05),
                   //   Colors.white.withOpacity(0.02),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.providerName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _infoRow(Icons.location_on, '${offer.distance} ${'km away'.tr}'),
                    const SizedBox(height: 5),
                    _infoRow(Icons.attach_money, '${offer.price} ${'SAR'.tr}'),
                    const SizedBox(height: 15),
                    if (offer.status == 'Accepted')
                      Container(
                        decoration:BoxDecoration(
                          borderRadius:BorderRadius.circular(13),
                          color:Colors.white
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text(
                            'Waiting for provider confirmation...'.tr,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildActionButton(
                            text: 'Accept'.tr,
                            color: Colors.green,
                            onPressed: () => _controller.changeOfferStatus(offer, 'Accepted'),
                          ),
                          _buildActionButton(
                            text: 'Negotiate'.tr,
                            color: Colors.orange,
                            onPressed: () => _showNegotiationDialog(offer),
                          ),
                          _buildActionButton(
                            text: 'Reject'.tr,
                            color: Colors.red,
                            onPressed: () => _controller.changeOfferStatus(offer, 'Rejected'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.amber),
          const SizedBox(width: 8),
          Text(
            text,
            style:  TextStyle(color: Colors.grey[800]!, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: color.withOpacity(0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
    );
  }

  void _showNegotiationDialog(ProviderOfferModel offer) {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Negotiate Price'.tr,
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'New Price (SAR)'.tr,
            hintText: 'Enter counter offer'.tr,
            hintStyle: const TextStyle(color: Colors.white54),
            labelStyle: const TextStyle(color: Colors.white),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white24),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'.tr,
                style: const TextStyle(color: Colors.white60)),
          ),
          TextButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                Get.find<ClientController>()
                    .negotiateOfferPrice(offer, _controller.text);
                Navigator.pop(context);
              }
            },
            child: Text('Submit'.tr,
                style: const TextStyle(color: Colors.blueAccent)),
          ),
        ],
      ),
    );
  }
}
