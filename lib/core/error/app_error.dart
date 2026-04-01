sealed class AppError implements Exception {
  final String message;
  const AppError(this.message);

  @override
  String toString() => message;
}

class NetworkError extends AppError {
  const NetworkError([super.message = 'Network request failed']);
}

class AuthError extends AppError {
  const AuthError([super.message = 'Authentication failed']);
}

class StorageError extends AppError {
  const StorageError([super.message = 'Local storage error']);
}

class ApiError extends AppError {
  final int? statusCode;
  const ApiError(super.message, {this.statusCode});
}

class ParseError extends AppError {
  const ParseError([super.message = 'Failed to parse response']);
}

class NotFoundError extends AppError {
  const NotFoundError([super.message = 'Resource not found']);
}
