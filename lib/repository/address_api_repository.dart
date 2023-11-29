import 'dart:convert';

import 'package:agritechv2/models/addresses/barangay.dart';
import 'package:agritechv2/models/addresses/city.dart';
import 'package:agritechv2/models/addresses/provinces.dart';
import 'package:agritechv2/models/addresses/region.dart';
import 'package:http/http.dart' as http;

class AddressesRepository {
  String base_url = 'https://psgc.gitlab.io/api';
  Future<List<Region>> getAllRegions() async {
    final response = await http.get(Uri.parse('$base_url/regions'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonDataList = json.decode(response.body);
      List<Region> regionList =
          jsonDataList.map((json) => Region.fromJson(json)).toList();

      return regionList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Province>> getProvincesByRegion(String regionCode) async {
    final response =
        await http.get(Uri.parse('$base_url/regions/$regionCode/provinces'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonDataList = json.decode(response.body);
      List<Province> provinceList =
          jsonDataList.map((json) => Province.fromJson(json)).toList();
      return provinceList;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<City>> getCitiesByProvince(String provinceCode) async {
    final response = await http.get(
        Uri.parse('$base_url/provinces/$provinceCode/cities-municipalities/'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonDataList = json.decode(response.body);
      List<City> cities =
          jsonDataList.map((json) => City.fromJson(json)).toList();
      return cities;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Barangay>> getBarangayByCity(String cityCode) async {
    final response = await http
        .get(Uri.parse('$base_url/cities-municipalities/$cityCode/barangays'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonDataList = json.decode(response.body);
      List<Barangay> barangays =
          jsonDataList.map((json) => Barangay.fromJson(json)).toList();
      return barangays;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
