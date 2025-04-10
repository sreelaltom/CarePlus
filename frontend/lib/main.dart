import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/network/cubit/connectivity_cubit.dart';
import 'package:frontend/core/network/cubit/connectivity_state.dart';
import 'package:frontend/features/auth/presentation/bloc/session_cubit/session_cubit.dart';
import 'package:frontend/features/auth/presentation/bloc/session_cubit/session_state.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:frontend/core/routes/router_configuration.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/features/home/presentation/bloc/analysis_result/analysis_result_cubit.dart';
import 'package:frontend/service_locator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  await Dependencies.initialize();

  runApp(const CarePulse());
}

class CarePulse extends StatelessWidget {
  const CarePulse({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc()..add(SelectUserAuthEvent()),
        ),
        BlocProvider<SessionCubit>(
          create: (_) => serviceLocator<SessionCubit>(),
        ),
        BlocProvider<ConnectivityCubit>(
          create: (_) => serviceLocator<ConnectivityCubit>(),
        ),
        BlocProvider<AnalysisResultCubit>(create: (_) => AnalysisResultCubit()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<SessionCubit, SessionState>(
            listenWhen: (previous, current) =>
                previous != current && current is InactiveSession,
            listener: (context, state) {
              if (state is InactiveSession && state.message != null) {
                context.read<AuthBloc>().add(SelectUserAuthEvent());
                Fluttertoast.showToast(
                  msg: state.message!,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: AppColors.error,
                  textColor: AppColors.white,
                  fontSize: 16.0,
                );
              }
            },
          ),
          BlocListener<ConnectivityCubit, ConnectivityState>(
            listenWhen: (previous, current) =>
                previous.internetStatus != current.internetStatus &&
                current.internetStatus == InternetStatus.disconnected,
            listener: (context, state) {
              scaffoldMessengerKey.currentState
                ?..clearSnackBars()
                ..showSnackBar(
                  SnackBar(content: Text("No Internet connection!")),
                );
            },
          )
        ],
        child: MaterialApp.router(
          scaffoldMessengerKey: scaffoldMessengerKey,
          title: 'CarePulse',
          theme: AppTheme.light,
          routerConfig: RouterConfiguration.router,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
