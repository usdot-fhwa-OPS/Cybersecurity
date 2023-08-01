import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Widget for the Home/initial pages in the bottom navigation bar.
class HomeScreen extends StatelessWidget {
  /// Creates a HomeScreen
  const HomeScreen({required this.label, required this.detailsPath, required this.settingsPath, Key? key})
      : super(key: key);

  /// The label
  final String label;

  /// The path to the detail page
  final String detailsPath;

  final String settingsPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Image.asset('assets/splash.png',
            fit: BoxFit.contain,
          ),
        ),
        leadingWidth: 40,
        
        title: Text(label),
        centerTitle: true,
        titleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
        actions: [
          IconButton(onPressed: () => context.go(settingsPath), icon: const Icon(Icons.settings)),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(label,
                style: Theme.of(context).textTheme.titleLarge),
            const Padding(padding: EdgeInsets.all(4)),
            TextButton(
              onPressed: () => context.go(detailsPath),
              child: const Text('View details'),
            ),
          ],
        ),
      ),
    );
  }
}