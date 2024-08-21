import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ilia_flutter_challenge/common/entities/failures.dart';

class ApiClient {
  final String baseUrl;
  final String apiKey;

  ApiClient({
    required this.baseUrl,
    required this.apiKey,
  });

  Future<Either<FetchFailure, dynamic>> fetch(String path) async {
    try {
      var headers = {'Authorization': 'Bearer $apiKey'};
      var dio = Dio();
      var url = '$baseUrl$path';
      var response = await dio.request(url,
          options: Options(
            method: 'GET',
            headers: headers,
          ),
          queryParameters: {
            'language': 'pt-BR',
          });

      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        return Left(
          FetchFailure.serverError(response.statusCode ?? -1,
              response.statusMessage ?? 'Erro desconhecido'),
        );
      }
    } catch (e) {
      return Left(FetchFailure.networkError(e.toString()));
    }
  }
}
