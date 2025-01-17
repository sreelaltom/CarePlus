// import 'package:flutter/material.dart';
import 'package:frontend/auth/presentation/pages/login_page.dart';
import 'package:frontend/auth/presentation/pages/signup_page_one.dart';
import 'package:frontend/auth/presentation/pages/signup_page_two.dart';
import 'package:frontend/core/routes/route_constants.dart';
import 'package:frontend/core/routes/slide_transition_shell.dart';
import 'package:go_router/go_router.dart';

// final email = 'email';
// final registrationID = 'blah';
// final phone = '123';

class RouterConfiguration {
  static get router => _router;
  static final _router = GoRouter(
    initialLocation: '/login',
    // initialLocation: '/signup-two-user/$email/$phone',
    routes: <RouteBase>[
      GoRoute(
        name: RouteNames.signupTwoDoctor,
        path: '/signup-two-doctor/:regId/:phone',
        // pageBuilder: (context, state) => MaterialPage(
        //   child: SignupPageTwo.doctor(
        //     regId: state.pathParameters['regId']!,
        //     phone: state.pathParameters['phone']!,
        //   ),
        // ),
        pageBuilder: (context, state) => slideTransitionShell(
          page: SignupPageTwo.doctor(
            regId: state.pathParameters['regId']!,
            phone: state.pathParameters['phone']!,
          ),
        ),
      ),
      GoRoute(
          name: RouteNames.signupTwoUser,
          path: '/signup-two-user/:email/:phone',
          // pageBuilder: (context, state) => MaterialPage(
          //       child: SignupPageTwo.user(
          //         email: state.pathParameters['email']!,
          //         phone: state.pathParameters['phone']!,
          //       ),
          //     )
          pageBuilder: (context, state) => slideTransitionShell(
            page: SignupPageTwo.user(
              email: state.pathParameters['email']!,
              phone: state.pathParameters['phone']!,
            ),
          ),
          ),
      GoRoute(
        name: RouteNames.login,
        path: '/login',
        // pageBuilder: (context, state) =>
        //     MaterialPage(child: LoginPage()),
        pageBuilder: (context, state) =>
            slideTransitionShell(page: LoginPage()),
      ),
      GoRoute(
        name: RouteNames.signupOne,
        path: '/signup-one',
        // pageBuilder: (context, state) =>
        //     MaterialPage(child: SignupPageOne()),
        pageBuilder: (context, state) =>
            slideTransitionShell(page: SignupPageOne()),
      ),
    ],
  );
}
