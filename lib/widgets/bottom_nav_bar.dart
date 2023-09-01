import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../utils/zoom_info.dart';

// Stateful navigation based on:
// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('BottomNavBar'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      // BottomNavigationBar implementation with three tabs.
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        destinations: [
          NavigationDestination(
              label: 'Device',
              icon: Icon(Icons.traffic,
                size: (22 * Provider.of<ZoomInfo>(context).zoomLevel),)),
          NavigationDestination(
              label: 'Help',
              icon: Icon(Icons.textsms,
                size: (22 * Provider.of<ZoomInfo>(context).zoomLevel),)),
          NavigationDestination(
              label: 'Settings',
              icon: Icon(Icons.account_circle,
                size: (22 * Provider.of<ZoomInfo>(context).zoomLevel),))
        ],
        onDestinationSelected: _goBranch,
      ),
    );
  }
}
