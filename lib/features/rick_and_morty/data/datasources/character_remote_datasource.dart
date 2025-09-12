import 'package:desafio_rick_and_morty_way_data/core/error/failures.dart';
import 'package:dio/dio.dart';

abstract class CharacterRemoteDataSource {
  Future<Map<String, dynamic>> getCharacters(int page);
}

class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  final Dio dio;

  CharacterRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> getCharacters(int page) async {
    try {
      final response = await dio.get(
        'https://rickandmortyapi.com/api/character?page=$page',
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw ServerFailure();
      }
    } on DioException {
      throw ServerFailure();
    }
  }
}
