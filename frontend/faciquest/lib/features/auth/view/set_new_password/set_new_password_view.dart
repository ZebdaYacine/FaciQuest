import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SetNewPasswordView extends StatelessWidget {
  const SetNewPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SetNewPasswordCubit(),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SetNewPasswordCubit>();
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
              BlocBuilder<SetNewPasswordCubit, SetNewPasswordState>(
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

class _ResetForm extends StatefulWidget {
  const _ResetForm();

  @override
  State<_ResetForm> createState() => __ResetFormState();
}

class __ResetFormState extends State<_ResetForm> with BuildFormMixin {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SetNewPasswordCubit>();
    return Column(
      children: [
        buildInputForm(
          'Password',
          true,
          onChange: (value) => cubit.setPassword(value),
        ),
        buildInputForm(
          'Confirm Password',
          true,
          onChange: (value) => cubit.setCPassword(value),
        ),
      ],
    );
  }
}
