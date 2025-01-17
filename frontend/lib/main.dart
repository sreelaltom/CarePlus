import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/auth/presentation/bloc/auth_bloc.dart';
import 'package:frontend/auth/presentation/bloc/auth_event.dart';
// import 'package:frontend/auth/presentation/pages/login_page.dart';
import 'package:frontend/core/routes/router_configuration.dart';
import 'package:frontend/core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(SelectUserAuthEvent()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: AppTheme.light,
        routerConfig: RouterConfiguration.router,
        // home: LoginPage(),
        // routes: {
        //   RouteNames.login: (context) => LoginPage(),
        //   RouteNames.signupOne: (context) => SignupPage(),
        // },
        debugShowCheckedModeBanner: false,        
      ),
    );
  }
}
