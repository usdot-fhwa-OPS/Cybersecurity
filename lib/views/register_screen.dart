/*
 * Copyright (C) 2024 LEIDOS.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:go_router/go_router.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    required this.label,
    Key? key,
  }) : super(key: key);

  final String label;

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController confirmEmailTextController = TextEditingController(); 
  final TextEditingController passwordTextController = TextEditingController();

  Future<void> _handleSignUpResult(SignUpResult result) async {
    switch (result.nextStep.signUpStep) {
      case AuthSignUpStep.confirmSignUp:
        final codeDeliveryDetails = result.nextStep.codeDeliveryDetails!;
        _handleCodeDelivery(codeDeliveryDetails);
        break;
      case AuthSignUpStep.done:
        safePrint('Sign up is complete');
        break;
    }
  }

  void _handleCodeDelivery(AuthCodeDeliveryDetails codeDeliveryDetails) {
    safePrint(
      'A confirmation code has been sent to ${codeDeliveryDetails.destination}. '
      'Please check your ${codeDeliveryDetails.deliveryMedium.name} for the code.',
    );
  }

  /// Signs a user up with a username, password, and email. The required
  /// attributes may be different depending on your app's configuration.
  Future<void> signUpUser(
    {
      required String username,
      required String password,
      required String email,
      String? phoneNumber,
    }
    ) async {
    try {
      final userAttributes = {
        AuthUserAttributeKey.email: email,
        if (phoneNumber != null) AuthUserAttributeKey.phoneNumber: phoneNumber,
        // additional attributes as needed
      };

      final result = await Amplify.Auth.signUp(
        username: username,
        password: password,
        options: SignUpOptions(
          userAttributes: userAttributes,
        ));

      if (result.isSignUpComplete && mounted) {
          context.goNamed('confirmation', pathParameters: {'email': emailTextController.text});
      }

      await _handleSignUpResult(result);
      } on AuthException catch (e) {  
      safePrint('Error signing up user: ${e.message}');
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
      body: ListView(
        children: [
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
              controller: confirmEmailTextController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Confirm Email',
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
              onPressed: () => signUpUser(username: emailTextController.text, password: passwordTextController.text, email: confirmEmailTextController.text),
                //context.go('/Register/confirmation'),
                //TODO remove test data and add actual authentication
                //context.read<LoginInfo>().login('test-user');
                
                
        
              child: const Text('Register'),
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

        Visibility(
              visible: (MediaQuery.of(context).viewInsets.bottom == 0) ? true : false,
              child: Padding( 
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Image.asset('assets/logo.png',
                  fit: BoxFit.contain,
                  height: 55,
                ),
              ),
            ),
      ],
      ),
    );
  }
  
}