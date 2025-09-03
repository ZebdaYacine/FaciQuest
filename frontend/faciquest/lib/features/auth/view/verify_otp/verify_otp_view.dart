import 'dart:async';
import 'dart:math';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class VerifyOtpView extends StatefulWidget {
  const VerifyOtpView({
    super.key,
    this.from = VerifyOtpFrom.signUp,
  });
  final VerifyOtpFrom from;

  @override
  State<VerifyOtpView> createState() => _VerifyOtpViewState();
}

class _VerifyOtpViewState extends State<VerifyOtpView> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerifyOtpCubit(getIt(), reason: widget.from.toReason),
      child: BlocListener<VerifyOtpCubit, VerifyOtpState>(
        listener: (context, state) {
          if (state.status.isSuccess) {
            switch (widget.from) {
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
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: _Body(from: widget.from),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.from});
  final VerifyOtpFrom from;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.colorScheme.primary.withOpacity(0.08),
              context.colorScheme.surface,
              context.colorScheme.primary.withOpacity(0.05),
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: AppSpacing.spacing_4.padding,
            child: Column(
              children: [
                // Header with back button
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: context.colorScheme.surface.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: context.colorScheme.outline.withOpacity(0.1),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: context.colorScheme.shadow.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 60),

                        // Illustration section
                        _IllustrationSection(),

                        const SizedBox(height: 40),

                        // Content section
                        _ContentSection(from: from),

                        const SizedBox(height: 40),

                        // OTP Form
                        const _Form(),

                        const SizedBox(height: 32),

                        // Submit button
                        _SubmitButton(),

                        const SizedBox(height: 24),

                        // Resend section
                        _ResendSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IllustrationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        color: context.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(60),
        border: Border.all(
          color: context.colorScheme.primary.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Icon(
        Icons.sms_outlined,
        size: 48,
        color: context.colorScheme.primary,
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  const _ContentSection({required this.from});
  final VerifyOtpFrom from;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'auth.verifyOtp.title'.tr(),
          textAlign: TextAlign.center,
          style: context.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.primary,
            fontSize: 28,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            from == VerifyOtpFrom.forgotPassword
                ? 'auth.verifyOtp.descriptionReset'.tr()
                : 'auth.verifyOtp.description'.tr(),
            textAlign: TextAlign.center,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.onSurface.withOpacity(0.7),
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Info banner
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: context.colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: context.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'auth.verifyOtp.codeInfo'.tr(),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<VerifyOtpCubit>();
    return BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: state.isValid
                ? [
                    BoxShadow(
                      color: context.colorScheme.primary.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: ElevatedButton.icon(
            onPressed: state.isValid
                ? () {
                    HapticFeedback.mediumImpact();
                    cubit.submit();
                  }
                : null,
            icon: state.status.isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: context.colorScheme.onPrimary,
                    ),
                  )
                : Icon(
                    Icons.verified_rounded,
                    color:
                        state.isValid ? context.colorScheme.onPrimary : context.colorScheme.onSurface.withOpacity(0.4),
                  ),
            label: Text(
              'auth.verifyOtp.submit'.tr(),
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: state.isValid ? context.colorScheme.onPrimary : context.colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.primary,
              foregroundColor: context.colorScheme.onPrimary,
              disabledBackgroundColor: context.colorScheme.outline.withOpacity(0.2),
              disabledForegroundColor: context.colorScheme.onSurface.withOpacity(0.4),
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: state.isValid ? 6 : 0,
            ),
          ),
        );
      },
    );
  }
}

class _ResendSection extends StatefulWidget {
  @override
  State<_ResendSection> createState() => _ResendSectionState();
}

class _ResendSectionState extends State<_ResendSection> {
  Timer? _timer;
  int _secondsRemaining = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _canResend = false;
    _secondsRemaining = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  void _resendCode() {
    HapticFeedback.lightImpact();
    // TODO: Implement resend functionality
    _startTimer();
    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('auth.verifyOtp.codeSent'.tr()),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colorScheme.surface.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.colorScheme.outline.withOpacity(0.1),
          ),
        ),
        child: Column(
          children: [
            Text(
              'auth.verifyOtp.didntReceive'.tr(),
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            if (_canResend)
              GestureDetector(
                onTap: _resendCode,
                child: Text(
                  'auth.verifyOtp.resendCode'.tr(),
                  style: TextStyle(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2,
                  ),
                ),
              )
            else
              Text(
                '${'auth.verifyOtp.resendIn'.tr()} ${_secondsRemaining}s',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
          ],
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

class _FormState extends State<_Form> with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _shakeOnError() {
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<VerifyOtpCubit>();

    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: context.textTheme.headlineSmall?.copyWith(
        color: context.colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.colorScheme.outline.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.primary.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: context.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(
          color: context.colorScheme.primary,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: context.colorScheme.primary.withOpacity(0.1),
        border: Border.all(
          color: context.colorScheme.primary,
          width: 2,
        ),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(
          color: Colors.red,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
    );

    return BlocListener<VerifyOtpCubit, VerifyOtpState>(
      listenWhen: (previous, current) => previous.status != current.status && current.status.isFailure,
      listener: (context, state) {
        _shakeOnError();
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.primary.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: context.colorScheme.shadow.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: context.colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              'auth.verifyOtp.enterCode'.tr(),
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) {
                final offset = sin(_shakeAnimation.value * pi * 2) * 3;
                return Transform.translate(
                  offset: Offset(offset, 0),
                  child: Pinput(
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    errorPinTheme: errorPinTheme,
                    onChanged: (value) {
                      HapticFeedback.lightImpact();
                      cubit.setOtp(value);
                    },
                    onCompleted: (value) {
                      HapticFeedback.mediumImpact();
                      cubit.setOtp(value);
                    },
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    separatorBuilder: (_) => const SizedBox(width: 12),
                    cursor: Container(
                      width: 2,
                      height: 24,
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
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
