sealed class ApodFailure implements Exception {
  const ApodFailure(this.message);
  final String message;

  @override
  String toString() => message;
}

final class ApodTimeout extends ApodFailure {
  const ApodTimeout([super.message = 'Request timed out. Please try again.']);
}

final class ApodRateLimited extends ApodFailure {
  const ApodRateLimited([
    super.message = 'API rate limit exceeded. Please wait and try again.',
  ]);
}

final class ApodNotFound extends ApodFailure {
  const ApodNotFound([
    super.message = 'No APOD entry found for the requested date.',
  ]);
}

final class ApodServerError extends ApodFailure {
  const ApodServerError([
    super.message = 'NASA server error. Please try again later.',
  ]);
}

final class ApodNoConnection extends ApodFailure {
  const ApodNoConnection([
    super.message = 'No internet connection. Showing cached data.',
  ]);
}

final class ApodCacheFailure extends ApodFailure {
  const ApodCacheFailure([super.message = 'Failed to read cached data.']);
}

final class ApodUnknownFailure extends ApodFailure {
  const ApodUnknownFailure([
    super.message = 'An unexpected error occurred.',
  ]);
}
