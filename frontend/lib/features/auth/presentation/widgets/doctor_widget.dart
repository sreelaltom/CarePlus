import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';


class Doctor extends StatelessWidget {
  final String imagePath;
  final double? height;
  late final double? startBottom;
  late final double? endBottom;
  final double? right;
  final double? left;
  late final bool _isAnimated;
  late final double? bottom;

  Doctor.animated({
    super.key,
    required this.imagePath,
    required this.height,
    required this.startBottom,
    required this.endBottom,
    this.right,
    this.left,
  }) {
    _isAnimated = true;
    bottom = null;
  }

  Doctor.positioned({
    super.key,
    required this.imagePath,
    required this.height,
    required this.bottom,
    this.right,
    this.left,
  }) {
    _isAnimated = false;
    startBottom = null;
    endBottom = null;
  }

  @override
  Widget build(BuildContext context) {
    return _isAnimated
        ? BlocBuilder<AuthBloc, AuthState>(
            buildWhen: (previous, current) => previous is AuthInitial,
            builder: (context, state) {
              return AnimatedPositioned(
                right: right,
                left: left,
                bottom: state is AuthInitial ? startBottom : endBottom,
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOut,
                child: SizedBox(
                  height: height,
                  child: Image.asset(imagePath, height: height),
                ),
              );
            },
          )
        : Positioned(
            right: right,
            bottom: bottom,
            left: left,
            child: Image.asset(imagePath, height: height),
          );
  }
}
