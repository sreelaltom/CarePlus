import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:frontend/bottom_nav/bottom_navigation_page.dart';
import 'package:frontend/core/common/app_enums.dart';
import 'package:frontend/core/routes/route_constants.dart';
import 'package:frontend/core/routes/slide_transition_wrapper.dart';
import 'package:frontend/features/analysis/analysis_page.dart';
import 'package:frontend/features/auth/domain/entities/session.dart';
import 'package:frontend/features/auth/presentation/bloc/session_cubit/session_cubit.dart';
import 'package:frontend/features/auth/presentation/pages/login_page.dart';
import 'package:frontend/features/auth/presentation/pages/register_page_one.dart';
import 'package:frontend/features/auth/presentation/pages/register_page_two.dart';
import 'package:frontend/features/chat/chat_page.dart';
import 'package:frontend/features/home/presentation/pages/analysis_results_page.dart';
import 'package:frontend/features/home/presentation/pages/home_page.dart';
import 'package:frontend/features/medical_records/presentation/medical_records_page.dart';
import 'package:frontend/features/profile/profile_page.dart';
import 'package:frontend/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _mediaNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _chatNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _profileNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _analysisNavigatorKey =
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
            return '/home';
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            BottomNavigationPage(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                name: RouteNames.home,
                path: '/home',
                builder: (context, state) => HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _mediaNavigatorKey,
            routes: [
              GoRoute(
                name: RouteNames.medicalRecords,
                path: '/medical-records',
                builder: (context, state) => MedicalRecordsPage(),
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
            navigatorKey: _analysisNavigatorKey,
            routes: [
              GoRoute(
                name: RouteNames.analysis,
                path: '/analysis',
                builder: (context, state) => AnalysisPage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        name: RouteNames.analysisResult,
        path: '/analysis-result',
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return slideTransitionWrapper(
            page: AnalysisResultsPage(     
              data['context'] as BuildContext,         
              analysisType: data['analysis_type'] as AnalysisType,
              file: data['file'] as XFile,
            ),
          );
        },
      ),
    ],
  );
}
