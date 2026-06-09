// lib/core/error/failures.dart

abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String msg = 'No internet connection.']) : super(msg);
}

class ServerFailure extends Failure {
  const ServerFailure([String msg = 'Server error. Please try again.']) : super(msg);
}

class CacheFailure extends Failure {
  const CacheFailure([String msg = 'No cached data available.']) : super(msg);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([String msg = 'Hero not found.']) : super(msg);
}
