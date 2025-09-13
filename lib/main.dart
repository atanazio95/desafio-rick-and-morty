import 'package:desafio_rick_and_morty_way_data/core/app_colors.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() async {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty App',
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(backgroundColor: AppColors.primaryColor),
      ),
      home: FutureBuilder<List<ConnectivityResult>>(
        future: Connectivity().checkConnectivity(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final hasInternet =
              snapshot.data!.contains(ConnectivityResult.mobile) ||
              snapshot.data!.contains(ConnectivityResult.wifi);

          return MainAppPage(hasInternet: hasInternet);
        },
      ),
    );
  }
}
