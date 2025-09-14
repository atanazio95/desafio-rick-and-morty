import 'package:dartz/dartz.dart';
import 'package:desafio_rick_and_morty_way_data/core/error/failures.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/data/datasources/character_remote_datasource.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/data/repositories/character_repository_impl.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/domain/entities/character.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'character_remote_datasource_test.mocks.dart';

// Gerar um mock para a classe CharacterRemoteDataSource
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
      // Configurar o mock para retornar dados JSON com sucesso.
      when(mockRemoteDataSource.getCharacters(any))
          .thenAnswer((_) async => tCharactersJson);

      // Executar o método do repositório.
      final result = await repository.getCharacters(1);

      // Verificar se o resultado é uma lista de entidades.
      expect(result, const Right(tCharactersList));
      verify(mockRemoteDataSource.getCharacters(1)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('deve retornar um ServerFailure quando a chamada for mal-sucedida',
        () async {
      // Configurar o mock para lançar um ServerFailure.
      when(mockRemoteDataSource.getCharacters(any)).thenThrow(ServerFailure());

      // Executar o método do repositório.
      final result = await repository.getCharacters(1);

      // Verificar se o resultado é uma falha.
      expect(result, Left(ServerFailure()));
      verify(mockRemoteDataSource.getCharacters(1)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test(
        'deve retornar um NetworkFailure quando a chamada for mal-sucedida por falta de internet',
        () async {
      // Configurar o mock para lançar um NetworkFailure.
      when(mockRemoteDataSource.getCharacters(any)).thenThrow(NetworkFailure());

      // Executar o método do repositório.
      final result = await repository.getCharacters(1);

      // Verificar se o resultado é uma falha de rede.
      expect(result, Left(NetworkFailure()));
      verify(mockRemoteDataSource.getCharacters(1)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });
}
