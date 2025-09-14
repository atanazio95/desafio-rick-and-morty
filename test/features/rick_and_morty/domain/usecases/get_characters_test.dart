import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:desafio_rick_and_morty_way_data/core/error/failures.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/domain/entities/character.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/domain/usecases/get_characters.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/presentation/providers/character_providers.dart';

import 'get_characters_test.mocks.dart';

@GenerateMocks([GetCharacters, Connectivity])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockGetCharacters mockGetCharacters;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockGetCharacters = MockGetCharacters();
    mockConnectivity = MockConnectivity();
  });

  const tCharactersList = [
    Character(
      id: 1,
      name: 'Rick Sanchez',
      status: 'Alive',
      species: 'Human',
      imageUrl: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
    ),
  ];

  test(
    'deve retornar a lista de personagens quando a carga inicial for bem-sucedida',
    () async {
      when(mockGetCharacters.call(any))
          .thenAnswer((_) async => const Right(tCharactersList));

      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);

      final container = ProviderContainer(
        overrides: [
          getCharactersUseCaseProvider.overrideWithValue(mockGetCharacters),
        ],
      );

      final completer = Completer<void>();
      container.listen(
        characterListProvider,
        (_, next) {
          if (!next.isLoading) {
            completer.complete();
          }
        },
      );
      await completer.future;

      expect(container.read(characterListProvider),
          const AsyncValue.data(tCharactersList));
    },
  );

  test(
    'deve retornar um erro quando a carga inicial falhar',
    () async {
      when(mockGetCharacters.call(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);

      final container = ProviderContainer(
        overrides: [
          getCharactersUseCaseProvider.overrideWithValue(mockGetCharacters),
        ],
      );

      final completer = Completer<void>();
      container.listen(
        characterListProvider,
        (_, next) {
          if (!next.isLoading) {
            completer.complete();
          }
        },
      );
      await completer.future;

      expect(container.read(characterListProvider).hasError, true);
      expect(container.read(characterListProvider).error, isA<ServerFailure>());
    },
  );
}
