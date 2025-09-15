import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchQuery {
  final String? name;
  final String? status;
  final String? species;

  SearchQuery({
    this.name,
    this.status,
    this.species,
  });

  SearchQuery copyWith({
    String? name,
    String? status,
    String? species,
  }) {
    return SearchQuery(
      name: name ?? this.name,
      status: status ?? this.status,
      species: species ?? this.species,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchQuery> {
  SearchNotifier() : super(SearchQuery());

  void setSearchQuery(String query) {
    state = state.copyWith(name: query);
  }

  void setStatus(String? status) {
    state = state.copyWith(status: status);
  }

  void setSpecies(String? species) {
    state = state.copyWith(species: species);
  }
}

final searchQueryProvider =
    StateNotifierProvider<SearchNotifier, SearchQuery>((ref) {
  return SearchNotifier();
});
