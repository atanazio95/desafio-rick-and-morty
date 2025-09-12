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
  Future<Either<Failure, List<Character>>> getCharacters(int page) async {
    try {
      final Map<String, dynamic> response = await remoteDataSource
          .getCharacters(page);
      final List<Map<String, dynamic>> results =
          List<Map<String, dynamic>>.from(response['results']);
      final characters = results
          .map((json) => CharacterModel.fromJson(json).toEntity())
          .toList();

      return Right(characters);
    } on ServerFailure {
      return Left(ServerFailure());
    }
  }
}
