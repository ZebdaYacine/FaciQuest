class ApiException implements Exception {
  ApiException({required this.message});
  final String message;

  @override
  String toString() {
    return 'ApiException: $message';
  }
}

class BadRequestException extends ApiException {
  BadRequestException({required super.message});
}

class InternalServerErrorException extends ApiException {
  InternalServerErrorException({
    required super.message,
  });
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({required super.message});
}

class ForbiddenException extends ApiException {
  ForbiddenException({required super.message});
}

class NotFoundException extends ApiException {
  NotFoundException({required super.message});
}

class NoInternetException extends ApiException {
  NoInternetException({required super.message});
}

class ConsecutiveRequestException extends ApiException {
  ConsecutiveRequestException({required super.message});
}

class MaxFailureCheckPinException extends ApiException {
  MaxFailureCheckPinException({required super.message});
}

class CodePinNotValidException extends ApiException {
  CodePinNotValidException({required super.message});
}

class MaxFavAddressException extends ApiException {
  MaxFavAddressException({required super.message});
}
