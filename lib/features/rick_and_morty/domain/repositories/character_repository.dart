import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/character.dart';

// Este é o contrato para o repositório.
// Ele define quais funcionalidades a camada de dados deve oferecer para o domínio.
abstract class CharacterRepository {
  // O método getCharacters deve retornar um Future que contém
  // um Either, que pode ser uma Falha (Failure) em caso de erro,
  // ou uma lista de Personagens (List<Character>) em caso de sucesso.
  Future<Either<Failure, List<Character>>> getCharacters();
}
