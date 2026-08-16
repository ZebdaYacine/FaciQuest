import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              pathParameters: {'from': VerifyOtpFrom.signUp.name},
            );
          }
          statusHandler(
            context,
            state.status,
            msg: state.msg,
            handleSuccess: false,
          );
        },
        child: AuthPageScaffold(
          title: 'auth.signUp.title'.tr(),
          description: 'auth.signUp.subtitle'.tr(),
          icon: Icons.person_add_alt_1_rounded,
          footer: const _SignInPrompt(),
          child: const Column(
            children: [
              _SignUpForm(),
              SizedBox(height: 16),
              _TermsSection(),
              SizedBox(height: 20),
              _SubmitButton(),
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
  State<_SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<_SignUpForm> {
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignUpCubit>();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: AutofillGroup(
          child: Column(
            children: [
              TextFormField(
                autofillHints: const [AutofillHints.newUsername],
                decoration: InputDecoration(
                  labelText: 'auth.signUp.username'.tr(),
                  hintText: 'auth.signUp.usernameHint'.tr(),
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                ),
                textInputAction: TextInputAction.next,
                onChanged: cubit.onUsernameChanged,
              ),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final firstName = _NameField(
                    label: 'auth.signUp.firstName'.tr(),
                    hint: 'auth.signUp.firstNameHint'.tr(),
                    autofillHint: AutofillHints.givenName,
                    onChanged: cubit.onFirstNameChanged,
                    prefixIcon: Icons.badge_outlined,
                  );
                  final lastName = _NameField(
                    label: 'auth.signUp.lastName'.tr(),
                    hint: 'auth.signUp.lastNameHint'.tr(),
                    autofillHint: AutofillHints.familyName,
                    onChanged: cubit.onLastNameChanged,
                  );
                  if (constraints.maxWidth < 520) {
                    return Column(
                      children: [
                        firstName,
                        const SizedBox(height: 16),
                        lastName,
                      ],
                    );
                  }
                  return Row(
                    children: [
                      Expanded(child: firstName),
                      const SizedBox(width: 16),
                      Expanded(child: lastName),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<SignUpCubit, SignUpState>(
                buildWhen: (previous, current) =>
                    previous.emailError != current.emailError,
                builder: (context, state) {
                  return TextFormField(
                    autofillHints: const [AutofillHints.email],
                    decoration: InputDecoration(
                      labelText: 'auth.signUp.email'.tr(),
                      hintText: 'auth.signUp.emailHint'.tr(),
                      prefixIcon: const Icon(Icons.email_outlined),
                      errorText: state.emailError?.tr(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onChanged: cubit.onEmailChanged,
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<SignUpCubit, SignUpState>(
                buildWhen: (previous, current) =>
                    previous.phoneError != current.phoneError,
                builder: (context, state) {
                  return TextFormField(
                    autofillHints: const [AutofillHints.telephoneNumber],
                    decoration: InputDecoration(
                      labelText: 'auth.signUp.phone'.tr(),
                      hintText: 'auth.signUp.phoneHint'.tr(),
                      prefixIcon: const Icon(Icons.phone_outlined),
                      errorText: state.phoneError?.tr(),
                    ),
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    onChanged: cubit.onPhoneChanged,
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<SignUpCubit, SignUpState>(
                buildWhen: (previous, current) =>
                    previous.user.password != current.user.password,
                builder: (context, state) {
                  final password = state.user.password;
                  return TextFormField(
                    autofillHints: const [AutofillHints.newPassword],
                    decoration: InputDecoration(
                      labelText: 'auth.signUp.password'.tr(),
                      hintText: 'auth.signUp.passwordHint'.tr(),
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
                    onChanged: cubit.onPasswordChanged,
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<SignUpCubit, SignUpState>(
                buildWhen: (previous, current) =>
                    previous.cPassword != current.cPassword ||
                    previous.user.password != current.user.password,
                builder: (context, state) {
                  final mismatch = state.cPassword.isNotEmpty &&
                      state.user.password != state.cPassword;
                  return TextFormField(
                    autofillHints: const [AutofillHints.newPassword],
                    decoration: InputDecoration(
                      labelText: 'auth.signUp.confirmPassword'.tr(),
                      hintText: 'auth.signUp.confirmPasswordHint'.tr(),
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
                    onChanged: cubit.onCPasswordChanged,
                    onFieldSubmitted: (_) {
                      if (context.read<SignUpCubit>().state.isValid) {
                        TextInput.finishAutofillContext();
                        cubit.submit();
                      }
                    },
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

class _NameField extends StatelessWidget {
  const _NameField({
    required this.label,
    required this.hint,
    required this.autofillHint,
    required this.onChanged,
    this.prefixIcon,
  });

  final String label;
  final String hint;
  final String autofillHint;
  final ValueChanged<String> onChanged;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofillHints: [autofillHint],
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
      ),
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
    );
  }
}

class _TermsSection extends StatelessWidget {
  const _TermsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.agreeToTerms != current.agreeToTerms,
      builder: (context, state) {
        return Card(
          child: CheckboxListTile(
            value: state.agreeToTerms,
            onChanged: context.read<SignUpCubit>().onAgreeToTermsChanged,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            title: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '${'auth.signUp.agreeToThe'.tr()} '),
                  TextSpan(
                    text: 'auth.signUp.termsAndConditions'.tr(),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: ' ${'auth.signUp.and'.tr()} '),
                  TextSpan(
                    text: 'auth.signUp.privacyPolicy'.tr(),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        final loading = state.status.isLoading;
        return SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: state.isValid && !loading
                ? () {
                    HapticFeedback.mediumImpact();
                    TextInput.finishAutofillContext();
                    context.read<SignUpCubit>().submit();
                  }
                : null,
            icon: loading
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.person_add_rounded),
            label: Text('auth.signUp.submit'.tr()),
          ),
        );
      },
    );
  }
}

class _SignInPrompt extends StatelessWidget {
  const _SignInPrompt();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'auth.signUp.alreadyMember'.tr(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
        ),
        TextButton(
          onPressed: () => Navigator.maybePop(context),
          child: Text('auth.signUp.login'.tr()),
        ),
      ],
    );
  }
}
