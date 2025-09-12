import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/datasources/character_remote_datasource.dart';
import '../../data/repositories/character_repository_impl.dart';
import '../../domain/repositories/character_repository.dart';
import '../../domain/usecases/get_characters.dart';
import '../../domain/entities/character.dart';
import '../../../../core/error/failures.dart';

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

// Notificador de estado para gerenciar a lista de personagens de forma paginada.
// Ele mantém a lista, a página atual e o estado de carregamento.
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
    state = const AsyncValue.loading();
    final result = await getCharacters(_currentPage);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (characters) => AsyncValue.data(characters),
    );
  }

  Future<void> loadMoreCharacters() async {
    if (_isLoadingMore || !_hasMoreData) return;

    _isLoadingMore = true;
    _currentPage++;
    final result = await getCharacters(_currentPage);

    result.fold(
      (failure) {
        // Lidar com o erro
        _isLoadingMore = false;
      },
      (newCharacters) {
        if (newCharacters.isEmpty) {
          _hasMoreData = false;
        } else {
          state.whenData((currentCharacters) {
            state = AsyncValue.data(
              List.from(currentCharacters)..addAll(newCharacters),
            );
          });
        }
        _isLoadingMore = false;
      },
    );
  }
}

// Provedor do notificador de estado.
final characterListProvider =
    StateNotifierProvider<CharacterNotifier, AsyncValue<List<Character>>>((
      ref,
    ) {
      final getCharacters = ref.watch(getCharactersUseCaseProvider);
      return CharacterNotifier(getCharacters: getCharacters);
    });
