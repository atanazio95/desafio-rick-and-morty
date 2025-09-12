import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/character_providers.dart';
import '../widgets/character_card.dart';

// CharacterListPage agora é um ConsumerStatefulWidget para gerenciar o ScrollController.
class CharacterListPage extends ConsumerStatefulWidget {
  const CharacterListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CharacterListPage> createState() => _CharacterListPageState();
}

class _CharacterListPageState extends ConsumerState<CharacterListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Adiciona um listener para detectar a rolagem.
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Verifica se o usuário chegou ao final da lista.
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Chama a função para carregar mais itens.
      ref.read(characterListProvider.notifier).loadMoreCharacters();
    }
  }

  @override
  void dispose() {
    // É importante descartar o controller para evitar vazamento de memória.
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Usamos o ref.watch para observar o estado do nosso provedor.
    final charactersAsyncValue = ref.watch(characterListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Personagens de Rick and Morty',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF208D45),
      ),
      body: charactersAsyncValue.when(
        // Estado de carregamento: exibe um indicador de progresso no centro.
        loading: () => const Center(child: CircularProgressIndicator()),
        // Estado de erro: exibe uma mensagem de erro.
        error: (error, stackTrace) =>
            Center(child: Text('Erro ao carregar os personagens: $error')),
        // Estado de sucesso: exibe a lista de personagens.
        data: (characters) {
          return ListView.builder(
            controller: _scrollController,
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final character = characters[index];
              return CharacterCard(character: character);
            },
          );
        },
      ),
    );
  }
}
