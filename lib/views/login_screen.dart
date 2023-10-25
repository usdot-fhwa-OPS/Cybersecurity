import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({
    required this.label,
    Key? key,
  }) : super(key: key);

  final String label;

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>{
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  Future<void> signInUser({required String password, required String username}) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: username,
        password: password,
      );

      if (result.isSignedIn && mounted) {
        context.go('/Home');
      }
    } on AuthException catch (e) {
      safePrint('Error signing in: ${e.message}');
    }
  }

  Future<void> signOutCurrentUser() async {
  final result = await Amplify.Auth.signOut();
  if (result is CognitoCompleteSignOut) {
    safePrint('Sign out completed successfully');
  } else if (result is CognitoFailedSignOut) {
    safePrint('Error signing user out: ${result.exception.message}');
  }
}

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.label),
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(fontSize: 16),
        centerTitle: true,
      ),
      body:
        Center (
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [ 
              Visibility(
                visible: (MediaQuery.of(context).viewInsets.bottom == 0) ? true : false,
                child: Padding( 
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Image.asset('assets/logo.png',
                    fit: BoxFit.contain,
                    height: 75,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 16, right: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: TextField(
                    controller: emailTextController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 16, right: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: TextField(
                    controller: passwordTextController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 16, right: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      signInUser(username: emailTextController.text, password: passwordTextController.text);
                    },
                    child: const Text('Login'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 16, right: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    child: const Text(
                      'Forgot password?',
                    ),
                    onTap: () {
                      //TODO go to forgot password page
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 16, right: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    child: const Text(
                      'Privacy',
                    ),
                    onTap: () {
                      //TODO go to privacy page
                    },
                  ),
                ),
              ),
            ]
          )
      )
    );
  }
}
