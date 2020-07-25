import 'dart:convert';

import 'package:momsclub/models/location_model.dart';

import 'package:http/http.dart' as http;

import '../../utils/str_res.dart';

class LocationAPI {
  
  static Future<List<Province>> getProvince() async {
    var url = 'http://dev.farizdotid.com/api/daerahindonesia/provinsi';
    var response = await http.get(url);
    var json = jsonDecode(response.body);
    if (response.statusCode != 200) throw Exception(StrRes.FAILED_LOAD_PROVINCES);  
    if (json['provinsi'] == null) throw Exception(StrRes.FAILED_LOAD_PROVINCES);
    var provinces = new List<Province>();
    json['provinsi'].forEach((v) => provinces.add(new Province.fromJson(v)));
    return provinces;
  }

  static Future<List<City>> getCity(id) async {
    var url = 'https://dev.farizdotid.com/api/daerahindonesia/kota?id_provinsi=${id.toString()}';
    var response = await http.get(url);
    var json = jsonDecode(response.body);
    if (response.statusCode != 200) throw Exception(StrRes.FAILED_LOAD_CITIES);  
    if (json['kota_kabupaten'] == null) throw Exception(StrRes.FAILED_LOAD_CITIES);
    var cities = new List<City>();
    json['kota_kabupaten'].forEach((v) => cities.add(new City.fromJson(v)));
    return cities;
  }

}