import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item.dart';

class FavoriteController extends GetxController {
  final RxList<Item> favorites = <Item>[].obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  // Item dianggap sama kalau type dan id-nya sama (id bisa bentrok antar menu)
  bool isFavorite(Item item) =>
      favorites.any((e) => e.type == item.type && e.id == item.id);

  Future<void> toggle(Item item) async {
    if (isFavorite(item)) {
      favorites.removeWhere((e) => e.type == item.type && e.id == item.id);
    } else {
      favorites.add(item);
    }
    await _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final data = favorites.map((e) => jsonEncode(e.toMap())).toList();
    await prefs.setStringList('favorites', data);
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('favorites') ?? [];
    favorites.assignAll(data.map((e) => Item.fromMap(jsonDecode(e))));
  }
}