import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/presentation/auth_validators.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:frontend/features/auth/presentation/widgets/auth_button.dart';
import 'package:frontend/features/auth/presentation/widgets/auth_input.dart';
import 'package:frontend/features/auth/presentation/widgets/auth_prompt.dart';
import 'package:frontend/features/auth/presentation/widgets/email_reg_field.dart';
import 'package:frontend/features/auth/presentation/widgets/semicircles.dart';
import 'package:frontend/features/auth/presentation/widgets/switch_button.dart';
import 'package:frontend/core/config/responsive.dart';
import 'package:frontend/core/routes/route_constants.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer' as developer;

class SignupPageOne extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _regIdController = TextEditingController();
  final _regIdFocusNode = FocusNode();
  final _phoneController = TextEditingController();
  final _phoneFocusNode = FocusNode();

  SignupPageOne({super.key});

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
                          onSubmit: (value) => _phoneFocusNode.requestFocus(),
                        ),
                        const SizedBox(height: 10),
                        AuthInput(
                          hintText: 'Phone',
                          controller: _phoneController,
                          focusNode: _phoneFocusNode,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) =>
                              AuthValidators.validatePhone(value: value!),
                          onSubmit: (value) => _continueSignupProcess(
                            context,
                            _formKey,
                            credentials: {
                              'regId': _regIdController.text.trim(),
                              'email': _emailController.text.trim(),
                              'phone': _phoneController.text.trim(),
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        AuthButton(
                          label: 'Continue',
                          onPressed: () => _continueSignupProcess(
                            context,
                            _formKey,
                            credentials: {
                              'regId': _regIdController.text.trim(),
                              'email': _emailController.text.trim(),
                              'phone': _phoneController.text.trim(),
                            },
                          ),
                        ),
                        const SizedBox(height: 5),
                        AuthPrompt.partial(
                          text: 'Already have an account? ',
                          hyperText: 'Signin',
                          onTap: () {
                            context.canPop()
                                ? context.pop()
                                : context.pushNamed(RouteNames.login);
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

void _continueSignupProcess(
  BuildContext context,
  GlobalKey<FormState> signupFormOne, {
  required Map<String, String> credentials,
}) {
  if (signupFormOne.currentState!.validate()) {
    developer.log('SIGN UP STAGE ONE VALIDATED...', time: DateTime.now());
    final ifDoctor = context.read<AuthBloc>().state is DoctorAuthState;
    context.pushNamed(
      ifDoctor ? RouteNames.signupTwoDoctor : RouteNames.signupTwoUser,
      pathParameters: {
        'phone': credentials['phone']!,
        if (ifDoctor)
          'regId': credentials['regId']!
        else
          'email': credentials['email']!,
      },
    );
  }
}
