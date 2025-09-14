import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/data/datasources/character_remote_datasource.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/data/repositories/character_repository_impl.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/domain/entities/character.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/domain/repositories/character_repository.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/domain/usecases/get_characters.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provedor para o cliente HTTP (Dio).
final dioProvider = Provider<Dio>((ref) => Dio());

// Provedor para o remote data source.
final characterRemoteDataSourceProvider =
    Provider<CharacterRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return CharacterRemoteDataSourceImpl(dio: dio);
});

// Provedor para a implementação do repositório.
final characterRepositoryProvider = Provider<CharacterRepository>((ref) {
  final remoteDataSource = ref.watch(characterRemoteDataSourceProvider);
  return CharacterRepositoryImpl(remoteDataSource: remoteDataSource);
});

// Provedor para o caso de uso.
final getCharactersUseCaseProvider = Provider<GetCharacters>((ref) {
  final repository = ref.watch(characterRepositoryProvider);
  return GetCharacters(repository);
});

// NOVO: Provedor para a busca de personagens.
final characterSearchProvider = FutureProvider.autoDispose
    .family<List<Character>, String>((ref, query) async {
  if (query.isEmpty) {
    return [];
  }
  final getCharacters = ref.watch(getCharactersUseCaseProvider);
  final result = await getCharacters.searchCharacters(query);

  return result.fold(
    (failure) => throw failure,
    (characters) => characters,
  );
});

final characterListProvider =
    StateNotifierProvider<CharacterNotifier, AsyncValue<List<Character>>>(
        (ref) {
  final getCharacters = ref.watch(getCharactersUseCaseProvider);
  return CharacterNotifier(getCharacters: getCharacters);
});

// Notificador de estado para gerenciar a lista de personagens de forma paginada.
class CharacterNotifier extends StateNotifier<AsyncValue<List<Character>>> {
  final GetCharacters getCharacters;
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;

  CharacterNotifier({required this.getCharacters})
      : super(const AsyncValue.loading()) {
    _fetchCharacters();
  }

  Future<void> _fetchCharacters() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      final result = await getCharacters(_currentPage);
      state = result.fold(
        (failure) => AsyncValue.error(failure, StackTrace.current),
        (characters) => AsyncValue.data(characters),
      );
    } else {
      state = AsyncValue.error(NetworkFailure(), StackTrace.current);
    }
  }

  Future<void> loadMoreCharacters() async {
    if (_isLoadingMore || !_hasMoreData) return;

    _isLoadingMore = true;
    _currentPage++;
    final result = await getCharacters(_currentPage);

    result.fold(
      (failure) {
        _isLoadingMore = false;
      },
      (newCharacters) {
        if (newCharacters.isEmpty) {
          _hasMoreData = false;
        } else {
          state.whenData((currentCharacters) {
            state = AsyncValue.data(
                List.from(currentCharacters)..addAll(newCharacters));
          });
        }
        _isLoadingMore = false;
      },
    );
  }
}

final characterListProvider =
    StateNotifierProvider<CharacterNotifier, AsyncValue<List<Character>>>((
  ref,
) {
  final getCharacters = ref.watch(getCharactersUseCaseProvider);
  return CharacterNotifier(getCharacters: getCharacters);
});
