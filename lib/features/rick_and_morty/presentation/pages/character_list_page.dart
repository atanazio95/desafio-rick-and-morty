import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/character_providers.dart';
import '../widgets/character_card.dart';

// CharacterListPage agora é um ConsumerWidget que recebe o ScrollController.
class CharacterListPage extends ConsumerWidget {
  final ScrollController scrollController;

  const CharacterListPage({Key? key, required this.scrollController})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Usamos o ref.watch para observar o estado do nosso provedor assíncrono.
    final charactersAsyncValue = ref.watch(characterListProvider);

    return charactersAsyncValue.when(
      // Estado de carregamento: exibe um indicador de progresso no centro.
      loading: () => const Center(child: CircularProgressIndicator()),
      // Estado de erro: exibe uma mensagem de erro.
      error: (error, stackTrace) =>
          Center(child: Text('Erro ao carregar os personagens: $error')),
      // Estado de sucesso: exibe a lista de personagens.
      data: (characters) {
        return ListView.builder(
          controller: scrollController,
          itemCount: characters.length,
          itemBuilder: (context, index) {
            final character = characters[index];
            return CharacterCard(character: character);
          },
        );
      },
    );
  }
}
