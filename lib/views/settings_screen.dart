import 'dart:async';
import 'dart:io';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:cybersecurity_its_app/utils/zoom_info.dart';
import 'package:cybersecurity_its_app/utils/login_info.dart';
import 'package:amplify_flutter/amplify_flutter.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    required this.label, 
    Key? key,
  }) : super(key: key);
  
  final String label; 

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}
class SettingsScreenState extends State<SettingsScreen> {

  logoutButtonPressed(BuildContext context) {
    Provider.of<LoginInfo>(context, listen: false).logout();
  }

  Future<void> signOutCurrentUser() async {
    try {
      final result = await Amplify.Auth.signOut();
      if (result is CognitoCompleteSignOut && mounted) {
        safePrint('Sign out completed successfully');
        context.go('/Login');
      } else if (result is CognitoFailedSignOut) {
        safePrint('Error signing user out: ${result.exception.message}');
      }
    } catch (e) {
        safePrint('');
    }
  } 

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.label),
        iconTheme: IconThemeData(
          color: Colors.black,
          size: (22 * Provider.of<ZoomInfo>(context).zoomLevel),
        ),
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
        centerTitle: true,
      ),
      body: 
      Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListView(
              padding: const EdgeInsets.only(top: 8.0),
              shrinkWrap: true,
              children: <Widget>[
                ZoomLevelAdjustment(),
              ],
            ),
                      ElevatedButton(
                        onPressed: () {
                          FirebaseCrashlytics.instance
                              .log('This is a log example');
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                                'The message "This is a log example" has been logged \n'
                                'Message will appear in Firebase Console once an error has been reported.'),
                            duration: Duration(seconds: 5),
                          ));
                        },
                        child: const Text('Log'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('App will crash is 5 seconds \n'
                                'Please reopen to send data to Crashlytics'),
                            duration: Duration(seconds: 5),
                          ));

                          // Delay crash for 5 seconds
                          sleep(const Duration(seconds: 5));

                // Use FirebaseCrashlytics to throw an error. Use this for
                // confirmation that errors are being correctly reported.
                FirebaseCrashlytics.instance.crash();
              },
              child: const Text('Crash'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 16, right: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red
                  ),
                  onPressed: () {
                    //TODO remove test data and add actual authentication
                    //context.read<LoginInfo>().login('test-user');
                    signOutCurrentUser();
                  },
                  child: const Text('Sign Out'),
                ),
              ),
            ),
          ],
      ),
    );
  }
}

class ZoomLevelAdjustment extends StatelessWidget {
  ZoomLevelAdjustment({super.key});

  zoomLevelChanged(BuildContext context, double? value) {
    zoomLevel = value!;
    context.read<ZoomInfo>().updateZoom(zoomLevel);
  }

  double zoomLevel = 1;

  // Zoom levels. Clear app cache/data before running app after change.
  static final List<double> zoomListLabel = <double>[1.0, 1.25, 1.5, 2];

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align (
          alignment: Alignment.centerRight,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child:
                Icon(Icons.zoom_in,
                  size: (18 * Provider.of<ZoomInfo>(context).zoomLevel),
                )),
              const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                    "Zoom Level",
                    textAlign: TextAlign.center,
                  )),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(1),
          child: DropdownButton(
            underline: const SizedBox(),
            value: Provider.of<ZoomInfo>(context, listen: false).zoomLevel,
            onChanged: (double? value) {
              zoomLevelChanged(context, value);
            },
            items: zoomListLabel
                .map<DropdownMenuItem<double>>((double value) {
              return DropdownMenuItem<double>(
                value: value,
                child: Text("$value"),
              );
            }).toList(),
          )
        ),
      ],
    );
  }

}