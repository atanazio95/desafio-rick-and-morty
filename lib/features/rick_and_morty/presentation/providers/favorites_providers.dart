import 'dart:convert';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/domain/entities/character.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _favoritesKey = 'favorites_characters';

class FavoritesNotifier extends StateNotifier<List<Character>> {
  FavoritesNotifier() : super([]) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favoritesJson = prefs.getStringList(_favoritesKey);
    if (favoritesJson != null) {
      state = favoritesJson
          .map((json) => Character.fromJson(jsonDecode(json)))
          .toList();
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> favoritesJson = state
        .map((character) => jsonEncode(character.toJson()))
        .toList();
    prefs.setStringList(_favoritesKey, favoritesJson);
  }

  void addFavorite(Character character) {
    if (!state.any((fav) => fav.id == character.id)) {
      state = [...state, character];
      _saveFavorites();
    }
  }

  void removeFavorite(Character character) {
    state = state.where((fav) => fav.id != character.id).toList();
    _saveFavorites();
  }

  bool isFavorite(Character character) {
    return state.any((fav) => fav.id == character.id);
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<Character>>((ref) {
      return FavoritesNotifier();
    });
