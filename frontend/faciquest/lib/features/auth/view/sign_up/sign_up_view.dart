import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(getIt()),
      child: BlocListener<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state.status.isSuccess) {
            statusHandler(context, state.status, msg: state.msg);
            AppRoutes.verifyOtp.push(
              context,
              pathParameters: {
                'from': VerifyOtpFrom.signUp.name,
              },
            );
          }

          statusHandler(
            context,
            state.status,
            msg: state.msg,
            handleSuccess: false,
          );
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
    final cubit = context.read<SignUpCubit>();
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: AppSpacing.spacing_2.padding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Account',
                style: context.textTheme.headlineLarge,
              ),
              AppSpacing.spacing_1.heightBox,

              Row(
                children: [
                  Text(
                    'Already a member?',
                    style: context.textTheme.bodyLarge,
                  ),
                  AppSpacing.spacing_1.widthBox,
                  GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationThickness: 1,
                      ),
                    ),
                  ),
                ],
              ),
              AppSpacing.spacing_2.heightBox,
              const _SignUpForm(),
              AppSpacing.spacing_2.heightBox,
              Row(
                children: [
                  BlocBuilder<SignUpCubit, SignUpState>(
                    buildWhen: (previous, current) =>
                        previous.agreeToTerms != current.agreeToTerms,
                    builder: (context, state) {
                      return Checkbox(
                        value: state.agreeToTerms,
                        onChanged: cubit.onAgreeToTermsChanged,
                      );
                    },
                  ),
                  // AppSpacing.spacing_1.widthBox,
                  const Text('I agree to the'),
                  AppSpacing.spacing_1.widthBox,
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Terms & Conditions',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationThickness: 1,
                      ),
                    ),
                  ),
                ],
              ),
              AppSpacing.spacing_2.heightBox,
              BlocBuilder<SignUpCubit, SignUpState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state.isValid ? cubit.submit : null,
                    child: const Center(child: Text('Sign Up')),
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

class _SignUpForm extends StatefulWidget {
  const _SignUpForm();

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<_SignUpForm> with BuildFormMixin {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignUpCubit>();
    return Column(
      children: [
        buildInputForm('Username', false, onChange: cubit.onUsernameChanged),
        buildInputForm('First Name', false, onChange: cubit.onFirstNameChanged),
        buildInputForm('Last Name', false, onChange: cubit.onLastNameChanged),
        buildInputForm('Email', false, onChange: cubit.onEmailChanged),
        buildInputForm('Phone', false, onChange: cubit.onPhoneChanged),
        buildInputForm('Password', true, onChange: cubit.onPasswordChanged),
        buildInputForm(
          'Confirm Password',
          true,
          onChange: cubit.onCPasswordChanged,
        ),
      ],
    );
  }
}
