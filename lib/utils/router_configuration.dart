import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cybersecurity_its_app/widgets/bottom_nav_bar.dart';
import 'package:cybersecurity_its_app/screens/home_screen.dart';
import 'package:cybersecurity_its_app/screens/device_detail_screen.dart';
import 'package:cybersecurity_its_app/screens/help_screen.dart';
import 'package:cybersecurity_its_app/screens/settings_screen.dart';
// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>(); 
final _shellNavigatorAKey = GlobalKey<NavigatorState>(debugLabel: 'shellA');
final _shellNavigatorBKey = GlobalKey<NavigatorState>(debugLabel: 'shellB');
final _shellNavigatorCKey = GlobalKey<NavigatorState>(debugLabel: 'shellC');

/// The route configuration.
final goRouter = GoRouter(
  initialLocation: '/Home',
  navigatorKey: _rootNavigatorKey,
  routes: [
    // Stateful nested navigation based on:
    // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // the UI shell
        return BottomNavBar(
            navigationShell: navigationShell);
      },
      branches: [
        // first branch (Home)
        StatefulShellBranch(
          navigatorKey: _shellNavigatorAKey,
          routes: [
            // top route inside branch
            GoRoute(
              path: '/Home',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HomeScreen(label: 'Field Device Security Configuration Tool', detailsPath: '/Home/details'),
              ),
              routes: [
                // child route
                GoRoute(
                  path: 'details',
                  builder: (context, state) =>
                      const DetailsScreen(label: 'Select Vendor and Model'),
                ),
              ],
            ),
          ],
        ),
        // second branch (Help)
        StatefulShellBranch(
          navigatorKey: _shellNavigatorBKey,
          routes: [
            // top route inside branch
            GoRoute(
              path: '/Help',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HelpScreen(label: 'Report an Issue'),
              ),
            ),
          ],
        ),
        // third branch (Settings)
        StatefulShellBranch(
          navigatorKey: _shellNavigatorCKey,
          routes: [
            // top route inside branch
            GoRoute(
              path: '/Settings',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SettingsScreen(label: 'Settings'),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);