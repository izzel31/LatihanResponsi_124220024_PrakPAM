import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api.spaceflightnewsapi.net/v4';

  static Future<List> fetchList(String type) async {
    final response = await http.get(Uri.parse('$baseUrl/$type/'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['results'];
    } else {
      throw Exception('Failed to load $type');
    }
  }

  static Future<Map> fetchDetail(String type, int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$type/$id/'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load detail');
    }
  }
}
