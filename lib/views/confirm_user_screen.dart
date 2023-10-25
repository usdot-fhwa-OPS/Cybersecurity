import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({required this.email, Key? key}) : super(key:key);

  final String? email;

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  final TextEditingController codeTextController = TextEditingController();

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

  Future<void> confirmUser({
    required String username,
    required String confirmationCode,
  }) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: username,
        confirmationCode: confirmationCode,
      );

      // if (result.isSignUpComplete && mounted) {
        
      // }
      
      // Check if further confirmations are needed or if
      // the sign up is complete.
      await _handleSignUpResult(result);
    } on AuthException catch (e) {
      safePrint('Error confirming user: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm User'),
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
              controller: codeTextController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Confirmation Code',
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 16, right: 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => confirmUser(username: widget.email!, confirmationCode: codeTextController.text),
              child: const Text('Confirm User'),
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
      ],
      ),
    );
  }
}