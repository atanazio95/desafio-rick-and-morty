import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/presentation/pages/character_list_page.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MainAppPage(),
    );
  }
}
