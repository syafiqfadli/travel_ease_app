import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:travel_ease_app/src/core/app/data/models/response_model.dart';
import 'package:travel_ease_app/src/core/errors/failures.dart';

abstract class ApiDataSource {
  Future<Either<Failure, ResponseModel>> get(
    Uri url, {
    Map<String, String>? headers,
  });
  Future<Either<Failure, ResponseModel>> post(
    Uri url, {
    Map<String, String>? headers,
    required Map<String, dynamic> body,
  });
  Future<Either<Failure, ResponseModel>> patch(
    Uri url, {
    Map<String, String>? headers,
    required Map<String, dynamic> body,
  });
  Future<Either<Failure, ResponseModel>> delete(
    Uri url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  });
}

class ApiDataSourceImpl implements ApiDataSource {
  @override
  Future<Either<Failure, ResponseModel>> get(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    try {
      final rawResponse = await http
          .get(
            url,
            headers: headers,
          )
          .timeout(const Duration(seconds: 15));

      final response = ResponseModel.fromJson(jsonDecode(rawResponse.body));

      return Right(response);
    } on TimeoutException catch (error) {
      return Left(ServerFailure(message: error.toString()));
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, ResponseModel>> post(
    Uri url, {
    Map<String, String>? headers,
    required Map<String, dynamic> body,
  }) async {
    try {
      final rawResponse = await http
          .post(
            url,
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      final response = ResponseModel.fromJson(jsonDecode(rawResponse.body));

      return Right(response);
    } on TimeoutException catch (error) {
      return Left(ServerFailure(message: error.toString()));
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, ResponseModel>> patch(
    Uri url, {
    Map<String, String>? headers,
    required Map<String, dynamic> body,
  }) async {
    try {
      final rawResponse = await http
          .patch(
            url,
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      final response = ResponseModel.fromJson(jsonDecode(rawResponse.body));

      return Right(response);
    } on TimeoutException catch (error) {
      return Left(ServerFailure(message: error.toString()));
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, ResponseModel>> delete(
    Uri url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final rawResponse = await http
          .delete(
            url,
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      final response = ResponseModel.fromJson(jsonDecode(rawResponse.body));

      return Right(response);
    } on TimeoutException catch (error) {
      return Left(ServerFailure(message: error.toString()));
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }
}
