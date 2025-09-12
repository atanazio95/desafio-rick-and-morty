import 'package:flutter/material.dart';

import '../../domain/entities/character.dart';

class CharacterDetailsPage extends StatelessWidget {
  final Character character;

  const CharacterDetailsPage({Key? key, required this.character})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
        backgroundColor: Colors.teal[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagem do personagem com a animação Hero.
            Hero(
              tag: character.id,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  character.imageUrl,
                  fit: BoxFit.cover,
                  // Placeholder para quando a imagem está carregando.
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
            // Nome do personagem
            Text(
              character.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            // Status do personagem
            _buildInfoRow(
              'Status',
              character.status,
              color: character.status == 'Alive'
                  ? Colors.green
                  : character.status == 'Dead'
                  ? Colors.red
                  : Colors.grey,
            ),
            // Espécie do personagem
            _buildInfoRow('Espécie', character.species),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para exibir informações em uma linha.
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
