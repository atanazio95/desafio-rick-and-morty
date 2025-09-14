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

      // Extrai a lista de resultados e converte cada um para uma entidade.
      final List<Map<String, dynamic>> results =
          List<Map<String, dynamic>>.from(response['results']);
      final characters = results
          .map((json) => CharacterModel.fromJson(json).toEntity())
          .toList();

      return Right(characters);
    } on NetworkFailure {
      // Agora, o repositório sabe quando o erro é de rede.
      return Left(NetworkFailure());
    } on ServerFailure {
      // Ou quando é um erro de servidor.
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Character>>> searchCharacters(String name) async {
    try {
      final Map<String, dynamic> response =
          await remoteDataSource.searchCharacters(name: name);

      // Extrai a lista de resultados e converte cada um para uma entidade.
      final List<Map<String, dynamic>> results =
          List<Map<String, dynamic>>.from(response['results']);
      final characters = results
          .map((json) => CharacterModel.fromJson(json).toEntity())
          .toList();

      return Right(characters);
    } on NetworkFailure {
      // Agora, o repositório sabe quando o erro é de rede.
      return Left(NetworkFailure());
    } on ServerFailure {
      // Ou quando é um erro de servidor.
      return Left(ServerFailure());
    }
  }
}
