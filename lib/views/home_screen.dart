import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Widget for the Home/initial pages in the bottom navigation bar.
class HomeScreen extends StatelessWidget {
  /// Creates a HomeScreen
  const HomeScreen({required this.label, required this.detailsPath, Key? key})
      : super(key: key);

  /// The label
  final String label;

  /// The path to the detail page
  final String detailsPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(label),
        centerTitle: true,
        titleTextStyle: const TextStyle(fontSize: 18),
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