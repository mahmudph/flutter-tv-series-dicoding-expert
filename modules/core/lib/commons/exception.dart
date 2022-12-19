class ServerException implements Exception {
  final String message;

  ServerException({
    this.message = 'No internet connection available',
  });
}

class DatabaseException implements Exception {
  final String message;

  DatabaseException(this.message);
}
