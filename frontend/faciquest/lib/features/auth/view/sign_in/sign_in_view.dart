import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(getIt()),
      child: BlocListener<SignInCubit, SignInState>(
        listener: (context, state) {
          statusHandler(context, state.status, msg: state.msg);
        },
        child: const _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignInCubit>();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              context.colorScheme.surface,
              context.colorScheme.surface.withOpacity(0.95),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: AppSpacing.spacing_3.padding,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  Text(
                    'Welcome Back',
                    style: context.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  AppSpacing.spacing_1.heightBox,
                  Row(
                    children: [
                      Text(
                        'New to this app?',
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: context.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      AppSpacing.spacing_1.widthBox,
                      GestureDetector(
                        onTap: () {
                          AppRoutes.signUp.push(context);
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: context.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationThickness: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.spacing_4.heightBox,
                  const _LogInForm(),
                  AppSpacing.spacing_3.heightBox,
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        AppRoutes.forgotPassword.push(context);
                      },
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: context.colorScheme.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          decorationThickness: 1.5,
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.spacing_4.heightBox,
                  BlocBuilder<SignInCubit, SignInState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state.isValid ? cubit.submit : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colorScheme.primary,
                          foregroundColor: context.colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Login',
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogInForm extends StatefulWidget {
  const _LogInForm();

  @override
  _LogInFormState createState() => _LogInFormState();
}

class _LogInFormState extends State<_LogInForm> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignInCubit>();
    return Container(
      padding: AppSpacing.spacing_3.padding,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: (value) => cubit.onEmailChanged(value),
          ),
          AppSpacing.spacing_2.heightBox,
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.visibility_off),
                onPressed: () {
                  // Toggle password visibility
                },
              ),
            ),
            obscureText: true,
            onChanged: (value) => cubit.onPasswordChanged(value),
          ),
        ],
      ),
    );
  }
}
