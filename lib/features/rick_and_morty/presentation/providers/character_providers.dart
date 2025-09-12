import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/datasources/character_remote_datasource.dart';
import '../../data/repositories/character_repository_impl.dart';
import '../../domain/repositories/character_repository.dart';
import '../../domain/usecases/get_characters.dart';
import '../../domain/entities/character.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final characterRemoteDataSourceProvider = Provider<CharacterRemoteDataSource>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  return CharacterRemoteDataSourceImpl(dio: dio);
});

final characterRepositoryProvider = Provider<CharacterRepository>((ref) {
  final remoteDataSource = ref.watch(characterRemoteDataSourceProvider);
  return CharacterRepositoryImpl(remoteDataSource: remoteDataSource);
});

final getCharactersUseCaseProvider = Provider<GetCharacters>((ref) {
  final repository = ref.watch(characterRepositoryProvider);
  return GetCharacters(repository);
});

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

final characterListProvider =
    StateNotifierProvider<CharacterNotifier, AsyncValue<List<Character>>>((
      ref,
    ) {
      final getCharacters = ref.watch(getCharactersUseCaseProvider);
      return CharacterNotifier(getCharacters: getCharacters);
    });
