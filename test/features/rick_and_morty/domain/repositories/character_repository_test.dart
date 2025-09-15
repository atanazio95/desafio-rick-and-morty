import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:desafio_rick_and_morty_way_data/core/error/failures.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/domain/entities/character.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/domain/repositories/character_repository.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/domain/usecases/get_characters.dart';

import 'character_repository_test.mocks.dart';

@GenerateMocks([CharacterRepository])
void main() {
  late GetCharacters usecase;
  late MockCharacterRepository mockCharacterRepository;

  setUp(() {
    mockCharacterRepository = MockCharacterRepository();
    usecase = GetCharacters(mockCharacterRepository);
  });

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

  group('GetCharacters', () {
    test(
      'deve obter a lista de personagens do repositório',
      () async {
        when(mockCharacterRepository.getCharacters(any))
            .thenAnswer((_) async => const Right(tCharactersList));

        final result = await usecase.call(1);

        expect(result, const Right(tCharactersList));
        verify(mockCharacterRepository.getCharacters(1)).called(1);
        verifyNoMoreInteractions(mockCharacterRepository);
      },
    );

    test(
      'deve retornar uma falha do repositório',
      () async {
        when(mockCharacterRepository.getCharacters(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        final result = await usecase.call(1);

        expect(result, Left(ServerFailure()));
        verify(mockCharacterRepository.getCharacters(1)).called(1);
        verifyNoMoreInteractions(mockCharacterRepository);
      },
    );
  });
}
