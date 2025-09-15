import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:desafio_rick_and_morty_way_data/core/app_colors.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/domain/entities/character.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/presentation/pages/character_details_page.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final hasInternet = await _checkConnectivity();

  runApp(
    ProviderScope(
      child: MyApp(hasInternet: hasInternet),
    ),
  );
}

Future<bool> _checkConnectivity() async {
  final connectivityResult = await (Connectivity().checkConnectivity());
  return connectivityResult.contains(ConnectivityResult.mobile) ||
      connectivityResult.contains(ConnectivityResult.wifi);
}

class MyApp extends StatelessWidget {
  final bool hasInternet;

  const MyApp({Key? key, required this.hasInternet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty App',
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryColor,
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => MainAppPage(
                hasInternet: hasInternet,
              ),
            );
          case '/details':
            final character = settings.arguments as Character;
            return MaterialPageRoute(
              builder: (context) => CharacterDetailsPage(character: character),
            );
          case '/favorites':
            return MaterialPageRoute(
              builder: (context) => MainAppPage(
                hasInternet: hasInternet,
              ),
            );
          default:
            return MaterialPageRoute(
                builder: (context) => const Text('Rota não encontrada'));
        }
      },
    );
  }
}
