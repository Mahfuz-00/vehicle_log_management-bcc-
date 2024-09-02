import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rename_app/rename_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'UI/Bloc/auth_cubit.dart';
import 'UI/Bloc/email_cubit.dart';
import 'UI/Pages/Splashscreen UI/splashscreenUI.dart';

/// The entry point of the Flutter application.
///
/// This function initializes necessary services, checks and clears the cache,
/// and then runs the main application widget.
///
/// Actions:
/// - Calls [checkAndClearCache] to ensure any old cache is cleared
///   when the app version changes.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await checkAndClearCache();
  runApp(const MyApp());
}

/// Checks the current application version against the stored version
/// in [SharedPreferences]. If the versions differ, it clears the cache
/// using [DefaultCacheManager] and updates the stored version.
///
/// - [prefs]: Instance of [SharedPreferences] used to access stored data.
/// - [packageInfo]: Instance of [PackageInfo] that holds version information.
/// - [currentVersion]: A string representing the current version of the app.
/// - [storedVersion]: The previously stored version of the app, retrieved from [SharedPreferences].
Future<void> checkAndClearCache() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String currentVersion = packageInfo.version;
  String? storedVersion = prefs.getString('app_version');

  if (storedVersion == null || storedVersion != currentVersion) {
    await DefaultCacheManager().emptyCache();
    await prefs.setString('app_version', currentVersion);
  }
}

/// A stateless widget that represents the main application.
///
/// This widget sets the system UI overlay style and initializes the
/// necessary [Bloc] providers for state management.
///
/// - [AuthCubit]: Bloc provider for managing authentication state.
/// - [EmailCubit]: Bloc provider for managing email-related state.
///
/// Actions:
/// - Sets the system UI overlay style using [SystemChrome].
/// - Configures the application with a [MaterialApp] that includes
///   theme and home page settings.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(
          25, 192, 122, 1),
    ));

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => EmailCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BCC Vehicle Management App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromRGBO(25, 192, 122, 1)),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
