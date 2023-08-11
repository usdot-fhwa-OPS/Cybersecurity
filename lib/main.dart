import 'package:flutter/material.dart';
import 'package:cybersecurity_its_app/utils/router_configuration.dart';
import 'package:provider/provider.dart';

import 'package:cybersecurity_its_app/providers/button_enabler_provider.dart';
import 'package:cybersecurity_its_app/providers/issue_checkbox_provider.dart';
void main() {
  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ButtonEnabler()),
        ChangeNotifierProvider(create:(_) => IssueCheckboxList()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
    );
  }
}
