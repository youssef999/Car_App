

import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  final String id;
  final DateTime time;
  final String destination;
  final String destination2;
  final String destination3;
  final String carSize;
  final String carStatus;
  final String userName;
  final String userId;
  String servicePricing;
  final String placeOfLoading;
  final String placeOfLoading2;
  final String placeOfLoading3;
  final String providerId;
  final String status; // field مهم
  final bool hiddenByProvider; // New field

  RequestModel(
      {required this.id,
      required this.time,
        required this.destination2,
        required this.placeOfLoading2, required this.placeOfLoading3,
        required this.destination3,
      required this.destination,
      required this.carSize,
      required this.carStatus,
      required this.servicePricing,
        required this.userId,required this.userName,
      required this.placeOfLoading,
      required this.providerId,
      required this.status,
      this.hiddenByProvider = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time,
      'destination': destination,
      'carSize': carSize,
      'carStatus': carStatus,
      'servicePricing': servicePricing,
      'placeOfLoading': placeOfLoading,
      'providerId': providerId,
      'status': status, // Add this field
      'hiddenByProvider': hiddenByProvider, // Add this field
    };
  }

  factory RequestModel.fromFirestore(DocumentSnapshot data) {
    return RequestModel(
      id: data['id']??"",
      time: data['timestamp'].toDate()??DateTime.now(),
      destination: data['placeToGo1']??'4',
      destination2: data['placeToGo2']??"4",
      destination3: data['placeToGo3']??'x',
      userId: data['userId']??"",
      userName: data['userName']??"",
      carSize: data['carSize']??'dd',
      carStatus: data['carProblem']??"pp",
       servicePricing: '',
       //data['servicePricing1']??"ddc",
      placeOfLoading: data['placeOfLoading1']??"s",
      placeOfLoading2: data['placeOfLoading2']??"pppp",
      placeOfLoading3: data['placeOfLoading3']??"eerr",
      providerId: data['providerId']??"eerr",
      status: data['status']??'pending', // Add this field
      hiddenByProvider:
      data['hiddenByProvider'] ?? false, // Default to false if null
    );
  }

  factory RequestModel.fromMap(Map<String, dynamic> data) {
    return RequestModel(
      id: data['id']??"",
      time: data['timestamp'].toDate()??DateTime.now(),
      destination: data['placeToGo1']??'4',
      userName: data['userName']??"",
      userId: data['userId']??"",
      destination2: data['placeToGo2']??"4",
      destination3: data['placeToGo3']??'x',
      carSize: data['carSize']??'dd',
      carStatus: data['carProblem']??"pp",
      servicePricing: data['servicePricing1']??"ddc",
      placeOfLoading: data['placeOfLoading1']??"s",
      placeOfLoading2: data['placeOfLoading2']??"pppp",
      placeOfLoading3: data['placeOfLoading3']??"eerr",
      providerId: data['providerId']??"eerr",
      status: data['status']??'pending', // Add this field
      hiddenByProvider:
          data['hiddenByProvider'] ?? false, // Default to false if null
    );
  }
}
