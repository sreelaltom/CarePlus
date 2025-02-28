import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/common/app_enums.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:frontend/core/routes/route_constants.dart';
import 'package:frontend/core/routes/router_configuration.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  await Dependencies.initialize();

  runApp(const HealthMonitoringApp());
}

class HealthMonitoringApp extends StatelessWidget {
  const HealthMonitoringApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(SelectUserAuthEvent()),
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) =>
            previous != current &&
            (current is AuthFailure &&
                current.type != AuthFailureType.unexpected),
        listener: (context, state) {
          if (state is AuthFailure) {
            if (state.type == AuthFailureType.sessionExpired) {
              context.read<AuthBloc>().add(SelectUserAuthEvent());
            }
            Fluttertoast.showToast(
              msg: state.type.message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: AppColors.error,
              textColor: AppColors.white,
              fontSize: 16.0,
            );
          }
        },
        child: MaterialApp.router(
          title: 'Flutter Demo',
          theme: AppTheme.light,
          routerConfig: RouterConfiguration.router,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
