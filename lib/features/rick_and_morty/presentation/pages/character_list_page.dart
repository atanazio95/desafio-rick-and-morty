import 'package:desafio_rick_and_morty_way_data/core/app_colors.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/presentation/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/character_providers.dart';
import '../widgets/character_card.dart';

// CharacterListPage é um ConsumerStatefulWidget para gerenciar o estado da visualização.
class CharacterListPage extends ConsumerStatefulWidget {
  const CharacterListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CharacterListPage> createState() => _CharacterListPageState();
}

class _CharacterListPageState extends ConsumerState<CharacterListPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(characterListProvider.notifier).loadMoreCharacters();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  @override
  Widget build(BuildContext context) {
    final charactersAsyncValue = ref.watch(characterListProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Personagens',
        actions: [
          IconButton(
            icon: Icon(
              _isGridView ? Icons.view_list : Icons.grid_view,
              color: AppColors.cardColor,
            ),
            onPressed: _toggleView,
          ),
        ],
      ),
      body: charactersAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Erro ao carregar os personagens: $error')),
        data: (characters) {
          if (_isGridView) {
            return GridView.builder(
              controller: _scrollController,
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
                return CharacterCard(character: character);
              },
            );
          } else {
            return ListView.builder(
              controller: _scrollController,
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final character = characters[index];
                return CharacterCard(character: character);
              },
            );
          }
        },
      ),
    );
  }
}
