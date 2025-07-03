import 'package:first_project/controllers/KSA_search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class KSASearchPage extends StatelessWidget {
  final KSASearchController controller = Get.put(KSASearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("البحث عن منطقة / مدينة / حي"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'ابحث عن حي، مدينة أو منطقة',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: controller.search,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.searchResults.isEmpty) {
                  return const Center(child: Text('لا توجد نتائج'));
                }
                return ListView.builder(
                  itemCount: controller.searchResults.length,
                  itemBuilder: (context, index) {
                    final item = controller.searchResults[index];
                    return Card(
                      child: ListTile(
                        title: Text(item['district']!),
                        subtitle: Text('${item['city']} - ${item['region']}'),
                        leading: Icon(Icons.location_on, color: Colors.blue),
                        onTap: () {
                          Get.back(result: {
    'region': item['region'],
    'city': item['city'],
    'district': item['district'],
  });
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
