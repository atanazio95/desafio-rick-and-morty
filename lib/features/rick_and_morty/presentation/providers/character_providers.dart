import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/domain/usecases/get_caracteres.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/character_remote_datasource.dart';
import '../../data/repositories/character_repository_impl.dart';
import '../../domain/repositories/character_repository.dart';
import '../../domain/entities/character.dart';

// Provedor para o cliente HTTP (Dio). É a nossa dependência de baixo nível.
final dioProvider = Provider<Dio>((ref) => Dio());

// Provedor para o remote data source. Ele precisa do dioProvider.
final characterRemoteDataSourceProvider = Provider<CharacterRemoteDataSource>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  return CharacterRemoteDataSourceImpl(dio: dio);
});

// Provedor para a implementação do repositório. Ele precisa do data source.
final characterRepositoryProvider = Provider<CharacterRepository>((ref) {
  final remoteDataSource = ref.watch(characterRemoteDataSourceProvider);
  return CharacterRepositoryImpl(remoteDataSource: remoteDataSource);
});

// Provedor para o caso de uso. Ele precisa do repositório.
final getCharactersUseCaseProvider = Provider<GetCharacters>((ref) {
  final repository = ref.watch(characterRepositoryProvider);
  return GetCharacters(repository);
});

// Provedor assíncrono que busca a lista de personagens usando o caso de uso.
// Este é o provedor que a UI irá "observar" para pegar os dados.
final characterListProvider = FutureProvider<List<Character>>((ref) async {
  final getCharacters = ref.watch(getCharactersUseCaseProvider);
  final result = await getCharacters.call();

  // O Riverpod lida com o estado (loading, data, error)
  return result.fold((failure) => throw failure, (characters) => characters);
});
