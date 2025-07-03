import 'package:first_project/views/user_views/main_user_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TestOffersPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to create 10 dummy offers
  Future<void> _createDummyOffers() async {
    String userId = 'user123';
    // Replace with the actual user ID

    String providerId = "provider456";

    const List<String> providerNames = [
      'ناصر سليمان',
      'ياسر خالد',
      'عمر علي',
      'محمد فارس',
    ];

    const List<double> distances = [
      5.2,
      7.8,
      3.5,
      10.1,
    ];
    const List<String> status = [
      'Pending',
      'Accepted',
      'rejected',
      'confirmed'
    ];

    for (int i = 0; i < providerNames.length; i++) {
      await _firestore.collection('offers').add({
        'userId': userId,
        'providerName': providerNames[i],
        'providerId': providerId,
        'distance': distances[i],
        'price': '700 SAR',
        'timeOfOffer': Timestamp.fromDate(DateTime.now()),
        'status': status[i],
        'placeOfLoading': 'مكة',
        'destination': 'المدينة',
        'carSize': 'متوسطة الحجم'
      });

      Get.snackbar(
        'Success',
        '4 dummy offers created successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Offers Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _createDummyOffers,
              child: Text('Create 4 Offers'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.off(() => MainUserPage()); // Navigate to MainUserPage
              },
              child: Text('Go to MainUserPage'),
            ),
          ],
        ),
      ),
    );
  }
}
