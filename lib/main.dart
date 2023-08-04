import 'package:flutter/material.dart';
import 'package:cybersecurity_its_app/utils/router_configuration.dart';
import 'package:cybersecurity_its_app/utils/login_info.dart';
import 'package:provider/provider.dart';


final LoginInfo _loginInfo = LoginInfo();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<LoginInfo>.value(
        value: _loginInfo,
        child: MaterialApp.router(
          routerConfig: goRouter,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.grey,
          ),
        ),
      );

      
}
