import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/presentation/providers/character_providers.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/presentation/providers/view_mode_provider.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/presentation/widgets/character_card.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/presentation/widgets/character_grid_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CharacterListPage extends ConsumerWidget {
  final ScrollController scrollController;

  const CharacterListPage({Key? key, required this.scrollController})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charactersAsyncValue = ref.watch(characterListProvider);
    final isGridView = ref.watch(isGridViewProvider);

    return charactersAsyncValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          Center(child: Text('Erro ao carregar os personagens: $error')),
      data: (characters) {
        if (isGridView) {
          return GridView.builder(
            controller: scrollController,
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.7,
            ),
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final character = characters[index];
              return CharacterGridCard(character: character);
            },
          );
        } else {
          return ListView.builder(
            controller: scrollController,
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final character = characters[index];
              return CharacterCard(character: character);
            },
          );
        }
      },
    );
  }
}
