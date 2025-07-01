import 'package:pass_key/src/core/constants/keys.dart';
import 'package:pass_key/src/core/errors/exceptions.dart';
import 'package:pass_key/src/models/password_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class PasswordRemoteDataSource {
  Future<PasswordModel> addPassword(PasswordModel passwordModel);
  Future<PasswordModel> updatePassword(PasswordModel passwordModel);
  Future<String> deletePassword(String id);
  Future<List<PasswordModel>> getAllPasswords(
    String query,
    String uid,
  );
  Future<List<PasswordModel>> getFavoritePasswords(
    String query,
    String uid,
  );
  Future<List<PasswordModel>> getAllPasswordsByCategory(
    String category,
    String query,
    String uid,
  );
}

class PasswordRemoteDataSourceImpl implements PasswordRemoteDataSource {
  final SupabaseClient _supabaseClient;

  PasswordRemoteDataSourceImpl({required SupabaseClient supabaseClient}) : _supabaseClient = supabaseClient;

  @override
  Future<PasswordModel> addPassword(PasswordModel passwordModel) async {
    try {
      final response = await _supabaseClient.from(kDBPasswordsTable).insert(passwordModel.toMap()).select();

      return PasswordModel.fromMap(response.first);
    } on PostgrestException catch (e, stackTrace) {
      throw SupaBaseDBException(message: e.toString(), stackTrace: stackTrace);
    } catch (e, stackTrace) {
      throw SupaBaseDBException(message: e.toString(), stackTrace: stackTrace);
    }
  }

  @override
  Future<PasswordModel> updatePassword(PasswordModel passwordModel) async {
    try {
      final response =
          await _supabaseClient.from(kDBPasswordsTable).update(passwordModel.toMap()).match({
            kDBIdColumn: passwordModel.id.toString(),
            kDBUIdColumn: passwordModel.uid.toString(),
          }).select();

      return PasswordModel.fromMap(response.first);
    } on PostgrestException catch (e, stackTrace) {
      throw SupaBaseDBException(message: e.toString(), stackTrace: stackTrace);
    } catch (e, stackTrace) {
      throw SupaBaseDBException(message: e.toString(), stackTrace: stackTrace);
    }
  }

  @override
  Future<String> deletePassword(String id) async {
    try {
      final response = await _supabaseClient.from(kDBPasswordsTable).delete().eq(kDBIdColumn, id).select();

      return PasswordModel.fromMap(response.first).id ?? "-1";
    } on PostgrestException catch (e, stackTrace) {
      throw SupaBaseDBException(message: e.toString(), stackTrace: stackTrace);
    } catch (e, stackTrace) {
      throw SupaBaseDBException(message: e.toString(), stackTrace: stackTrace);
    }
  }

  @override
  Future<List<PasswordModel>> getAllPasswords(
    String query,
    String uid,
  ) async {
    try {
      var queryBuilder = _supabaseClient.from(kDBPasswordsTable).select().eq(kDBUIdColumn, uid);

      if (query.isNotEmpty) {
        queryBuilder = queryBuilder.ilike(kDBPasswordLabelColumn, '%$query%');
      }

      final response = await queryBuilder;

      return response.map((item) => PasswordModel.fromMap(item)).toList();
    } on PostgrestException catch (e, stackTrace) {
      throw SupaBaseDBException(message: e.toString(), stackTrace: stackTrace);
    } catch (e, stackTrace) {
      throw SupaBaseDBException(message: e.toString(), stackTrace: stackTrace);
    }
  }

  @override
  Future<List<PasswordModel>> getFavoritePasswords(
    String query,
    String uid,
  ) async {
    try {
      var queryBuilder = _supabaseClient
          .from(kDBPasswordsTable)
          .select()
          .eq(kDBUIdColumn, uid)
          .eq(kDBPasswordIsFavoriteColumn, true);

      if (query.isNotEmpty) {
        queryBuilder = queryBuilder.ilike(kDBPasswordLabelColumn, '%$query%');
      }

      final response = await queryBuilder;

      return response.map((item) => PasswordModel.fromMap(item)).toList();
    } on PostgrestException catch (e, stackTrace) {
      throw SupaBaseDBException(message: e.toString(), stackTrace: stackTrace);
    } catch (e, stackTrace) {
      throw SupaBaseDBException(message: e.toString(), stackTrace: stackTrace);
    }
  }

  @override
  Future<List<PasswordModel>> getAllPasswordsByCategory(
    String category,
    String query,
    String uid,
  ) async {
    try {
      var queryBuilder = _supabaseClient
          .from(kDBPasswordsTable)
          .select()
          .eq(kDBUIdColumn, uid)
          .eq(kDBPasswordCategoryColumn, category);

      if (query.isNotEmpty) {
        queryBuilder = queryBuilder.ilike(kDBPasswordLabelColumn, '%$query%');
      }

      final response = await queryBuilder;

      return response.map((item) => PasswordModel.fromMap(item)).toList();
    } on PostgrestException catch (e, stackTrace) {
      throw SupaBaseDBException(message: e.toString(), stackTrace: stackTrace);
    } catch (e, stackTrace) {
      throw SupaBaseDBException(message: e.toString(), stackTrace: stackTrace);
    }
  }
}
