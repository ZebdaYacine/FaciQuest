import 'dart:async';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

enum VerifyOtpFrom {
  forgotPassword,
  signUp;

  ConfirmAccountReasons get toReason => switch (this) {
        VerifyOtpFrom.forgotPassword => ConfirmAccountReasons.resetPwd,
        VerifyOtpFrom.signUp => ConfirmAccountReasons.singUp,
      };

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
              case VerifyOtpFrom.signUp:
                statusHandler(context, state.status, msg: state.msg);
            }
          }
          statusHandler(
            context,
            state.status,
            msg: state.msg,
            handleSuccess: false,
          );
        },
        child: AuthPageScaffold(
          title: 'auth.verifyOtp.title'.tr(),
          description: from == VerifyOtpFrom.forgotPassword
              ? 'auth.verifyOtp.descriptionReset'.tr()
              : 'auth.verifyOtp.description'.tr(),
          icon: Icons.sms_outlined,
          information: AuthInfoPanel(text: 'auth.verifyOtp.codeInfo'.tr()),
          footer: const _ResendSection(),
          child: const Column(
            children: [
              _OtpForm(),
              SizedBox(height: 20),
              _SubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpForm extends StatelessWidget {
  const _OtpForm();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<VerifyOtpCubit>();
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'auth.verifyOtp.enterCode'.tr(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                const spacing = 8.0;
                final pinWidth = ((constraints.maxWidth - spacing * 5) / 6)
                    .clamp(40.0, 56.0);
                final pinTheme = PinTheme(
                  width: pinWidth,
                  height: 56,
                  textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: scheme.primary,
                      ),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: scheme.outlineVariant),
                  ),
                );
                return Directionality(
                  textDirection: ui.TextDirection.ltr,
                  child: Pinput(
                    length: 6,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    defaultPinTheme: pinTheme,
                    focusedPinTheme: pinTheme.copyWith(
                      decoration: pinTheme.decoration?.copyWith(
                        border: Border.all(color: scheme.primary, width: 2),
                      ),
                    ),
                    submittedPinTheme: pinTheme.copyWith(
                      decoration: pinTheme.decoration?.copyWith(
                        color: scheme.primaryContainer,
                        border: Border.all(color: scheme.primary),
                      ),
                    ),
                    separatorBuilder: (_) => const SizedBox(width: spacing),
                    onChanged: cubit.setOtp,
                    onCompleted: cubit.setOtp,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
      buildWhen: (previous, current) =>
          previous.isValid != current.isValid ||
          previous.status != current.status,
      builder: (context, state) {
        final loading = state.status.isLoading;
        return SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: state.isValid && !loading
                ? () {
                    HapticFeedback.mediumImpact();
                    context.read<VerifyOtpCubit>().submit();
                  }
                : null,
            icon: loading
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.verified_rounded),
            label: Text('auth.verifyOtp.submit'.tr()),
          ),
        );
      },
    );
  }
}

class _ResendSection extends StatefulWidget {
  const _ResendSection();

  @override
  State<_ResendSection> createState() => _ResendSectionState();
}

class _ResendSectionState extends State<_ResendSection> {
  Timer? _timer;
  int _secondsRemaining = 60;

  bool get _canResend => _secondsRemaining == 0;

  @override
  void initState() {
    super.initState();
    _startTimer(notify: false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer({bool notify = true}) {
    _timer?.cancel();
    _secondsRemaining = 60;
    if (notify && mounted) setState(() {});
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _secondsRemaining--);
      if (_secondsRemaining == 0) timer.cancel();
    });
  }

  void _resendCode() {
    HapticFeedback.lightImpact();
    _startTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('auth.verifyOtp.codeSent'.tr())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'auth.verifyOtp.didntReceive'.tr(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
        ),
        if (_canResend)
          TextButton(
            onPressed: _resendCode,
            child: Text('auth.verifyOtp.resendCode'.tr()),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text(
              '${'auth.verifyOtp.resendIn'.tr()} ${_secondsRemaining}s',
              semanticsLabel:
                  '${'auth.verifyOtp.resendIn'.tr()} $_secondsRemaining',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
      ],
    );
  }
}
