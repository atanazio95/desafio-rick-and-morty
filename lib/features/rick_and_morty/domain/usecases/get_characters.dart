import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/character.dart';
import '../repositories/character_repository.dart';

class GetCharacters {
  final CharacterRepository repository;

  // O caso de uso depende do repositório (abstração), não da sua implementação.
  GetCharacters(this.repository);

  // O método `call` permite que a classe seja chamada como uma função.
  // Agora ele aceita um parâmetro de página.
  Future<Either<Failure, List<Character>>> call(int page) async {
    return await repository.getCharacters(page);
  }
}
