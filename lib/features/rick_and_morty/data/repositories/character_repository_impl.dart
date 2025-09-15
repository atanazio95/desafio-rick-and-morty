import 'package:dartz/dartz.dart';
import 'package:desafio_rick_and_morty_way_data/core/error/failures.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/data/datasources/character_remote_datasource.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/data/models/character_model.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/domain/entities/character.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/domain/repositories/character_repository.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource remoteDataSource;

  CharacterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Character>>> getCharacters(int page) async {
    try {
      final Map<String, dynamic> response =
          await remoteDataSource.getCharacters(page);

      final List<Map<String, dynamic>> results =
          List<Map<String, dynamic>>.from(response['results']);
      final characters = results
          .map((json) => CharacterModel.fromJson(json).toEntity())
          .toList();

      return Right(characters);
    } on NetworkFailure {
      return Left(NetworkFailure());
    } on ServerFailure {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Character>>> searchCharacters(String name) async {
    try {
      final Map<String, dynamic> response =
          await remoteDataSource.searchCharacters(name: name);

      final List<Map<String, dynamic>> results =
          List<Map<String, dynamic>>.from(response['results']);
      final characters = results
          .map((json) => CharacterModel.fromJson(json).toEntity())
          .toList();

      return Right(characters);
    } on NetworkFailure {
      return Left(NetworkFailure());
    } on ServerFailure {
      return Left(ServerFailure());
    }
  }
}
