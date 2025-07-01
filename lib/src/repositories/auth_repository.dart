// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:pass_key/src/config/routes/app_router.dart';
import 'package:pass_key/src/core/constants/strings.dart';

import 'package:pass_key/src/core/errors/exceptions.dart';
import 'package:pass_key/src/core/errors/failure.dart';
import 'package:pass_key/src/core/services/network_service.dart';
import 'package:pass_key/src/core/utils/extensions.dart';
import 'package:pass_key/src/data/remote/auth_remote_data_source.dart';
import 'package:pass_key/src/models/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> callSignUpWithEmailAndPassword({required String email, required String password});
  Future<Either<Failure, UserModel>> callSignInWithEmailAndPassword({required String email, required String password});
  Future<Either<Failure, UserModel?>> callGetCurrentUserData();
  Future<Either<Failure, void>> callLogOutUser();
  Future<Either<Failure, void>> callUpdateUserPassword({required String password});
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  final NetworkService _networkService;

  AuthRepositoryImpl({required AuthRemoteDataSource authRemoteDataSource, required NetworkService networkService})
    : _authRemoteDataSource = authRemoteDataSource,
      _networkService = networkService;

  @override
  Future<Either<Failure, UserModel>> callSignUpWithEmailAndPassword({
    required String email,
    required String password,
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

      final response = await _authRemoteDataSource.signUpWithEmailAndPassword(email: email, password: password);

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
  Future<Either<Failure, UserModel>> callSignInWithEmailAndPassword({
    required String email,
    required String password,
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

      final response = await _authRemoteDataSource.signInWithEmailAndPassword(email: email, password: password);

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
  Future<Either<Failure, UserModel?>> callGetCurrentUserData() async {
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

      final response = await _authRemoteDataSource.getCurrentUserData();

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
  Future<Either<Failure, void>> callLogOutUser() async {
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

      await _authRemoteDataSource.logOutUser();

      return Right(null);
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
  Future<Either<Failure, void>> callUpdateUserPassword({required String password}) async {
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

      await _authRemoteDataSource.updateUserPassword(password: password);

      return Right(null);
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
