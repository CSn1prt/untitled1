import 'package:shared_preferences/shared_preferences.dart';

class FavoritesRepository {
  static const String _favoritesKey = 'favorites';

  /// 즐겨찾기 목록을 가져오는 함수
  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  /// 즐겨찾기에 추가하는 함수
  Future<void> addFavorite(String url) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = await getFavorites();

    if (!favorites.contains(url)) {
      favorites.add(url);
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  /// 즐겨찾기에서 삭제하는 함수
  Future<void> removeFavorite(String url) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = await getFavorites();

    if (favorites.contains(url)) {
      favorites.remove(url);
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  /// 즐겨찾기 여부 확인하는 함수
  Future<bool> isFavorite(String url) async {
    List<String> favorites = await getFavorites();
    return favorites.contains(url);
  }
}
