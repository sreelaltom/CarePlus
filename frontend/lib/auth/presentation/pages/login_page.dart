import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/auth/presentation/bloc/auth_bloc.dart';
import 'package:frontend/auth/presentation/bloc/auth_event.dart';
import 'package:frontend/auth/presentation/widgets/auth_button.dart';
import 'package:frontend/auth/presentation/widgets/auth_prompt.dart';
import 'package:frontend/auth/presentation/widgets/email_reg_field.dart';
import 'package:frontend/auth/presentation/widgets/password_field.dart';
import 'package:frontend/auth/presentation/widgets/semicircles.dart';
import 'package:frontend/auth/presentation/widgets/switch_button.dart';
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

    return Scaffold(
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
                child: Container(
                  width:
                      sWidth * (ifMobile ? 0.95 : (ifDesktop ? 1 / 3 : 0.55)),
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
                              onTap: () {
                                context
                                    .read<AuthBloc>()
                                    .add(SelectDoctorAuthEvent());
                                _regIdFocusNode.requestFocus();
                              },
                            ),
                            SwitchButton(
                              label: 'User',
                              onTap: () {
                                context
                                    .read<AuthBloc>()
                                    .add(SelectUserAuthEvent());
                                _emailFocusNode.requestFocus();
                              },
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
                          onPressed: () => _requestForLogin(_formKey),
                        ),
                        const SizedBox(height: 5),
                        AuthPrompt.partial(
                          text: 'Don\'t have an account? ',
                          hyperText: 'Signup',
                          onTap: () {
                            context.canPop()
                                ? context.pop()
                                : context.pushNamed(RouteNames.signupOne);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _requestForLogin(GlobalKey<FormState> loginForm) {
  if (loginForm.currentState!.validate()) {
    developer.log(
      'LOGIN REQUEST VALIDATED SUCCESSFULLY...',
      time: DateTime.now(),
    );
  }
}
