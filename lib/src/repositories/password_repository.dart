import 'package:dartz/dartz.dart';
import 'package:pass_key/src/config/routes/app_router.dart';
import 'package:pass_key/src/core/constants/strings.dart';
import 'package:pass_key/src/core/errors/exceptions.dart';
import 'package:pass_key/src/core/errors/failure.dart';
import 'package:pass_key/src/core/services/network_service.dart';
import 'package:pass_key/src/core/utils/extensions.dart';
import 'package:pass_key/src/data/remote/password_remote_data_source.dart';
import 'package:pass_key/src/models/password_model.dart';

abstract class PasswordRepository {
  Future<Either<Failure, PasswordModel>> callAddPassword({required PasswordModel passwordModel});
  Future<Either<Failure, PasswordModel>> callUpdatePassword({required PasswordModel passwordModel});
  Future<Either<Failure, String>> callDeletePassword({required String id});
  Future<Either<Failure, List<PasswordModel>>> callGetAllPasswords({
    required String query,
    required String uid,
  });
  Future<Either<Failure, List<PasswordModel>>> callGetFavoritePasswords({
    required String query,
    required String uid,
  });
  Future<Either<Failure, List<PasswordModel>>> callGetAllPasswordsByCategory({
    required String category,
    required String query,
    required String uid,
  });
}

class PasswordRepositoryImpl implements PasswordRepository {
  final PasswordRemoteDataSource _passwordRemoteDataSource;
  final NetworkService _networkService;

  PasswordRepositoryImpl({
    required PasswordRemoteDataSource passwordRemoteDataSource,
    required NetworkService networkService,
  }) : _passwordRemoteDataSource = passwordRemoteDataSource,
       _networkService = networkService;

  @override
  Future<Either<Failure, PasswordModel>> callAddPassword({required PasswordModel passwordModel}) async {
    try {
      if (!await (_networkService.isConnected())) {
        return Left(
          NetworkFailure(
            message:
                rootNavigatorKey.currentContext != null
                    ? rootNavigatorKey.currentContext!.loc.noInternetConnection
                    : noInternetConnection,
          ),
        );
      }

      final response = await _passwordRemoteDataSource.addPassword(passwordModel);

      return Right(response);
    } on SupaBaseDBException catch (e) {
      return Left(
        SupaBaseDBFailure(
          message: e.message,
          stackTrace: e.stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, PasswordModel>> callUpdatePassword({required PasswordModel passwordModel}) async {
    try {
      if (!await (_networkService.isConnected())) {
        return Left(
          NetworkFailure(
            message:
                rootNavigatorKey.currentContext != null
                    ? rootNavigatorKey.currentContext!.loc.noInternetConnection
                    : noInternetConnection,
          ),
        );
      }

      final response = await _passwordRemoteDataSource.updatePassword(passwordModel);

      return Right(response);
    } on SupaBaseDBException catch (e) {
      return Left(
        SupaBaseDBFailure(
          message: e.message,
          stackTrace: e.stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, String>> callDeletePassword({required String id}) async {
    try {
      if (!await (_networkService.isConnected())) {
        return Left(
          NetworkFailure(
            message:
                rootNavigatorKey.currentContext != null
                    ? rootNavigatorKey.currentContext!.loc.noInternetConnection
                    : noInternetConnection,
          ),
        );
      }

      final response = await _passwordRemoteDataSource.deletePassword(id);

      return Right(response);
    } on SupaBaseDBException catch (e) {
      return Left(
        SupaBaseDBFailure(
          message: e.message,
          stackTrace: e.stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<PasswordModel>>> callGetAllPasswords({
    required String query,
    required String uid,
  }) async {
    try {
      if (!await (_networkService.isConnected())) {
        return Left(
          NetworkFailure(
            message:
                rootNavigatorKey.currentContext != null
                    ? rootNavigatorKey.currentContext!.loc.noInternetConnection
                    : noInternetConnection,
          ),
        );
      }

      final response = await _passwordRemoteDataSource.getAllPasswords(query, uid);

      return Right(response);
    } on SupaBaseDBException catch (e) {
      return Left(
        SupaBaseDBFailure(
          message: e.message,
          stackTrace: e.stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<PasswordModel>>> callGetFavoritePasswords({
    required String query,
    required String uid,
  }) async {
    try {
      if (!await (_networkService.isConnected())) {
        return Left(
          NetworkFailure(
            message:
                rootNavigatorKey.currentContext != null
                    ? rootNavigatorKey.currentContext!.loc.noInternetConnection
                    : noInternetConnection,
          ),
        );
      }

      final response = await _passwordRemoteDataSource.getFavoritePasswords(query, uid);

      return Right(response);
    } on SupaBaseDBException catch (e) {
      return Left(
        SupaBaseDBFailure(
          message: e.message,
          stackTrace: e.stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<PasswordModel>>> callGetAllPasswordsByCategory({
    required String category,
    required String query,
    required String uid,
  }) async {
    try {
      if (!await (_networkService.isConnected())) {
        return Left(
          NetworkFailure(
            message:
                rootNavigatorKey.currentContext != null
                    ? rootNavigatorKey.currentContext!.loc.noInternetConnection
                    : noInternetConnection,
          ),
        );
      }

      final response = await _passwordRemoteDataSource.getAllPasswordsByCategory(category, query, uid);

      return Right(response);
    } on SupaBaseDBException catch (e) {
      return Left(
        SupaBaseDBFailure(
          message: e.message,
          stackTrace: e.stackTrace,
        ),
      );
    }
  }
}
