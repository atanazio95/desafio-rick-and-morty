import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/presentation/providers/favorites_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/character_card.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    if (favorites.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum personagem favorito ainda.',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      );
    }

    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final character = favorites[index];
        return CharacterCard(character: character);
      },
    );
  }
}
