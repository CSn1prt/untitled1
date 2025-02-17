import 'package:flutter/material.dart';
import 'package:untitled1/repositories/favorites_repository.dart';

class FavoritesListScreen extends StatefulWidget {
  @override
  _FavoritesListScreenState createState() => _FavoritesListScreenState();
}

class _FavoritesListScreenState extends State<FavoritesListScreen> {
  final FavoritesRepository _favoritesRepository = FavoritesRepository();
  List<String> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await _favoritesRepository.getFavorites();
    setState(() {
      _favorites = favorites;
    });
  }

  Future<void> _removeFavorite(String url) async {
    await _favoritesRepository.removeFavorite(url);
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('추가된 즐겨찾기 목록'),
      ),
      body: _favorites.isEmpty
          ? Center(child: Text('추가하신 즐겨찾기가 없습니다.'))
          : ListView.builder(
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_favorites[index]),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeFavorite(_favorites[index]),
            ),
          );
        },
      ),
    );
  }
}
