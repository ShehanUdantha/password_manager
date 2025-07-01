import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pass_key/l10n/generated/app_localizations.dart';
import 'package:pass_key/src/blocs/auth/auth_bloc.dart';
import 'package:pass_key/src/blocs/language/language_cubit.dart';
import 'package:pass_key/src/blocs/password/password_bloc.dart';
import 'package:pass_key/src/blocs/settings/settings_cubit.dart';
import 'package:pass_key/src/blocs/theme/theme_cubit.dart';
import 'package:pass_key/src/config/routes/route_names.dart';
import 'package:pass_key/src/config/routes/app_router.dart';
import 'package:pass_key/src/config/theme/app_theme.dart';
import 'package:window_manager/window_manager.dart';
import 'package:pass_key/src/core/services/service_locator.dart' as locator;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize dependency injection
  await locator.serviceLocator();

  // initialize desktop window
  if (!kIsWeb) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
      size: Size(900, 600),
      minimumSize: Size(900, 600),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => locator.sl<AuthBloc>()),
        BlocProvider(create: (context) => locator.sl<PasswordBloc>()),
        BlocProvider(create: (context) => locator.sl<SettingsCubit>()),
        BlocProvider(create: (context) => locator.sl<ThemeCubit>()),
        BlocProvider(create: (context) => locator.sl<LanguageCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        buildWhen: (previous, current) => previous.themeMode != current.themeMode,
        builder: (context, themeState) {
          return BlocBuilder<LanguageCubit, LanguageState>(
            buildWhen: (previous, current) => previous.languageLocale != current.languageLocale,
            builder: (context, languageState) {
              return MaterialApp(
                title: 'PassKey',
                debugShowCheckedModeBanner: false,
                theme: lightThemeData(context),
                darkTheme: darkThemeData(context),
                themeMode: themeState.themeMode,
                locale: languageState.languageLocale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                navigatorKey: rootNavigatorKey,
                initialRoute: splashRoute,
                onGenerateRoute: AppRouter.generateRoute,
              );
            },
          );
        },
      ),
    );
  }
}
