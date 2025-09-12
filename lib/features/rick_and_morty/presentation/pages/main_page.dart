import 'package:desafio_rick_and_morty_way_data/core/app_colors.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/presentation/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'character_list_page.dart';
import 'favorites_page.dart';
import '../providers/character_providers.dart';

class MainAppPage extends ConsumerStatefulWidget {
  const MainAppPage({Key? key}) : super(key: key);

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
    // A lista de páginas para navegação.
    _pages = [
      CharacterListPage(scrollController: _scrollController),
      const FavoritesPage(),
    ];
    // Adiciona o listener para a paginação, que agora vive aqui.
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Verifica se o usuário chegou ao final da lista e está na página inicial.
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(characterListProvider.notifier).loadMoreCharacters();
    }
  }

  @override
  void dispose() {
    // É importante descartar o controller para evitar vazamento de memória.
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
    return Scaffold(
      appBar: CustomAppBar(
        title: _selectedIndex == 0 ? 'Personagens' : 'Favoritos',
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.primaryColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.inverseTextColor,
        unselectedItemColor: AppColors.accentColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
