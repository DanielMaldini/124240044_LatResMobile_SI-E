import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/item.dart';

class ApiService {
  static const String baseUrl = 'https://api.spaceflightnewsapi.net/v4';

  static Future<List<Item>> getItems(String type) async {
    final response = await http.get(Uri.parse('$baseUrl/$type/?limit=30'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((e) => Item.fromApi(e, type)).toList();
    } else {
      throw Exception('Failed to load $type');
    }
  }

  static Future<Item> getDetail(String type, int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$type/$id/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Item.fromApi(data, type);
    } else {
      throw Exception('Failed to load detail');
    }
  }
}