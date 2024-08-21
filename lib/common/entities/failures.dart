abstract class Failure {
  final String message;
  const Failure(this.message);
}

class FetchFailure extends Failure {
  final String? reasonPhrase;
  final int? statusCode;

  const FetchFailure({
    required String message,
    this.reasonPhrase,
    this.statusCode,
  }) : super(message);

  factory FetchFailure.networkError(String message) {
    return FetchFailure(
      message: message,
    );
  }

  factory FetchFailure.serverError(int statusCode, String reasonPhrase) {
    return FetchFailure(
      message: 'Erro do servidor',
      statusCode: statusCode,
      reasonPhrase: reasonPhrase,
    );
  }

  factory FetchFailure.parsingError(String message) {
    return FetchFailure(
      message: message,
    );
  }
}
