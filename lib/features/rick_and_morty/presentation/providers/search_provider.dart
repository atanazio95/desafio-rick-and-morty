import 'package:flutter_riverpod/legacy.dart';

// Classe que representa o estado da busca.
class SearchQuery {
  final String? name;
  final String? status;
  final String? species;

  SearchQuery({
    this.name,
    this.status,
    this.species,
  });

  // Cria uma nova instância com os campos atualizados.
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

// Notificador de estado para gerenciar o texto de busca e os filtros.
class SearchNotifier extends StateNotifier<SearchQuery> {
  SearchNotifier() : super(SearchQuery());

  // Altera o texto de busca.
  void setSearchQuery(String query) {
    state = state.copyWith(name: query);
  }

  // Altera o status do filtro.
  void setStatus(String? status) {
    state = state.copyWith(status: status);
  }

  // Altera a espécie do filtro.
  void setSpecies(String? species) {
    state = state.copyWith(species: species);
  }
}

final searchQueryProvider =
    StateNotifierProvider<SearchNotifier, SearchQuery>((ref) {
  return SearchNotifier();
});
