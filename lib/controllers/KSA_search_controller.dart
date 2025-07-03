import 'package:first_project/models/KSA_search_helper.dart';
import 'package:get/get.dart';


class KSASearchController extends GetxController {
  var searchResults = <Map<String, String>>[].obs;

  void search(String query) {
    if (query.trim().isEmpty) {
      searchResults.clear();
    } else {
      searchResults.value = KSASearchHelper.search(query);
    }
  }
}
