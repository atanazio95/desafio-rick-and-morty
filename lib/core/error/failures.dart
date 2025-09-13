import 'package:flutter/foundation.dart';

@immutable
abstract class Failure {
  @override
  String toString() => runtimeType.toString();
}

class NetworkFailure extends Failure {}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
