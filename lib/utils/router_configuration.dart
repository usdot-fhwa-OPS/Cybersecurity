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

import 'package:cybersecurity_its_app/views/operational_context_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:cybersecurity_its_app/utils/login_info.dart';
import 'package:cybersecurity_its_app/widgets/bottom_nav_bar.dart';
import 'package:cybersecurity_its_app/views/home_screen.dart';
import 'package:cybersecurity_its_app/views/login_screen.dart';
import 'package:cybersecurity_its_app/views/device_detail_screen.dart';
import 'package:cybersecurity_its_app/views/recommendations_screen.dart';
import 'package:cybersecurity_its_app/views/help_screen.dart';
import 'package:cybersecurity_its_app/views/settings_screen.dart';

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>(); 
final _shellNavigatorAKey = GlobalKey<NavigatorState>(debugLabel: 'shellA');
final _shellNavigatorBKey = GlobalKey<NavigatorState>(debugLabel: 'shellB');
final _shellNavigatorCKey = GlobalKey<NavigatorState>(debugLabel: 'shellC');
final _loginInfo = LoginInfo();

/// The route configuration.
final goRouter = GoRouter(
  initialLocation: '/Login',
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/Login',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: LoginScreen(label: 'ITS Device Security Login'),
      ),
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
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
                child: HomeScreen(label: 'ITS Device Security', detailsPath: '/Home/details', settingsPath: '/Home/settings',),
              ),
              routes: [
                // child route
                GoRoute(
                  name: 'details',
                  path: 'details/:deviceJson',
                  builder: (context, state) => DetailsScreen(
                    label: 'Select Vendor and Model',
                    deviceJson: state.pathParameters['deviceJson'],
                    ),
                  routes: [
                    GoRoute(
                      name: 'opcontext',
                      path: 'opcontext',
                      builder: (context, state) => OpContextScreen(
                        label: "label",
                        deviceJson: state.pathParameters['deviceJson'],
                      ),
                      routes: [
                        GoRoute(
                          name: 'recommendations',
                          path: 'recommendations',
                          builder: (context, state) => RecommendationsScreen(
                            label: "label",
                            deviceJson: state.pathParameters['deviceJson'],
                          )
                        )
                      ]
                    )
                  ]
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
        // third branch (Operational Context)
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
  redirect: (BuildContext context, GoRouterState state) async {
      // if the user is not logged in, they need to login
      final result = await Amplify.Auth.fetchAuthSession();
      final bool loggingIn = state.matchedLocation == '/Login';
      if (!result.isSignedIn) {
        return '/Login';
      }

      // if the user is logged in but still on the login page, send them to
      // the home page
      if (loggingIn) {
        return '/Home';
      }

      // no need to redirect at all
      return null;
    },

    // changes on the listenable will cause the router to refresh it's route
    refreshListenable: _loginInfo,
);