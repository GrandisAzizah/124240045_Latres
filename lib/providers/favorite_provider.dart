import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProvider extends ChangeNotifier {
  static const String _favKey = 'favorite_characters';
  List<String> _favorites = [];

  List<String> get favorites => _favorites;

  // Muat data saat aplikasi pertama kali dibuka
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favorites = prefs.getStringList(_favKey) ?? [];
    notifyListeners();
  }

  // Cek apakah karakter ada di favorit
  bool isFavorite(String id) => _favorites.contains(id);

  // Tambah / Hapus favorit
  Future<void> toggleFavorite(String id) async {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    notifyListeners(); // Beri tahu seluruh UI kalau data berubah

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favKey, _favorites);
  }

  // Hapus spesifik (untuk swipe to delete)
  Future<void> removeFavorite(String id) async {
    _favorites.remove(id);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favKey, _favorites);
  }
}
