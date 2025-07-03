import 'package:first_project/models/KSA_places.dart';

class KSASearchHelper {
  static List<Map<String, String>> search(String query) {
    final List<Map<String, String>> results = [];
    final lowerQuery = query.toLowerCase();

    final Set<String> seen = {}; // لتجنب التكرار

    KSA.regions.forEach((region, cities) {
      cities.forEach((city, districts) {
        for (final district in districts) {
          final match = region.toLowerCase().contains(lowerQuery) ||
              city.toLowerCase().contains(lowerQuery) ||
              district.toLowerCase().contains(lowerQuery);

          if (match) {
            final key = '$region-$city-$district';
            if (!seen.contains(key)) {
              seen.add(key);
              results.add({
                'region': region,
                'city': city,
                'district': district,
              });
            }
          }
        }
      });
    });

    return results;
  }
}

