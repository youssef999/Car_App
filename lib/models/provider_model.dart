import 'package:first_project/helper/calculate_distance.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Provider {
  final String id;
  final String name;
  final String image;
  final String phone;
  final double rate;
  final LatLng location;
  final String status;
  final List<String> carTransporterSizes;
  double distance;

  Provider({
    required this.id,
    required this.name,
    required this.image,
    required this.phone,
    required this.location,
    required this.rate,
    required this.status,
    required this.carTransporterSizes,
    this.distance = 0.0,
  });

  /// Factory method to create a Provider object from Firestore data
  factory Provider.fromMap(Map<String, dynamic> map) {
    return Provider(
      id: map['id'] ?? '',
      image: map['image']??"",
      rate: map['rate']??0.0,
      phone: map['phone']??'0000',
      name: map['name'] ?? '',
      status: map['status'] ?? 'unknown',
      location: LatLng(
        (map['lat'] ?? 0.0).toDouble(),
        (map['lng'] ?? 0.0).toDouble(),
      ),
      carTransporterSizes: List<String>.from(map['carTransporterSizes'] ?? []),
    );
  }

  /// Convert Provider object to Firestore format
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'location': {
        'lat': location.latitude,
        'lng': location.longitude,
      },
      'carTransporterSizes': carTransporterSizes,
    };
  }

  /// Calculate distance from current location
  void calculateDistanceFrom(LatLng currentLocation) {
    distance = calculateDistance(
      currentLocation.latitude,
      currentLocation.longitude,
      location.latitude,
      location.longitude,
    );
  }
}
