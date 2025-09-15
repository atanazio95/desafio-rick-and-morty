import 'package:dartz/dartz.dart';
import 'package:desafio_rick_and_morty_way_data/core/error/failures.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/domain/entities/character.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/domain/repositories/character_repository.dart';

class GetCharacters {
  final CharacterRepository repository;

  GetCharacters(this.repository);

  Future<Either<Failure, List<Character>>> call(int page) async {
    return await repository.getCharacters(page);
  }

  Future<Either<Failure, List<Character>>> searchCharacters(String name) async {
    return await repository.searchCharacters(name);
  }
}
