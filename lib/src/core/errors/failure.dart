abstract class Failure {
  final String message;
  final StackTrace? stackTrace;

  Failure({required this.message, this.stackTrace});
}

class SupaBaseDBFailure extends Failure {
  SupaBaseDBFailure({required super.message, super.stackTrace});
}

class NetworkFailure extends Failure {
  NetworkFailure({required super.message, super.stackTrace});
}
