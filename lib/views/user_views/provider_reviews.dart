



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/controllers/provider_reviews.dart';
import 'package:first_project/helper/custom_appbar.dart';
import 'package:first_project/models/provider_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProviderReviews extends StatefulWidget {
  Provider provider;
   ProviderReviews({super.key,required this.provider});

  @override
  State<ProviderReviews> createState() => _ProviderReviewsState();
}

// Add this to format timestamps

class _ProviderReviewsState extends State<ProviderReviews> {
  ProviderReviewsController controller = Get.put(ProviderReviewsController());

  @override
  void initState() {
    controller.getProviderReviewsAndComments(widget.provider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProviderReviewsController>(
      builder: (_) {
        return Scaffold(
          appBar: CustomAppBar(
            title: 'Provider Reviews'.tr,
            back: true,
          ),
          body: controller.providerReviews.isEmpty
              ? const Center(child: Text('No reviews yet.', style: TextStyle(fontSize: 18)))
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.providerReviews.length,
            itemBuilder: (context, index) {
              var review = controller.providerReviews[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rating stars
                      Row(
                        children: List.generate(5, (starIndex) {
                          return Icon(
                            starIndex < (review['rate'] ?? 0)
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 24,
                          );
                        }),
                      ),
                      const SizedBox(height: 8),
                      // Comment text
                      Text(
                        review['comment'] ?? '',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 12),
                      // Timestamp
                      Text(
                        review['timestamp'] != null
                            ? DateFormat('yyyy-MM-dd HH:mm').format(
                          (review['timestamp'] as Timestamp).toDate(),
                        )
                            : '',
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
