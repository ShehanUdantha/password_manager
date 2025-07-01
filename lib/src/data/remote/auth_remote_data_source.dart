import 'package:pass_key/src/config/routes/app_router.dart';
import 'package:pass_key/src/core/constants/keys.dart';
import 'package:pass_key/src/core/constants/strings.dart';
import 'package:pass_key/src/core/errors/exceptions.dart';
import 'package:pass_key/src/core/utils/extensions.dart';
import 'package:pass_key/src/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signUpWithEmailAndPassword({required String email, required String password});
  Future<UserModel> signInWithEmailAndPassword({required String email, required String password});
  Session? get currentUserSession;
  Future<UserModel?> getCurrentUserData();
  Future<void> logOutUser();
  Future<void> updateUserPassword({required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _supabaseClient;

  AuthRemoteDataSourceImpl({required SupabaseClient supabaseClient}) : _supabaseClient = supabaseClient;

  @override
  Future<UserModel> signUpWithEmailAndPassword({required String email, required String password}) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {kDBUpdatedAtColumn: DateTime.now().toIso8601String()},
      );

      if (response.user == null) {
        throw SupaBaseDBException(
          message:
              rootNavigatorKey.currentContext != null
                  ? rootNavigatorKey.currentContext!.loc.userIsNullPleaseTryAgain
                  : userIsNullPleaseTryAgain,
        );
      }
      return UserModel.fromMap(response.user!.toJson());
    } catch (e, stackTrace) {
      throw SupaBaseDBException(message: e.toString(), stackTrace: stackTrace);
    }
  }

  @override
  Future<UserModel> signInWithEmailAndPassword({required String email, required String password}) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(email: email, password: password);

      if (response.user == null) {
        throw SupaBaseDBException(
          message:
              rootNavigatorKey.currentContext != null
                  ? rootNavigatorKey.currentContext!.loc.userIsNullPleaseTryAgain
                  : userIsNullPleaseTryAgain,
        );
      }
      return UserModel.fromMap(response.user!.toJson());
    } catch (e, stackTrace) {
      throw SupaBaseDBException(message: e.toString(), stackTrace: stackTrace);
    }
  }

  @override
  Session? get currentUserSession => _supabaseClient.auth.currentSession;

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final response = await _supabaseClient
            .from(kDBProfilesTable)
            .select()
            .eq(kDBIdColumn, currentUserSession!.user.id);

        return UserModel.fromMap(response.first);
      }

      return null;
    } catch (e, stackTrace) {
      throw SupaBaseDBException(message: e.toString(), stackTrace: stackTrace);
    }
  }

  @override
  Future<void> logOutUser() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (e, stackTrace) {
      throw SupaBaseDBException(message: e.toString(), stackTrace: stackTrace);
    }
  }

  @override
  Future<void> updateUserPassword({required String password}) async {
    try {
      final response = await _supabaseClient.auth.updateUser(
        UserAttributes(
          password: password,
        ),
      );

      if (response.user == null) {
        throw SupaBaseDBException(
          message:
              rootNavigatorKey.currentContext != null
                  ? rootNavigatorKey.currentContext!.loc.userIsNullPleaseTryAgain
                  : userIsNullPleaseTryAgain,
        );
      }
    } catch (e, stackTrace) {
      throw SupaBaseDBException(message: e.toString(), stackTrace: stackTrace);
    }
  }
}
