import 'package:desafio_rick_and_morty_way_data/core/custom_bottombar.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/presentation/providers/character_providers.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/presentation/providers/view_mode_provider.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/presentation/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'character_list_page.dart';
import 'favorites_page.dart';

class MainAppPage extends ConsumerStatefulWidget {
  final bool hasInternet;

  const MainAppPage({Key? key, required this.hasInternet}) : super(key: key);

  @override
  ConsumerState<MainAppPage> createState() => _MainAppPageState();
}

class _MainAppPageState extends ConsumerState<MainAppPage> {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      CharacterListPage(
        scrollController: _scrollController,
        hasInternet: widget.hasInternet,
      ),
      const FavoritesPage(),
    ];
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isGridView = ref.watch(isGridViewProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: _selectedIndex == 0 ? 'Rick and Morty Characters' : 'Favoritos',
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () => ref.read(isGridViewProvider.notifier).toggleView(),
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: CustomBottomBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
