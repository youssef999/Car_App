import 'package:first_project/controllers/provider_details_controller.dart';
import 'package:first_project/helper/custom_appbar.dart';
import 'package:first_project/models/KSA_places.dart';
import 'package:first_project/models/provider_model.dart';
import 'package:first_project/values/colors.dart';
import 'package:first_project/views/user_views/provider_reviews.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KSAThreeStepSearchPage extends StatefulWidget {
  final void Function({required String region, required String city, required String district}) onSelected;
  const KSAThreeStepSearchPage({super.key, required this.onSelected});

  @override
  State<KSAThreeStepSearchPage> createState() => _KSAThreeStepSearchPageState();
}

class _KSAThreeStepSearchPageState extends State<KSAThreeStepSearchPage> {
  String _region = '';
  String _city = '';
  String _district = '';

  List<String> filteredRegions = KSA.regions.keys.toList();
  List<String> filteredCities = [];
  List<String> filteredDistricts = [];

  TextEditingController searchController = TextEditingController();
  String currentStep = 'region';

  void updateSearch(String query) {
    setState(() {
      if (currentStep == 'region') {
        filteredRegions = KSA.regions.keys
            .where((region) => region.contains(query))
            .toList();
      } else if (currentStep == 'city' && _region.isNotEmpty) {
        filteredCities = KSA.regions[_region]!.keys
            .where((city) => city.contains(query))
            .toList();
      } else if (currentStep == 'district' && _region.isNotEmpty && _city.isNotEmpty) {
        filteredDistricts = KSA.regions[_region]![_city]!
            .where((district) => district.contains(query))
            .toList();
      }
    });
  }

  Widget _buildStepList(List<String> items, Function(String) onTap) {
    return Expanded(
      child: items.isEmpty
          ? const Center(child: Text("No results found"))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(items[index]),
                onTap: () => onTap(items[index]),
              ),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(() => updateSearch(searchController.text));
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Choose Location'.tr, back: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search $currentStep...'.tr,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            if (currentStep == 'region')
              _buildStepList(filteredRegions, (selected) {
                setState(() {
                  _region = selected;
                  _city = '';
                  _district = '';
                  currentStep = 'city';
                  filteredCities = KSA.regions[_region]!.keys.toList();
                  searchController.clear();
                });
              })
            else if (currentStep == 'city')
              _buildStepList(filteredCities, (selected) {
                setState(() {
                  _city = selected;
                  _district = '';
                  currentStep = 'district';
                  filteredDistricts = KSA.regions[_region]![_city]!;
                  searchController.clear();
                });
              })
            else if (currentStep == 'district')
              _buildStepList(filteredDistricts, (selected) {
                setState(() {
                  _district = selected;
                });
                widget.onSelected(region: _region, city: _city, district: _district);
                Get.back();
              }),
            const SizedBox(height: 20),
            if (_region.isNotEmpty || _city.isNotEmpty || _district.isNotEmpty)
              Text(
                '${_region.isNotEmpty ? 'Region: $_region\n' : ''}'
                '${_city.isNotEmpty ? 'City: $_city\n' : ''}'
                '${_district.isNotEmpty ? 'District: $_district' : ''}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}

