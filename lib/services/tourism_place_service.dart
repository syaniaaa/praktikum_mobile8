import 'dart:async';
import 'dart:convert';

import 'package:wisata_app/common/base_url.dart';
import 'package:wisata_app/helper/session_manager.dart';
import 'package:wisata_app/models/tourism_place.dart';

import 'package:http/http.dart' as http;

class TourismPlaceService {
  static List<TourismPlace> _tourismPlaces = []; // List to store tourism places

  static Future<List<TourismPlace>> getTourismPlaces() async {
    final accessToken = await SessionManager.getToken();
    final response = await http.get(
      Uri.parse(BaseURL.urlTourismPlace),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final List data = responseData['data'].map((place) => place).toList();
      _tourismPlaces =
          data.map((place) => TourismPlace.fromJson(place)).toList();
      return _tourismPlaces;
    } else {
      throw Exception('Gagal mendapatkan data wisata');
    }
  }
}
