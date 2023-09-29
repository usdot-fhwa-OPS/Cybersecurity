import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:cybersecurity_its_app/utils/router_configuration.dart';
import 'package:cybersecurity_its_app/utils/login_info.dart';
import 'package:cybersecurity_its_app/utils/zoom_info.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:cybersecurity_its_app/providers/button_enabler_provider.dart';
import 'package:cybersecurity_its_app/providers/issue_checkbox_provider.dart';

final LoginInfo _loginInfo = LoginInfo();
final ZoomInfo _zoomInfo = ZoomInfo();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const AppProviders());
}

/// Initializes all providers, before building the main app.
class AppProviders extends StatelessWidget {
  const AppProviders({super.key});

  @override
  Widget build(BuildContext context) =>
      MultiProvider(
          providers: [
            ChangeNotifierProvider(
                create: (_) => _zoomInfo),
            ChangeNotifierProvider(
                create: (_) => _loginInfo),
            ChangeNotifierProvider(
                create: (_) => ButtonEnabler()),
            ChangeNotifierProvider(
                create:(_) => IssueCheckboxList()),
          ],
        child: MyApp(),
      );
}

class MyApp extends StatelessWidget {
  
  MyApp({super.key});

  bool runOnce = true;

  @override
    Widget build(BuildContext context) {

    /// Initialize Store and zoom level only on first build.
    if (runOnce){
      runOnce = false;
      Provider.of<ZoomInfo>(context).initZoomLevelStore();
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp.router(
        builder: (BuildContext context, Widget? child) {

          /// Get Current Media info, and multiply by user settings.
          final MediaQueryData data = MediaQuery.of(context);
          return MediaQuery(
            data: data.copyWith(
                textScaleFactor: data.textScaleFactor * Provider.of<ZoomInfo>(context).zoomLevel,
                boldText: true
            ),
            child: child!,
          );
        },
        routerConfig: goRouter,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
      )
    );
  }
}

