import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/favorites_provider.dart';
import '../widgets/character_card.dart';

// FavoritesPage é um ConsumerWidget que "escuta" o favoritesProvider.
class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observa a lista de favoritos. A UI será reconstruída quando ela mudar.
    final favorites = ref.watch(favoritesProvider);

    if (favorites.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum personagem favorito ainda.',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      );
    }

    // Exibe a lista de favoritos usando o mesmo CharacterCard.
    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final character = favorites[index];
        return CharacterCard(character: character);
      },
    );
  }
}
