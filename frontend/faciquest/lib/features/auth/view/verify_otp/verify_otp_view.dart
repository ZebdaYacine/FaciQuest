import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

enum VerifyOtpFrom {
  forgotPassword,
  signUp,
}

class VerifyOtpView extends StatelessWidget {
  const VerifyOtpView({
    super.key,
    this.from = VerifyOtpFrom.signUp,
  });
  final VerifyOtpFrom from;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerifyOtpCubit(getIt()),
      child: BlocListener<VerifyOtpCubit, VerifyOtpState>(
        listener: (context, state) {
          if (state.status.isSuccess) {
            switch (from) {
              case VerifyOtpFrom.forgotPassword:
                AppRoutes.setNewPassword.push(context);
                break;
              case VerifyOtpFrom.signUp:
                statusHandler(context, state.status, msg: state.msg);
              // TODO: To discuss go directly to home page or return to sign in page
            }
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
    final cubit = context.read<VerifyOtpCubit>();
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: AppSpacing.spacing_2.padding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verify OTP',
                style: context.textTheme.headlineLarge,
              ),
              AppSpacing.spacing_1.heightBox,
              Text(
                'Please enter your OTP sent to your email',
                style: context.textTheme.bodyLarge,
              ),
              AppSpacing.spacing_2.heightBox,
              const _Form(),
              AppSpacing.spacing_2.heightBox,
              BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state.isValid ? cubit.submit : null,
                    child: const Center(child: Text('verify')),
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

class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<VerifyOtpCubit>();
    return Pinput(
      length: 6,
      onChanged: cubit.setOtp,
    );
  }
}
