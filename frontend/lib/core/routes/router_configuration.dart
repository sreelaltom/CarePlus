import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:frontend/bottom_nav/bottom_navigation_page.dart';
import 'package:frontend/core/routes/route_constants.dart';
import 'package:frontend/core/routes/slide_transition_wrapper.dart';
import 'package:frontend/features/checkup/checkups_page.dart';
import 'package:frontend/features/auth/domain/entities/session.dart';
import 'package:frontend/features/auth/presentation/bloc/session_cubit/session_cubit.dart';
// import 'package:frontend/core/config/session_manager.dart';
import 'package:frontend/features/auth/presentation/pages/login_page.dart';
import 'package:frontend/features/auth/presentation/pages/register_page_one.dart';
import 'package:frontend/features/auth/presentation/pages/register_page_two.dart';
import 'package:frontend/features/chat/chat_page.dart';
import 'package:frontend/features/history/history_page.dart';
import 'package:frontend/features/media/media_upload_page.dart';
import 'package:frontend/features/profile/profile_page.dart';
import 'package:frontend/service_locator.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _historyNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _mediaNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _chatNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _profileNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _settingsNavigatorKey =
    GlobalKey<NavigatorState>();

class RouterConfiguration {
  static get router => _router;
  static final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    routes: <RouteBase>[
      GoRoute(
        name: RouteNames.signupTwoDoctor,
        path: '/signup-two-doctor/:regId/:phone',
        pageBuilder: (context, state) => slideTransitionWrapper(
          page: SignupPageTwo.doctor(
            regId: state.pathParameters['regId']!,
            phone: state.pathParameters['phone']!,
          ),
        ),
      ),
      GoRoute(
        name: RouteNames.signupTwoUser,
        path: '/signup-two-user/:email/:phone',
        pageBuilder: (context, state) => slideTransitionWrapper(
          page: SignupPageTwo.user(
            email: state.pathParameters['email']!,
            phone: state.pathParameters['phone']!,
          ),
        ),
      ),
      GoRoute(
        name: RouteNames.login,
        path: '/login',
        redirect: (context, state) async {
          await serviceLocator<SessionCubit>().loadSession();
          if (serviceLocator.isRegistered<Session>()) {
            developer.log("GO ROUTER: Redirecting user to main ");
            final session = serviceLocator<Session>();
            // return '/main/${session.userID}/${session.accessToken}/${session.refreshToken}';
            return '/history';
          } else {
            developer.log("GO ROUTER: Redirecting user to login");
            return '/login';
          }
        },
        pageBuilder: (context, state) =>
            slideTransitionWrapper(page: LoginPage()),
      ),
      GoRoute(
        name: RouteNames.signupOne,
        path: '/signup-one',
        pageBuilder: (context, state) =>
            slideTransitionWrapper(page: SignupPageOne()),
      ),
      // GoRoute(
      //   name: RouteNames.main,
      //   path: '/main/:user_id/:access_token/:refresh_token',
      //   pageBuilder: (context, state) => slideTransitionWrapper(
      //     page: BottomNavigationPage(
      //       userID: state.pathParameters['user_id']!,
      //       accessToken: state.pathParameters['access_token']!,
      //       refreshToken: state.pathParameters['refresh_token']!,
      //     ),
      //   ),
      // ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            BottomNavigationPage(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _historyNavigatorKey,
            routes: [
              GoRoute(
                name: RouteNames.history,
                path: '/history',
                builder: (context, state) => HistoryPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _mediaNavigatorKey,
            routes: [
              GoRoute(
                name: RouteNames.media,
                path: '/media',
                builder: (context, state) => MediaUploadPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _chatNavigatorKey,
            routes: [
              GoRoute(
                name: RouteNames.chat,
                path: '/chat',
                builder: (context, state) => ChatPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _profileNavigatorKey,
            routes: [
              GoRoute(
                name: RouteNames.profile,
                path: '/profile',
                builder: (context, state) => ProfilePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _settingsNavigatorKey,
            routes: [
              GoRoute(
                name: RouteNames.checkups,
                path: '/checkups',
                builder: (context, state) => CheckupsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
