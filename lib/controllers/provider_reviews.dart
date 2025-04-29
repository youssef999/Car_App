

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/models/provider_model.dart';
import 'package:get/get.dart';

class ProviderReviewsController extends GetxController{


  List<Map<String,dynamic>>providerReviews=[];

  Future<void> getProviderReviewsAndComments(Provider provider) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('comments')
          .where('providerId', isEqualTo: provider.id)
          .get();
      providerReviews = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      update();
    } catch (e) {
      print('Error fetching provider reviews: $e');
    }
  }





}