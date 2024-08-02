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
      body: Padding(
        padding: AppSpacing.spacing_2.padding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 120,
              ),
              Text(
                'Welcome Back',
                style: context.textTheme.headlineLarge,
              ),
              AppSpacing.spacing_1.heightBox,

              Row(
                children: [
                  Text(
                    'New to this app?',
                    style: context.textTheme.bodyLarge,
                  ),
                  AppSpacing.spacing_1.widthBox,
                  GestureDetector(
                    onTap: () {
                      AppRoutes.signUp.push(context);
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationThickness: 1,
                      ),
                    ),
                  ),
                ],
              ),
              AppSpacing.spacing_2.heightBox,

              const _LogInForm(),
              AppSpacing.spacing_2.heightBox,
              GestureDetector(
                onTap: () {
                  AppRoutes.forgotPassword.push(context);
                },
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: kZambeziColor,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    decorationThickness: 1,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              BlocBuilder<SignInCubit, SignInState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state.isValid ? cubit.submit : null,
                    child: const Center(child: Text('Login')),
                  );
                },
              ),
              // const SizedBox(
              //   height: 20,
              // ),
              // const Text(
              //   'Or log in with:',
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              // LoginOption(),
            ],
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

class _LogInFormState extends State<_LogInForm> with BuildFormMixin {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignInCubit>();
    return Column(
      children: [
        buildInputForm(
          'Email',
          onChange: (value) => cubit.onEmailChanged(value),
        ),
        buildInputForm(
          'Password',
          pass: true,
          onChange: (value) => cubit.onPasswordChanged(value),
        ),
      ],
    );
  }
}
