import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:pass_key/src/blocs/auth/auth_bloc.dart';
import 'package:pass_key/src/blocs/language/language_cubit.dart';
import 'package:pass_key/src/blocs/password/password_bloc.dart';
import 'package:pass_key/src/blocs/settings/settings_cubit.dart';
import 'package:pass_key/src/blocs/theme/theme_cubit.dart';
import 'package:pass_key/src/core/services/env_service.dart';
import 'package:pass_key/src/core/services/network_service.dart';
import 'package:pass_key/src/data/remote/auth_remote_data_source.dart';
import 'package:pass_key/src/data/remote/password_remote_data_source.dart';
import 'package:pass_key/src/repositories/auth_repository.dart';
import 'package:pass_key/src/repositories/password_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> serviceLocator() async {
  // remote storage
  final supabase = await Supabase.initialize(
    url: EnvService.projectUrl,
    anonKey: EnvService.anonKey,
  );

  sl.registerLazySingleton(() => supabase.client);

  // local storage
  sl.registerSingleton<SharedPreferences>(
    await SharedPreferences.getInstance(),
  );

  // services
  sl.registerSingleton<NetworkService>(
    NetworkService(connectivity: Connectivity()),
  );

  // data sources
  sl.registerSingleton<AuthRemoteDataSource>(AuthRemoteDataSourceImpl(supabaseClient: sl()));
  sl.registerSingleton<PasswordRemoteDataSource>(PasswordRemoteDataSourceImpl(supabaseClient: sl()));

  // repositories
  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      authRemoteDataSource: sl(),
      networkService: sl(),
    ),
  );
  sl.registerSingleton<PasswordRepository>(
    PasswordRepositoryImpl(
      passwordRemoteDataSource: sl(),
      networkService: sl(),
    ),
  );

  // blocs
  sl.registerFactory<AuthBloc>(() => AuthBloc(sl()));
  sl.registerFactory<PasswordBloc>(() => PasswordBloc(sl()));
  sl.registerFactory<SettingsCubit>(() => SettingsCubit());
  sl.registerFactory<ThemeCubit>(() => ThemeCubit(sl()));
  sl.registerFactory<LanguageCubit>(() => LanguageCubit(sl()));
}
