import 'package:desafio_rick_and_morty_way_data/core/app_colors.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/character.dart';
import '../pages/character_details_page.dart';

class CharacterCard extends StatelessWidget {
  final Character character;

  const CharacterCard({Key? key, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Usamos o InkWell para tornar o card clicável e adicionar um efeito visual.
    return InkWell(
      onTap: () {
        // Navega para a página de detalhes, passando o objeto Character
        // como um argumento. A navegação é parte da camada de apresentação.
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
              Hero(
                tag: character.id,
                child: ClipRRect(
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
                            ? AppColors.statusAlive
                            : character.status == 'Dead'
                            ? AppColors.statusDead
                            : AppColors.statusUnknown,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
