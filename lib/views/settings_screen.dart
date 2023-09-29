import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cybersecurity_its_app/utils/zoom_info.dart';
import 'package:cybersecurity_its_app/utils/login_info.dart';

class SettingsScreen extends StatelessWidget {
  /// Creates a SettingsScreen
  const SettingsScreen({required this.label, Key? key}) : super(key: key);

  /// The label
  final String label;

  logoutButtonPressed(BuildContext context) {
    Provider.of<LoginInfo>(context, listen: false).logout();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(label),
        iconTheme: IconThemeData(
          color: Colors.black,
          size: (22 * Provider.of<ZoomInfo>(context).zoomLevel),
        ),
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListView(
              padding: const EdgeInsets.only(top: 8.0),
              shrinkWrap: true,
              children: <Widget>[
                ZoomLevelAdjustment(),
              ],
            ),
            TextButton(
              onPressed: () => throw Exception(),
              child: const Text("Throw Test Exception"),
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
            Expanded(
                child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: MaterialButton(
                        color: Colors.indigo,
                        onPressed: () => logoutButtonPressed(context),
                        child: const Text('Logout',
                            style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ))),
          ],
        ),
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