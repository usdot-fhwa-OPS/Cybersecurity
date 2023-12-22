import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:cybersecurity_its_app/utils/zoom_info.dart';
import 'package:cybersecurity_its_app/utils/login_info.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
  String? _userEmail;
  String? _userGroup;

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

  Future<void> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    _userEmail = prefs.getString("userEmail");
    _userGroup = prefs.getString("userGroup");
    if(mounted){
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();  
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 15.0, left: 16, right: 16),
              child: Text(
                'Account Information',
                style: TextStyle(fontSize: 18)
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 16, right: 16),
              child: Row(
                children: [ 
                  const Icon(
                    Icons.account_circle,
                    size: 30,
                    color: Colors.indigo
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: 
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Email Address:'),
                          Text('$_userEmail')
                        ]
                      )
                  )
                ]
              ),
            ), 
            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 16, right: 16),
              child: Row(
                children: [ 
                  const Icon(
                    Icons.groups,
                    size: 30,
                    color: Colors.indigo
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: 
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('User Group(s):'),
                          Text('$_userGroup')
                        ]
                      )
                  )
                ]
              ),
            ), 
            const Padding(
              padding: EdgeInsets.only(top: 15.0, left: 16, right: 16),
              child: Text(
                'Preferences',
                style: TextStyle(fontSize: 18)
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                ZoomLevelAdjustment(),
              ],
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
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align (
          alignment: Alignment.centerRight,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6, left: 16),
                child:
                Icon(Icons.zoom_in,
                  size: (28 * Provider.of<ZoomInfo>(context).zoomLevel),
                  color: Colors.indigo
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