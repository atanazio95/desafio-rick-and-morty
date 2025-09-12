import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/character.dart';
import '../repositories/character_repository.dart';

class GetCharacters {
  final CharacterRepository repository;

  // O caso de uso depende do repositório, mas não da sua implementação.
  GetCharacters(this.repository);

  // O método call permite que a classe seja executada como uma função.
  Future<Either<Failure, List<Character>>> call() async {
    return await repository.getCharacters();
  }
}
