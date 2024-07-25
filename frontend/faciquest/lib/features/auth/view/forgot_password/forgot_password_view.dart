import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(getIt()),
      child: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state.status.isSuccess) {
            AppRoutes.verifyOtp.push(context);
          }
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
    final cubit = context.read<ForgotPasswordCubit>();
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: AppSpacing.spacing_2.padding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reset Password',
                style: context.textTheme.headlineLarge,
              ),
              AppSpacing.spacing_1.heightBox,
              Text(
                'Please enter your email address',
                style: context.textTheme.bodyLarge,
              ),
              AppSpacing.spacing_2.heightBox,
              const _ResetForm(),
              AppSpacing.spacing_2.heightBox,
              BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state.isValid ? cubit.submit : null,
                    child: const Center(child: Text('Reset Password')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResetForm extends StatelessWidget {
  const _ResetForm();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgotPasswordCubit>();
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        onChanged: cubit.onEmailChanged,
        decoration: const InputDecoration(
            hintText: 'Email',
            hintStyle: TextStyle(color: kTextFieldColor),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor))),
      ),
    );
  }
}
