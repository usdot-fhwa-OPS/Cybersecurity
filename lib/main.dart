import 'package:flutter/material.dart';
import 'package:cybersecurity_its_app/utils/router_configuration.dart';
import 'package:cybersecurity_its_app/utils/login_info.dart';
import 'package:provider/provider.dart';

final LoginInfo _loginInfo = LoginInfo();
import 'package:provider/provider.dart';
import 'package:cybersecurity_its_app/utils/zoom_info.dart';

void main() {
  runApp(const AppProviders());
}

final ZoomInfo _zoomInfo = ZoomInfo();


/// Initializes all providers, before building the main app.
class AppProviders extends StatelessWidget {
  const AppProviders({super.key});

  @override
  Widget build(BuildContext context) =>
      MultiProvider(
          providers: [
            ChangeNotifierProvider(
                create: (_) => _zoomInfo),
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
    return MaterialApp.router(
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
    );
}
