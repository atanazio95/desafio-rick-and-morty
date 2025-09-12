import 'package:desafio_rick_and_morty_way_data/core/app_colors.dart';
import 'package:flutter/material.dart';

enum BottomBarType { main, details }

class CustomBottomBar extends StatelessWidget {
  final BottomBarType type;
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomBar({
    Key? key,
    required this.type,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> items = [];
    int currentIndex = selectedIndex;

    switch (type) {
      case BottomBarType.main:
        items = const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ];
        break;
      case BottomBarType.details:
        items = const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        ];
        currentIndex = 0;
        break;
    }

    return BottomNavigationBar(
      backgroundColor: AppColors.primaryColor,
      items: items,
      currentIndex: currentIndex,
      selectedItemColor: AppColors.inverseTextColor,
      unselectedItemColor: AppColors.accentColor,
      onTap: onItemTapped,
    );
  }
}
