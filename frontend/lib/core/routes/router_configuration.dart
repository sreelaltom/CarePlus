import 'package:flutter/material.dart';
import 'package:frontend/features/auth/presentation/bloc/session_cubit/session_cubit.dart';
// import 'package:frontend/core/config/session_manager.dart';
import 'package:frontend/features/auth/presentation/pages/login_page.dart';
import 'package:frontend/features/auth/presentation/pages/register_page_one.dart';
import 'package:frontend/features/auth/presentation/pages/register_page_two.dart';
import 'package:frontend/features/auth/domain/entities/session.dart';
import 'package:frontend/core/routes/route_constants.dart';
import 'package:frontend/core/routes/slide_transition_wrapper.dart';
import 'package:frontend/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/service_locator.dart';
import 'dart:developer' as developer;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class RouterConfiguration {
  static get router => _router;
  static final _router = GoRouter(
    navigatorKey: navigatorKey,
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
        // redirect: (context, state) async {
        //   final session = await SessionManager().hadActiveSession();
        //   final userLoggedIn = session != null;
        //   if (userLoggedIn) {
        //     return '/dashboard/${session.userID}/${session.accessToken}/${session.refreshToken}';
        //   }
        //   return null;
        // },
        redirect: (context, state) async{
          await serviceLocator<SessionCubit>().loadSession();
          if (serviceLocator.isRegistered<Session>()) {
            developer.log("GO ROUTER: Redirecting user to dashboard");
            final session = serviceLocator<Session>();
            return '/dashboard/${session.userID}/${session.accessToken}/${session.refreshToken}';
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
      GoRoute(
        name: RouteNames.dashboard,
        path: '/dashboard/:user_id/:access_token/:refresh_token',
        pageBuilder: (context, state) => slideTransitionWrapper(
          page: DashboardPage(
            userID: state.pathParameters['user_id']!,
            accessToken: state.pathParameters['access_token']!,
            refreshToken: state.pathParameters['refresh_token']!,
          ),
        ),
      ),
    ],
  );
}
