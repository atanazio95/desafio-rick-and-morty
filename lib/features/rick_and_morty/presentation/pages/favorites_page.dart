import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/presentation/providers/favorites_providers.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/presentation/providers/view_mode_provider.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/presentation/widgets/character_card.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/presentation/widgets/character_grid_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final isGridView = ref.watch(isGridViewProvider);

    if (favorites.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum personagem favorito ainda.',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      );
    }

    if (isGridView) {
      return GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.7,
        ),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final character = favorites[index];
          return CharacterGridCard(character: character);
        },
      );
    } else {
      return ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final character = favorites[index];
          return CharacterCard(character: character);
        },
      );
    }
  }
}
