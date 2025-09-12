import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';

abstract class CharacterRemoteDataSource {
  // O método agora retorna a resposta completa da API, incluindo
  // as informações de paginação.
  Future<Map<String, dynamic>> getCharacters(int page);
}

class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  final Dio dio;

  CharacterRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> getCharacters(int page) async {
    try {
      // Constrói a URL com o número da página.
      final response = await dio.get(
        'https://rickandmortyapi.com/api/character?page=$page',
      );

      if (response.statusCode == 200) {
        // Retorna a resposta completa, incluindo 'info' e 'results'.
        return response.data;
      } else {
        throw ServerFailure();
      }
    } on DioException {
      // Dio lança DioException para erros de rede, timeout, etc.
      throw ServerFailure();
    }
  }
}
