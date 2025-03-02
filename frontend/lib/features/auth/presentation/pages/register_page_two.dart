import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/presentation/auth_validators.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:frontend/features/auth/presentation/widgets/auth_button.dart';
import 'package:frontend/features/auth/presentation/widgets/auth_input.dart';
import 'package:frontend/features/auth/presentation/widgets/auth_prompt.dart';
import 'package:frontend/features/auth/presentation/widgets/password_field.dart';
import 'package:frontend/features/auth/presentation/widgets/semicircles.dart';
import 'package:frontend/core/config/responsive.dart';
import 'package:frontend/core/routes/route_constants.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer' as developer;

class SignupPageTwo extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _nameFocusNode = FocusNode();

  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  final _confirmPasswordController = TextEditingController();
  final _confirmPasswordFocusNode = FocusNode();

  final ValueNotifier<bool> _hidePassword = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _hideConfirmPassword = ValueNotifier<bool>(true);

  late final bool _ifDoctor;
  final String? regId;
  late final String phone;
  final String? email;

  SignupPageTwo.doctor({super.key, required this.regId, required this.phone})
      : _ifDoctor = true,
        email = null;

  SignupPageTwo.user({super.key, required this.email, required this.phone})
      : _ifDoctor = false,
        regId = null;

  @override
  Widget build(BuildContext context) {
    final sWidth = Responsive.screenWidth(context);
    final sHeight = Responsive.screenHeight(context);
    final ifMobile = Responsive.isMobile(context);
    final ifDesktop = Responsive.isDesktop(context);
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous != current &&
          (current is AuthFailure || current is AuthSuccess),
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            SnackBar(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              duration: const Duration(minutes: 1),
              content: Text(
                state is AuthSuccess
                    ? state.type?.message ?? "Registration Successful"
                    : (state as AuthFailure).error ?? state.type.message,
              ),
            ),
          );
        context.pop();
        if (state is AuthSuccess) {
          context.pop();
          context.read<AuthBloc>().add(
                state.user.isPatient
                    ? SelectUserAuthEvent()
                    : SelectDoctorAuthEvent(),
              );
        } else if (state is AuthFailure) {
          context.read<AuthBloc>().add(SelectUserAuthEvent());
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
                BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (previous, current) =>
                      (previous is AuthProcessing &&
                          current is! AuthProcessing) ||
                      (previous is! AuthProcessing &&
                          current is AuthProcessing),
                  builder: (context, state) {
                    if (state is AuthProcessing) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Spacer(),
                            SizedBox(
                              width: sWidth * 0.7,
                              child: Text(
                                _ifDoctor
                                    ? 'Join the Future of Healthcare'
                                    : 'Build a Better You with Us',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _ifDoctor
                                  ? 'Transform lives\nBeyond the walls'
                                  : 'Track, Manage and Achieve your Health Goals',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: AppColors.white,
                                  ),
                            ),
                            const Spacer(flex: 1),
                            Center(
                              child: Container(
                                width: sWidth *
                                    (ifMobile
                                        ? 0.95
                                        : (ifDesktop ? 1 / 3 : 0.55)),
                                decoration: BoxDecoration(
                                  color: AppColors.lightGrey
                                      .withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      AuthInput(
                                        hintText: 'Fullname',
                                        controller: _nameController,
                                        focusNode: _nameFocusNode,
                                        validator: (value) =>
                                            AuthValidators.validateName(
                                          value: value!,
                                        ),
                                        onSubmit: (value) =>
                                            _passwordFocusNode.requestFocus(),
                                      ),
                                      const SizedBox(height: 10),
                                      PasswordField(
                                        hintText: 'Password',
                                        controller: _passwordController,
                                        focusNode: _passwordFocusNode,
                                        visibility: _hidePassword,
                                        validator: (value) =>
                                            AuthValidators.validatePassword(
                                          value: value!,
                                        ),
                                        onSubmit: (value) =>
                                            _confirmPasswordFocusNode
                                                .requestFocus(),
                                      ),
                                      const SizedBox(height: 10),
                                      PasswordField(
                                        hintText: 'Confirm Password',
                                        controller: _confirmPasswordController,
                                        focusNode: _confirmPasswordFocusNode,
                                        visibility: _hideConfirmPassword,
                                        validator: (value) => AuthValidators
                                            .validateConfirmPassword(
                                          value: value!,
                                          matchValue: _passwordController.text,
                                        ),
                                        onSubmit: (value) => _requestForSignup(
                                          context,
                                          signupFormKey: _formKey,
                                          name: _nameController.text.trim(),
                                          isDoctor: _ifDoctor,
                                          email: email,
                                          registrationId: regId,
                                          phone: phone,
                                          password:
                                              _passwordController.text.trim(),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      AuthButton(
                                        label: 'Signup',
                                        onPressed: () => _requestForSignup(
                                          context,
                                          signupFormKey: _formKey,
                                          name: _nameController.text.trim(),
                                          isDoctor: _ifDoctor,
                                          email: email,
                                          registrationId: regId,
                                          phone: phone,
                                          password:
                                              _passwordController.text.trim(),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      AuthPrompt.partial(
                                        text: 'Already have an account? ',
                                        hyperText: 'Signin',
                                        onTap: () =>
                                            context.goNamed(RouteNames.login),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(flex: 2),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _requestForSignup(
  BuildContext context, {
  required GlobalKey<FormState> signupFormKey,
  required String name,
  required bool isDoctor,
  String? email,
  String? registrationId,
  required String password,
  required String phone,
}) {
  if (signupFormKey.currentState!.validate()) {
    context.read<AuthBloc>().add(
          RegisterEvent(
            isPatient: !isDoctor,
            name: name,
            isDoctor: isDoctor,
            email: email,
            registrationId: registrationId,
            password: password,
            phone: phone,
          ),
        );
    developer.log(
      'SIGN UP REQUEST VALIDATED SUCCESSFULLY...',
      time: DateTime.now(),
    );
  }
}
