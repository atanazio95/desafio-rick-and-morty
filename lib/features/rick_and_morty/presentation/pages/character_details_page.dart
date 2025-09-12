import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/domain/entities/character.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/presentation/providers/favorites_providers.dart';
import 'package:desafio_rick_and_morty_way_data/features/rick_and_morty/presentation/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// CharacterDetailsPage foi alterada de StatelessWidget para ConsumerWidget
// para que possa acessar o provedor de favoritos do Riverpod.
class CharacterDetailsPage extends ConsumerWidget {
  final Character character;

  const CharacterDetailsPage({Key? key, required this.character})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Usamos o watch para saber se o personagem já está na lista de favoritos.
    // Isso fará com que o widget seja reconstruído quando o estado mudar.
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.any((fav) => fav.id == character.id);

    return Scaffold(
      appBar: CustomAppBar(
        title: character.name,
        isLeading: true,
        actions: [
          IconButton(
            icon: Icon(
              // Altera o ícone com base no estado do personagem.
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: () {
              // Ações de adicionar ou remover favoritos.
              final favoritesNotifier = ref.read(favoritesProvider.notifier);
              if (isFavorite) {
                favoritesNotifier.removeFavorite(character);
              } else {
                favoritesNotifier.addFavorite(character);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: character.id,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  character.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error, size: 100),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Text(
              character.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            _buildInfoRow(
              'Status',
              character.status,
              color: character.status == 'Alive'
                  ? Colors.green
                  : character.status == 'Dead'
                  ? Colors.red
                  : Colors.grey,
            ),
            _buildInfoRow('Espécie', character.species),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 18, color: color ?? Colors.black54),
          ),
        ],
      ),
    );
  }
}
