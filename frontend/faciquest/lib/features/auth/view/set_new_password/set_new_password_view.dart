import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SetNewPasswordView extends StatelessWidget {
  const SetNewPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SetNewPasswordCubit(getIt()),
      child: BlocListener<SetNewPasswordCubit, SetNewPasswordState>(
        listener: (context, state) {
          statusHandler(
            context,
            state.status ?? Status.initial,
            msg: state.msg,
          );
          if (state.status == Status.success) {
            context.goNamed(AppRoutes.signIn.name);
          }
        },
        child: AuthPageScaffold(
          title: 'auth.setNewPassword.title'.tr(),
          description: 'auth.setNewPassword.description'.tr(),
          icon: Icons.password_rounded,
          child: const Column(
            children: [
              _PasswordForm(),
              SizedBox(height: 16),
              _SecurityTips(),
              SizedBox(height: 20),
              _SubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasswordForm extends StatefulWidget {
  const _PasswordForm();

  @override
  State<_PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<_PasswordForm> {
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SetNewPasswordCubit>();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: AutofillGroup(
          child: BlocBuilder<SetNewPasswordCubit, SetNewPasswordState>(
            builder: (context, state) {
              final password = state.password ?? '';
              final confirmation = state.cPassword ?? '';
              final strength = _PasswordStrength.from(password);
              final mismatch =
                  confirmation.isNotEmpty && password != confirmation;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    autofillHints: const [AutofillHints.newPassword],
                    decoration: InputDecoration(
                      labelText: 'auth.setNewPassword.password'.tr(),
                      hintText: 'auth.setNewPassword.passwordHint'.tr(),
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      errorText: password.isNotEmpty && password.length < 8
                          ? 'auth.validation.passwordMin'.tr()
                          : null,
                      suffixIcon: IconButton(
                        tooltip: _obscurePassword
                            ? 'auth.signIn.showPassword'.tr()
                            : 'auth.signIn.hidePassword'.tr(),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    onChanged: cubit.setPassword,
                  ),
                  if (password.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Semantics(
                      label: 'auth.setNewPassword.securityTips'.tr(),
                      value: strength.label,
                      child: Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: strength.progress,
                              minHeight: 6,
                              borderRadius: BorderRadius.circular(3),
                              color: strength.color(context),
                              backgroundColor:
                                  context.colorScheme.surfaceContainerHighest,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            strength.label,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: strength.color(context),
                                      fontWeight: FontWeight.w700,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  TextFormField(
                    autofillHints: const [AutofillHints.newPassword],
                    decoration: InputDecoration(
                      labelText: 'auth.setNewPassword.confirmPassword'.tr(),
                      hintText: 'auth.setNewPassword.confirmPasswordHint'.tr(),
                      prefixIcon: const Icon(Icons.lock_reset_rounded),
                      errorText: mismatch
                          ? 'auth.validation.passwordsDontMatch'.tr()
                          : null,
                      suffixIcon: IconButton(
                        tooltip: _obscureConfirmation
                            ? 'auth.signIn.showPassword'.tr()
                            : 'auth.signIn.hidePassword'.tr(),
                        onPressed: () => setState(
                          () => _obscureConfirmation = !_obscureConfirmation,
                        ),
                        icon: Icon(
                          _obscureConfirmation
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),
                    obscureText: _obscureConfirmation,
                    textInputAction: TextInputAction.done,
                    onChanged: cubit.setCPassword,
                    onFieldSubmitted: (_) {
                      if (state.isValid && state.status != Status.showLoading) {
                        TextInput.finishAutofillContext();
                        cubit.submit();
                      }
                    },
                  ),
                  if (confirmation.isNotEmpty && !mismatch) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          size: 18,
                          color: context.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'auth.setNewPassword.passwordsMatch'.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: context.colorScheme.primary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SecurityTips extends StatelessWidget {
  const _SecurityTips();

  @override
  Widget build(BuildContext context) {
    final tips = [
      'auth.setNewPassword.tip1'.tr(),
      'auth.setNewPassword.tip2'.tr(),
      'auth.setNewPassword.tip3'.tr(),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.tips_and_updates_outlined,
                  color: context.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'auth.setNewPassword.securityTips'.tr(),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            for (final tip in tips)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: context.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tip,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ),
                  ],
                ),
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
    return BlocBuilder<SetNewPasswordCubit, SetNewPasswordState>(
      buildWhen: (previous, current) =>
          previous.isValid != current.isValid ||
          previous.status != current.status,
      builder: (context, state) {
        final loading = state.status == Status.showLoading;
        return SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: state.isValid && !loading
                ? () {
                    HapticFeedback.mediumImpact();
                    TextInput.finishAutofillContext();
                    context.read<SetNewPasswordCubit>().submit();
                  }
                : null,
            icon: loading
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.shield_rounded),
            label: Text('auth.setNewPassword.submit'.tr()),
          ),
        );
      },
    );
  }
}

enum _PasswordStrength {
  none,
  weak,
  medium,
  strong;

  static _PasswordStrength from(String password) {
    if (password.isEmpty) return none;
    var score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (password.contains(RegExp('[a-z]')) &&
        password.contains(RegExp('[A-Z]'))) {
      score++;
    }
    if (password.contains(RegExp('[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;
    if (score <= 2) return weak;
    if (score <= 4) return medium;
    return strong;
  }

  double get progress => switch (this) {
        none => 0,
        weak => 0.33,
        medium => 0.66,
        strong => 1,
      };

  String get label => switch (this) {
        none => '',
        weak => 'auth.setNewPassword.weak'.tr(),
        medium => 'auth.setNewPassword.medium'.tr(),
        strong => 'auth.setNewPassword.strong'.tr(),
      };

  Color color(BuildContext context) => switch (this) {
        none => context.colorScheme.outline,
        weak => context.colorScheme.error,
        medium => context.colorScheme.tertiary,
        strong => context.colorScheme.primary,
      };
}
