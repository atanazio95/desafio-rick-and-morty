import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:desafio_rick_and_morty_way_data/core/error/failures.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/data/datasources/character_remote_datasource.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/data/repositories/character_repository_impl.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/domain/entities/character.dart';

import 'character_remote_datasource_test.mocks.dart';

@GenerateMocks([CharacterRemoteDataSource])
void main() {
  late CharacterRepositoryImpl repository;
  late MockCharacterRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockCharacterRemoteDataSource();
    repository =
        CharacterRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  const tCharactersJson = {
    "info": {"count": 2, "pages": 1, "next": null, "prev": null},
    "results": [
      {
        "id": 1,
        "name": "Rick Sanchez",
        "status": "Alive",
        "species": "Human",
        "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
      },
      {
        "id": 2,
        "name": "Morty Smith",
        "status": "Alive",
        "species": "Human",
        "image": "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
      },
    ]
  };

  const tCharactersList = [
    Character(
      id: 1,
      name: 'Rick Sanchez',
      status: 'Alive',
      species: 'Human',
      imageUrl: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
    ),
    Character(
      id: 2,
      name: 'Morty Smith',
      status: 'Alive',
      species: 'Human',
      imageUrl: 'https://rickandmortyapi.com/api/character/avatar/2.jpeg',
    ),
  ];

  group('getCharacters', () {
    test(
      'deve retornar uma lista de Personagens quando a chamada for bem-sucedida',
      () async {
        when(mockRemoteDataSource.getCharacters(any))
            .thenAnswer((_) async => tCharactersJson);
        final result = await repository.getCharacters(1);
        result.fold(
          (failure) =>
              fail('Expected a Right but got a Left with failure: $failure'),
          (characters) {
            expect(listEquals(characters, tCharactersList), true);
          },
        );
        verify(mockRemoteDataSource.getCharacters(1)).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test('deve retornar um ServerFailure quando a chamada for mal-sucedida',
        () async {
      when(mockRemoteDataSource.getCharacters(any)).thenThrow(ServerFailure());
      final result = await repository.getCharacters(1);
      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (characters) => fail('Expected a Left but got a Right'),
      );
      verify(mockRemoteDataSource.getCharacters(1)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test(
      'deve retornar um NetworkFailure quando a chamada for mal-sucedida por falta de internet',
      () async {
        when(mockRemoteDataSource.getCharacters(any))
            .thenThrow(NetworkFailure());
        final result = await repository.getCharacters(1);
        expect(result, isA<Left>());
        result.fold(
          (failure) => expect(failure, isA<NetworkFailure>()),
          (characters) => fail('Expected a Left but got a Right'),
        );
        verify(mockRemoteDataSource.getCharacters(1)).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });
}
