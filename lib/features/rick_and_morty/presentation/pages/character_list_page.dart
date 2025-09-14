import 'package:desafio_rick_and_morty_way_data/core/error/failures.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/presentation/providers/character_providers.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/presentation/providers/view_mode_provider.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/presentation/widgets/character_card.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/presentation/widgets/character_grid_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CharacterListPage extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  final bool hasInternet;

  const CharacterListPage({
    Key? key,
    required this.scrollController,
    required this.hasInternet,
  }) : super(key: key);

  @override
  ConsumerState<CharacterListPage> createState() => _CharacterListPageState();
}

class _CharacterListPageState extends ConsumerState<CharacterListPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_isSearching &&
        widget.scrollController.position.pixels ==
            widget.scrollController.position.maxScrollExtent) {
      ref.read(characterListProvider.notifier).loadMoreCharacters();
    }
  }

  @override
  void dispose() {
    widget.scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.hasInternet) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/rick_sad.png', width: 100, height: 100),
              const SizedBox(height: 20),
              const Text(
                'Sem conexão com a internet',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Verifique sua conexão ou visualize seus personagens favoritos salvos localmente.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      );
    }

    final isGridView = ref.watch(isGridViewProvider);
    final charactersAsyncValue = ref.watch(_isSearching
        ? characterSearchProvider(_searchController.text)
        : characterListProvider);

    return Scaffold(
      body: Column(
        children: [
          // Campo de busca
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (query) {
                      setState(() {
                        _isSearching = query.isNotEmpty;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Buscar personagem...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: const Icon(Icons.search),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Lista de personagens
          Expanded(
            child: charactersAsyncValue.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) {
                if (error is NetworkFailure) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/rick_sad.png',
                              width: 100, height: 100),
                          const SizedBox(height: 20),
                          const Text(
                            'Sem conexão com a internet',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Verifique sua conexão ou visualize seus personagens favoritos salvos localmente.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(child: Text('Erro: $error'));
                }
              },
              data: (characters) {
                if (isGridView) {
                  return GridView.builder(
                    controller: widget.scrollController,
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                    controller: widget.scrollController,
                    itemCount: characters.length,
                    itemBuilder: (context, index) {
                      final character = characters[index];
                      return CharacterCard(character: character);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
