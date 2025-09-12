import 'dart:convert';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/domain/entities/character.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

// O nome da chave usada para salvar a lista no SharedPreferences.
const String _favoritesKey = 'favorites_characters';

// Notificador de estado para gerenciar a lista de personagens favoritos.
class FavoritesNotifier extends StateNotifier<List<Character>> {
  FavoritesNotifier() : super([]) {
    // Carrega a lista de favoritos do armazenamento local ao inicializar.
    _loadFavorites();
  }

  // Carrega a lista de favoritos do SharedPreferences.
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favoritesJson = prefs.getStringList(_favoritesKey);
    if (favoritesJson != null) {
      // Converte a lista de strings JSON para objetos Character.
      state = favoritesJson
          .map((json) => Character.fromJson(jsonDecode(json)))
          .toList();
    }
  }

  // Salva a lista de favoritos no SharedPreferences.
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    // Converte a lista de objetos Character para uma lista de strings JSON.
    final List<String> favoritesJson = state
        .map((character) => jsonEncode(character.toJson()))
        .toList();
    prefs.setStringList(_favoritesKey, favoritesJson);
  }

  // Adiciona um personagem à lista de favoritos e salva.
  void addFavorite(Character character) {
    if (!state.any((fav) => fav.id == character.id)) {
      state = [...state, character];
      _saveFavorites();
    }
  }

  // Remove um personagem da lista de favoritos e salva.
  void removeFavorite(Character character) {
    state = state.where((fav) => fav.id != character.id).toList();
    _saveFavorites();
  }

  // Verifica se um personagem já está na lista de favoritos.
  bool isFavorite(Character character) {
    return state.any((fav) => fav.id == character.id);
  }
}

// Provedor que expõe o FavoritesNotifier.
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<Character>>((ref) {
      return FavoritesNotifier();
    });
