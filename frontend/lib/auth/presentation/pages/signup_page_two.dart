import 'package:flutter/material.dart';
import 'package:frontend/auth/presentation/auth_validators.dart';
import 'package:frontend/auth/presentation/widgets/auth_button.dart';
import 'package:frontend/auth/presentation/widgets/auth_input.dart';
import 'package:frontend/auth/presentation/widgets/auth_prompt.dart';
import 'package:frontend/auth/presentation/widgets/password_field.dart';
import 'package:frontend/auth/presentation/widgets/semicircles.dart';
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
  late final String regId;
  late final String phone;
  late final String email;

  SignupPageTwo.doctor({super.key, required this.regId, required this.phone})
      : _ifDoctor = true;

  SignupPageTwo.user({super.key, required this.email, required this.phone})
      : _ifDoctor = false;

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
              Padding(
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
                        style:
                            Theme.of(context).textTheme.headlineLarge!.copyWith(
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
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: AppColors.white,
                          ),
                    ),
                    const Spacer(flex: 1),
                    Center(
                      child: Container(
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
                              AuthInput(
                                hintText: 'Fullname',
                                controller: _nameController,
                                focusNode: _nameFocusNode,
                                validator: (value) =>
                                    AuthValidators.validateName(value: value!),
                                onSubmit: (value) =>
                                    _passwordFocusNode.requestFocus(),
                              ),
                              const SizedBox(height: 10),
                              PasswordField(
                                  hintText: 'Password',
                                  controller: _passwordController,
                                  focusNode: _passwordFocusNode,
                                  visibility: _hidePassword),
                              const SizedBox(height: 10),
                              PasswordField(
                                hintText: 'Confirm Password',
                                controller: _confirmPasswordController,
                                focusNode: _confirmPasswordFocusNode,
                                visibility: _hideConfirmPassword,
                              ),
                              const SizedBox(height: 20),
                              AuthButton(
                                label: 'Signup',
                                onPressed: () => _requestForSignup(_formKey),
                              ),
                              const SizedBox(height: 5),
                              AuthPrompt.partial(
                                text: 'Already have an account? ',
                                hyperText: 'Signin',
                                onTap: () => context.goNamed(RouteNames.login),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _requestForSignup(GlobalKey<FormState> signupForm) {
  if (signupForm.currentState!.validate()) {
    developer.log(
      'SIGN UP REQUEST VALIDATED SUCCESSFULLY...',
      time: DateTime.now(),
    );
  }
}
