import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/presentation/auth_validators.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:frontend/features/auth/presentation/widgets/auth_input.dart';

class EmailOrRegIdField extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController regIdController;

  final FocusNode emailFocusNode;
  final FocusNode regIdFocusNode;

  final ValueChanged<String>? onSubmit;

  const EmailOrRegIdField({
    super.key,
    required this.emailController,
    required this.regIdController,
    required this.emailFocusNode,
    required this.regIdFocusNode,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) =>
          (previous is AuthInitial && current is UserAuthState) ||
          (previous is UserAuthState && current is DoctorAuthState) ||
          (previous is DoctorAuthState && current is UserAuthState),
      builder: (context, state) {
        final ifUser = state is UserAuthState;
        return AuthInput(
          hintText: ifUser ? 'Email' : 'Registration ID',
          controller: ifUser ? emailController : regIdController,
          focusNode: ifUser ? emailFocusNode : regIdFocusNode,
          keyboardType:
              ifUser ? TextInputType.emailAddress : TextInputType.number,
          inputFormatters:
              !ifUser ? [FilteringTextInputFormatter.digitsOnly] : null,
          validator: (value) => ifUser
              ? AuthValidators.validateEmail(value: value!)
              : AuthValidators.validateRegId(value: value!),
          onSubmit: onSubmit,
        );
      },
    );
  }
}
