import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/core/common/app_enums.dart';
import 'package:frontend/features/auth/presentation/bloc/session_cubit/session_cubit.dart';
import 'package:frontend/features/auth/presentation/auth_validators.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:frontend/features/auth/presentation/widgets/auth_button.dart';
import 'package:frontend/features/auth/presentation/widgets/auth_prompt.dart';
import 'package:frontend/features/auth/presentation/widgets/email_reg_field.dart';
import 'package:frontend/features/auth/presentation/widgets/password_field.dart';
import 'package:frontend/features/auth/presentation/widgets/semicircles.dart';
import 'package:frontend/features/auth/presentation/widgets/switch_button.dart';
import 'package:frontend/core/config/responsive.dart';
import 'package:frontend/core/routes/route_constants.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer' as developer;

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _regIdController = TextEditingController();
  final _regIdFocusNode = FocusNode();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final ValueNotifier<bool> _visibilityNotifier = ValueNotifier<bool>(true);

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sWidth = Responsive.screenWidth(context);
    final sHeight = Responsive.screenHeight(context);
    final ifMobile = Responsive.isMobile(context);
    final ifDesktop = Responsive.isDesktop(context);

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous != current &&
          (current is AuthSuccess ||
              (current is AuthFailure &&
                  ![AuthFailureType.logout, AuthFailureType.sessionExpired]
                      .contains(current.type))),
      listener: (context, state) async {
        final message = state is AuthSuccess
            ? state.type?.message ?? "Login Successful"
            : (state as AuthFailure).error ??
                "An unexpected error occurred while logging in";
        if (!ifDesktop) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                content: Text(message),
                duration: const Duration(seconds: 3),
              ),
            );
        } else {
          Fluttertoast.showToast(
            msg: message,
            gravity: ToastGravity.TOP,
            toastLength: Toast.LENGTH_SHORT,
          );
        }
        if (state is AuthFailure) {
          context.read<AuthBloc>().add(SelectUserAuthEvent());
        } else if (state is AuthSuccess && state.session != null) {
          context.goNamed(
            RouteNames.history,
            // pathParameters: {
            //   'user_id': state.session!.userID.toString(),
            //   'access_token': state.session!.accessToken,
            //   'refresh_token': state.session!.refreshToken,
            // },
          );
          context.read<SessionCubit>().createSession(session: state.session!);
        } else {
          if (state is AuthSuccess) {
            developer.log("AuthSuccess.session = ${state.session}");
          } else {
            developer.log("AuthState is ${state.runtimeType}");
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: SizedBox(
            width: sWidth,
            height: sHeight,
            child: Stack(
              children: [
                const Semicircles(isLeft: true, right: 0, top: 0),
                const Semicircles(isLeft: false, left: 0, bottom: 0),
                Center(
                  child: BlocBuilder<AuthBloc, AuthState>(
                    buildWhen: (previous, current) =>
                        (previous is AuthProcessing &&
                            current is! AuthProcessing) ||
                        (previous is! AuthProcessing &&
                            current is AuthProcessing),
                    builder: (context, state) {
                      if (state is AuthProcessing) {
                        return const CircularProgressIndicator();
                      } else {
                        return Container(
                          width: sWidth *
                              (ifMobile ? 0.95 : (ifDesktop ? 1 / 3 : 0.55)),
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  spacing: 10,
                                  children: [
                                    SwitchButton(
                                      label: 'Doctor',
                                      onTap: () => _switchUserType(
                                        context,
                                        toDoctor: true,
                                        nextFocusNode: _regIdFocusNode,
                                      ),
                                    ),
                                    SwitchButton(
                                      label: 'User',
                                      onTap: () => _switchUserType(
                                        context,
                                        nextFocusNode: _emailFocusNode,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                EmailOrRegIdField(
                                  emailController: _emailController,
                                  regIdController: _regIdController,
                                  emailFocusNode: _emailFocusNode,
                                  regIdFocusNode: _regIdFocusNode,
                                  onSubmit: (value) =>
                                      _passwordFocusNode.requestFocus(),
                                ),
                                const SizedBox(height: 10),
                                PasswordField(
                                  hintText: 'Password',
                                  controller: _passwordController,
                                  focusNode: _passwordFocusNode,
                                  visibility: _visibilityNotifier,
                                  onSubmit: (value) => _requestForLogin(
                                    context,
                                    loginFormKey: _formKey,
                                    isDoctor: context.read<AuthBloc>().state
                                        is DoctorAuthState,
                                    password: _passwordController.text.trim(),
                                    email: _emailController.text.trim(),
                                    registrationId:
                                        _regIdController.text.trim(),
                                  ),
                                  validator: (value) =>
                                      AuthValidators.validatePassword(
                                    value: value!,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: AuthPrompt.complete(
                                    hyperText: 'Forgot Password?',
                                    onTap: () {},
                                  ),
                                ),
                                const SizedBox(height: 20),
                                AuthButton(
                                  label: 'Signin',
                                  onPressed: () => _requestForLogin(
                                    context,
                                    loginFormKey: _formKey,
                                    email: _emailController.text.trim(),
                                    registrationId:
                                        _regIdController.text.trim(),
                                    password: _passwordController.text.trim(),
                                    isDoctor: context.read<AuthBloc>().state
                                        is DoctorAuthState,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                AuthPrompt.partial(
                                  text: 'Don\'t have an account? ',
                                  hyperText: 'Signup',
                                  onTap: () {
                                    context.canPop()
                                        ? context.pop()
                                        : context
                                            .pushNamed(RouteNames.signupOne);
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _requestForLogin(
  BuildContext context, {
  required GlobalKey<FormState> loginFormKey,
  required bool isDoctor,
  String? email,
  String? registrationId,
  required String password,
}) {
  if (loginFormKey.currentState!.validate()) {
    context.read<AuthBloc>().add(
          LoginEvent(
            isPatient: !isDoctor,
            isDoctor: isDoctor,
            email: email,
            registrationId: registrationId,
            password: password,
          ),
        );
  }
}

void _switchUserType(
  BuildContext context, {
  bool toDoctor = false,
  FocusNode? nextFocusNode,
}) {
  context
      .read<AuthBloc>()
      .add(toDoctor ? SelectDoctorAuthEvent() : SelectUserAuthEvent());
  if (nextFocusNode != null) {
    nextFocusNode.requestFocus();
  }
}
