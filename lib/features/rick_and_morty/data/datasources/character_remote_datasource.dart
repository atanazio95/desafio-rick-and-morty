import 'package:desafio_rick_and_morty_way_data/core/error/failures.dart';
import 'package:dio/dio.dart';

abstract class CharacterRemoteDataSource {
  Future<Map<String, dynamic>> getCharacters(int page);
  Future<Map<String, dynamic>> searchCharacters({
    required String name,
    String? status,
    String? species,
    String? type,
    String? gender,
  });
}

class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  final Dio dio;

  CharacterRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> getCharacters(int page) async {
    try {
      final response =
          await dio.get('https://rickandmortyapi.com/api/character?page=$page');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw ServerFailure();
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown ||
          e.type == DioExceptionType.connectionError) {
        throw NetworkFailure();
      } else {
        throw ServerFailure();
      }
    }
  }

  @override
  Future<Map<String, dynamic>> searchCharacters({
    required String name,
    String? status,
    String? species,
    String? type,
    String? gender,
  }) async {
    try {
      // Começa a construir a URL com os parâmetros opcionais.
      final Map<String, dynamic> queryParameters = {
        'name': name,
        if (status != null && status.isNotEmpty) 'status': status,
        if (species != null && species.isNotEmpty) 'species': species,
        if (type != null && type.isNotEmpty) 'type': type,
        if (gender != null && gender.isNotEmpty) 'gender': gender,
      };

      final response = await dio.get(
        'https://rickandmortyapi.com/api/character',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw ServerFailure();
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.unknown ||
          e.type == DioExceptionType.connectionError) {
        throw NetworkFailure();
      } else {
        throw ServerFailure();
      }
    }
  }
}
