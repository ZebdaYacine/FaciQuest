import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

enum VerifyOtpFrom {
  forgotPassword,
  signUp,
  ;

  String get name => toString().split('.').last;
  ConfirmAccountReasons get toReason {
    switch (this) {
      case VerifyOtpFrom.forgotPassword:
        return ConfirmAccountReasons.resetPwd;
      case VerifyOtpFrom.signUp:
        return ConfirmAccountReasons.singUp;
    }
  }

  String get route => '/verify-otp/$name';
  static VerifyOtpFrom fromMap(String? from) {
    return VerifyOtpFrom.values.firstWhere(
      (element) => element.name == from,
      orElse: () => VerifyOtpFrom.signUp,
    );
  }
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
      create: (context) => VerifyOtpCubit(getIt(), reason: from.toReason),
      child: BlocListener<VerifyOtpCubit, VerifyOtpState>(
        listener: (context, state) {
          if (state.status.isSuccess) {
            switch (from) {
              case VerifyOtpFrom.forgotPassword:
                AppRoutes.setNewPassword.push(context);
                break;
              case VerifyOtpFrom.signUp:
                statusHandler(context, state.status, msg: state.msg);
                break;
            }
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
    final cubit = context.read<VerifyOtpCubit>();
    return Scaffold(
      appBar: AppBar(),
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
                  const SizedBox(height: 40),
                  Text(
                    'auth.verifyOtp.title'.tr(),
                    style: context.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  AppSpacing.spacing_1.heightBox,
                  Text(
                    'auth.verifyOtp.description'.tr(),
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  AppSpacing.spacing_4.heightBox,
                  const _Form(),
                  AppSpacing.spacing_4.heightBox,
                  BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
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
                            'auth.verifyOtp.submit'.tr(),
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

class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<VerifyOtpCubit>();
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: context.textTheme.titleLarge?.copyWith(
        color: context.colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colorScheme.outline.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );

    return Pinput(
      length: 6,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration?.copyWith(
          border: Border.all(color: context.colorScheme.primary, width: 2),
        ),
      ),
      onChanged: cubit.setOtp,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      separatorBuilder: (_) => AppSpacing.spacing_1.widthBox,
    );
  }
}
