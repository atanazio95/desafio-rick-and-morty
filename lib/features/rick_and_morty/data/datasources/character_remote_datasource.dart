import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';

abstract class CharacterRemoteDataSource {
  Future<List<Map<String, dynamic>>> getCharacters();
}

class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  final Dio dio;

  CharacterRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<Map<String, dynamic>>> getCharacters() async {
    try {
      final response = await dio.get(
        'https://rickandmortyapi.com/api/character',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = response.data;
        return List<Map<String, dynamic>>.from(json['results']);
      } else {
        throw ServerFailure();
      }
    } on DioException {
      // Dio lança DioException para erros de rede, timeout, etc.
      // Aqui, tratamos como uma falha no servidor.
      throw ServerFailure();
    }
  }
}
