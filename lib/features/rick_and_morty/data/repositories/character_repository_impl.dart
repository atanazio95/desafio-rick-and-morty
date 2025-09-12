import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/character.dart';
import '../../domain/repositories/character_repository.dart';
import '../datasources/character_remote_datasource.dart';
import '../models/character_model.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource remoteDataSource;

  CharacterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Character>>> getCharacters() async {
    try {
      final List<Map<String, dynamic>> results = await remoteDataSource
          .getCharacters();
      final characters = results
          .map((json) => CharacterModel.fromJson(json).toEntity())
          .toList();
      return Right(characters);
    } on ServerFailure {
      return Left(ServerFailure());
    }
  }
}
