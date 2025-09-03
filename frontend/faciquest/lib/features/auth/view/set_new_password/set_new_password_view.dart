import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SetNewPasswordView extends StatefulWidget {
  const SetNewPasswordView({super.key});

  @override
  State<SetNewPasswordView> createState() => _SetNewPasswordViewState();
}

class _SetNewPasswordViewState extends State<SetNewPasswordView> with TickerProviderStateMixin {
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
      create: (context) => SetNewPasswordCubit(getIt()),
      child: BlocListener<SetNewPasswordCubit, SetNewPasswordState>(
        listener: (context, state) {
          statusHandler(context, state.status ?? Status.initial, msg: state.msg);
        },
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: const _Body(),
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

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
                        _ContentSection(),

                        const SizedBox(height: 40),

                        // Form section
                        const _ResetForm(),

                        const SizedBox(height: 32),

                        // Submit button
                        _SubmitButton(),

                        const SizedBox(height: 24),

                        // Success tips
                        _SecurityTipsSection(),
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
        Icons.security_rounded,
        size: 48,
        color: context.colorScheme.primary,
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'auth.setNewPassword.title'.tr(),
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
            'auth.setNewPassword.description'.tr(),
            textAlign: TextAlign.center,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.onSurface.withOpacity(0.7),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SetNewPasswordCubit>();
    return BlocBuilder<SetNewPasswordCubit, SetNewPasswordState>(
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
            icon: state.status == Status.showLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: context.colorScheme.onPrimary,
                    ),
                  )
                : Icon(
                    Icons.shield_rounded,
                    color:
                        state.isValid ? context.colorScheme.onPrimary : context.colorScheme.onSurface.withOpacity(0.4),
                  ),
            label: Text(
              'auth.setNewPassword.submit'.tr(),
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

class _SecurityTipsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tips = [
      {
        'icon': Icons.security_rounded,
        'text': 'auth.setNewPassword.tip1'.tr(),
      },
      {
        'icon': Icons.security_rounded,
        'text': 'auth.setNewPassword.tip2'.tr(),
      },
      {
        'icon': Icons.visibility_off_rounded,
        'text': 'auth.setNewPassword.tip3'.tr(),
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colorScheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tips_and_updates_rounded,
                color: context.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'auth.setNewPassword.securityTips'.tr(),
                style: context.textTheme.titleSmall?.copyWith(
                  color: context.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...tips.map((tip) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    tip['icon'] as IconData,
                    color: context.colorScheme.primary.withOpacity(0.7),
                    size: 16,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tip['text'] as String,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ResetForm extends StatefulWidget {
  const _ResetForm();

  @override
  State<_ResetForm> createState() => __ResetFormState();
}

class __ResetFormState extends State<_ResetForm> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  PasswordStrength _getPasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.none;

    int score = 0;

    // Length check
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;

    // Character variety checks
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  Color _getStrengthColor(PasswordStrength strength, BuildContext context) {
    switch (strength) {
      case PasswordStrength.none:
        return context.colorScheme.outline.withOpacity(0.3);
      case PasswordStrength.weak:
        return Colors.red;
      case PasswordStrength.medium:
        return Colors.orange;
      case PasswordStrength.strong:
        return Colors.green;
    }
  }

  String _getStrengthText(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.none:
        return '';
      case PasswordStrength.weak:
        return 'auth.setNewPassword.weak'.tr();
      case PasswordStrength.medium:
        return 'auth.setNewPassword.medium'.tr();
      case PasswordStrength.strong:
        return 'auth.setNewPassword.strong'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SetNewPasswordCubit>();
    return Container(
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
      child: BlocBuilder<SetNewPasswordCubit, SetNewPasswordState>(
        builder: (context, state) {
          final passwordStrength = _getPasswordStrength(state.password ?? '');
          final passwordsMatch = state.password != null &&
              state.cPassword != null &&
              state.password == state.cPassword &&
              state.password!.isNotEmpty;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Password field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'auth.setNewPassword.password'.tr(),
                  hintText: 'Enter a strong password',
                  prefixIcon: Icon(
                    Icons.lock_outline_rounded,
                    color: context.colorScheme.primary,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: context.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: context.colorScheme.outline.withOpacity(0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: context.colorScheme.outline.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: context.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  filled: true,
                  fillColor: context.colorScheme.surface.withOpacity(0.8),
                ),
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.next,
                onChanged: cubit.setPassword,
              ),

              // Password strength indicator
              if ((state.password?.isNotEmpty ?? false))
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: context.colorScheme.outline.withOpacity(0.2),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: passwordStrength == PasswordStrength.none
                                    ? 0.0
                                    : passwordStrength == PasswordStrength.weak
                                        ? 0.33
                                        : passwordStrength == PasswordStrength.medium
                                            ? 0.66
                                            : 1.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: _getStrengthColor(passwordStrength, context),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _getStrengthText(passwordStrength),
                            style: context.textTheme.bodySmall?.copyWith(
                              color: _getStrengthColor(passwordStrength, context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              // Confirm password field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'auth.setNewPassword.confirmPassword'.tr(),
                  hintText: 'Confirm your password',
                  prefixIcon: Icon(
                    Icons.lock_reset_rounded,
                    color: context.colorScheme.primary,
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (state.cPassword != null && state.cPassword!.isNotEmpty)
                        Icon(
                          passwordsMatch ? Icons.check_circle_outline_rounded : Icons.error_outline_rounded,
                          color: passwordsMatch ? Colors.green : Colors.red,
                          size: 20,
                        ),
                      IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: context.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                        },
                      ),
                    ],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: context.colorScheme.outline.withOpacity(0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: context.colorScheme.outline.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: context.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  filled: true,
                  fillColor: context.colorScheme.surface.withOpacity(0.8),
                ),
                obscureText: _obscureConfirmPassword,
                textInputAction: TextInputAction.done,
                onChanged: cubit.setCPassword,
                onFieldSubmitted: (_) {
                  if (state.isValid) {
                    cubit.submit();
                  }
                },
              ),

              // Password match feedback
              if (state.cPassword != null && state.cPassword!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Icon(
                        passwordsMatch ? Icons.check_circle_outline_rounded : Icons.error_outline_rounded,
                        color: passwordsMatch ? Colors.green : Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        passwordsMatch
                            ? 'auth.setNewPassword.passwordsMatch'.tr()
                            : 'auth.setNewPassword.passwordsDontMatch'.tr(),
                        style: context.textTheme.bodySmall?.copyWith(
                          color: passwordsMatch ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

enum PasswordStrength {
  none,
  weak,
  medium,
  strong,
}
