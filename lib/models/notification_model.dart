import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String type;
  final String orderId;
  final String userId;
  final String providerId;
  final DateTime timestamp;
  final bool read;
  final String carSize;
  final String placeOfLoading;
  final String destination;

  NotificationModel({
    required this.id,
    required this.type,
    required this.orderId,
    required this.userId,
    required this.providerId,
    required this.timestamp,
    required this.read,
    required this.carSize,
    required this.placeOfLoading,
    required this.destination,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> data) {
    return NotificationModel(
      id: data['id']??"",
      type: data['type']??"",
      orderId: data['orderId']??"",
      userId: data['userId']??"",
      providerId: data['providerId']??"",
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      read: data['read'] ?? false,
      carSize: data['carSize']??"",
      placeOfLoading: data['placeOfLoading']??"",
      destination: data['destination']??"",
    );
  }
}
