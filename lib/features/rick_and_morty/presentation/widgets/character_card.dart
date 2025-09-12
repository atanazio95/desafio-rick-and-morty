import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/domain/entities/character.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/presentation/pages/character_details_page.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/presentation/providers/favorites_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// CharacterCard foi alterado de StatelessWidget para ConsumerWidget
// para que possa acessar o provedor de favoritos do Riverpod.
class CharacterCard extends ConsumerWidget {
  final Character character;

  const CharacterCard({Key? key, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Usamos o watch para saber se o personagem já está na lista de favoritos.
    // Isso fará com que o widget seja reconstruído quando o estado mudar.
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.any((fav) => fav.id == character.id);

    // Usamos o InkWell para tornar o card clicável e adicionar um efeito visual.
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CharacterDetailsPage(character: character),
          ),
        );
      },
      child: Card(
        // Define o formato do card com cantos arredondados e elevação.
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagem do personagem.
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  character.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  // Placeholder para quando a imagem está carregando ou falha.
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      width: 80,
                      height: 80,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                ),
              ),
              const SizedBox(width: 16.0),
              // Nome e status do personagem.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nome do personagem.
                    Text(
                      character.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    // Status do personagem.
                    Text(
                      'Status: ${character.status}',
                      style: TextStyle(
                        fontSize: 14,
                        color: character.status == 'Alive'
                            ? Colors.green
                            : character.status == 'Dead'
                            ? Colors.red
                            : Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Adiciona o botão de favoritar ao lado do texto.
              IconButton(
                icon: Icon(
                  // Altera o ícone com base no estado do personagem.
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  // Ações de adicionar ou remover favoritos.
                  final favoritesNotifier = ref.read(
                    favoritesProvider.notifier,
                  );
                  if (isFavorite) {
                    favoritesNotifier.removeFavorite(character);
                  } else {
                    favoritesNotifier.addFavorite(character);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
