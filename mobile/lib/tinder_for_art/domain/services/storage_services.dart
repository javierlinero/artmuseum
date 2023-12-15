import 'dart:convert';

import 'package:puam_app/tinder_for_art/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageHelper {
  static Future<void> saveArtworks(List<TinderArt> artworks) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String artworksJson = jsonEncode(artworks.map((e) => e.toJson()).toList());
    await prefs.setString('saved_artworks', artworksJson);
  }

  static Future<void> clearArtworks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static Future<List<TinderArt>?> loadArtworks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? artworksJson = prefs.getString('saved_artworks');
    if (artworksJson != null) {
      Iterable l = jsonDecode(artworksJson);
      return List<TinderArt>.from(l.map((model) => TinderArt.fromJson(model)));
    }
    return null;
  }

  static Future<void> setFirstRunCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstRun', false);
  }

  static Future<bool> isFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isFirstRun') ?? true;
  }
}
