abstract class Exception {
  final String message;
  final StackTrace? stackTrace;

  Exception({required this.message, this.stackTrace});
}

class SupaBaseDBException extends Exception {
  SupaBaseDBException({required super.message, super.stackTrace});
}
