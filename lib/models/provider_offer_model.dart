import 'package:cloud_firestore/cloud_firestore.dart';

class ProviderOfferModel {
  final String id;
  final String providerId;
  final String userId;
  final String providerName;
  final String providerImage;
  final String requestId;
  final String carStatus;

  final double distance;
  final String price;
  final Timestamp timeOfOffer;
  final String status;
  final String carSize;
  final String placeOfLoading;
  final String placeOfLoading2;
  final String placeOfLoading3;
  final String destination;
  final String destination2;
  final String destination3;

  ProviderOfferModel({
    required this.id,
    required this.providerId,
    required this.userId,
    required this.requestId,
    required this.destination2,
    required this.destination3,
    required this.providerName,
    required this.providerImage,
    required this.distance,
    required this.price,
    required this.timeOfOffer,
    required this.status,
    required this.carStatus,
    required this.carSize,
    required this.placeOfLoading,
    required this.placeOfLoading2,
    required this.placeOfLoading3,
    required this.destination,
  });

  // Factory method to create an Offer from a Firestore document
  factory ProviderOfferModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ProviderOfferModel(
      id: data['offerId'],
      providerId: data['providerId'] ?? '1',
      requestId: data['requestId'] ?? '1',
      userId: data['userId']??"1",
      providerImage: data['image']??'',
      providerName: data['providerName']??"",
      distance: data['distance'].toDouble()??90,
      price: data['price']??'90',
      timeOfOffer: data['timeOfOffer']??Timestamp.now(),
      status: data['status']??'Pending',
      carSize: data['carSize']??'',
      carStatus: data['carStatus']??'',
      placeOfLoading: data['placeOfLoading']??"",
      placeOfLoading2: data['placeOfLoading2']??"",
      placeOfLoading3: data['placeOfLoading3']??"",
      destination: data['destination']??"x",
      destination2: data['destination2']??"x",
      destination3: data['destination3']??"x",
    );
  }

  // Factory method to create an Offer from a JSON map
  factory ProviderOfferModel.fromJson(Map<String, dynamic> json) {
    return ProviderOfferModel(
      id: json['offerId'] ?? '', // Provide a default value if 'id' is not present
      providerId: json['providerId'] ?? '1',
      userId: json['userId']??"",
      requestId: json['requestId']??"",
      providerName: json['providerName']??"",
      distance: json['distance'].toDouble()??90,
      price: json['price']??"",
      timeOfOffer: (json['timeOfOffer']??Timestamp.now()), // Parse ISO 8601 string
      status: json['status']??"",
      carSize: json['carSize']??'',
      carStatus: json['carStatus']??'',
      providerImage: json['image'],
      placeOfLoading: json['placeOfLoading']??"",
      placeOfLoading2: json['placeOfLoading2']??"",
      placeOfLoading3: json['placeOfLoading3']??"",
      destination: json['destination']??"",
      destination2: json['destination2']??"",
      destination3: json['destination3']??"",
    );
  }

  // Convert model to Map for Firestore operations
  Map<String, dynamic> toMap() {
    return {
      'userId': userId??"",
      'providerName': providerName??"",
      'providerId': providerId??"",
      'distance': distance??"",
      'price': price??"",
      //'timeOfOffer': Timestamp.fromDate(timeOfOffer),
      'status': status??"",
      'placeOfLoading': placeOfLoading??"",
      'destination': destination??"",
      'carSize': carSize??"",
    };
  }

  // Convert model to JSON for API operations
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'providerId': providerId,
      'userId': userId,
      'providerName': providerName,
      'distance': distance,
      'price': price,
      'timeOfOffer': timeOfOffer, // Convert to ISO 8601 string
      'status': status,
      'carSize': carSize,
      'placeOfLoading': placeOfLoading,
      'destination': destination,
    };
  }
}