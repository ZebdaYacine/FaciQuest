import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(getIt()),
      child: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          statusHandler(context, state.status, msg: state.msg);
          if (state.status.isSuccess) {
            AppRoutes.verifyOtp.push(
              context,
              pathParameters: {'from': VerifyOtpFrom.forgotPassword.name},
            );
          }
        },
        child: AuthPageScaffold(
          title: 'auth.forgotPassword.title'.tr(),
          description: 'auth.forgotPassword.description'.tr(),
          icon: Icons.lock_reset_rounded,
          information: AuthInfoPanel(
            text: 'auth.forgotPassword.emailInfo'.tr(),
          ),
          footer: const _BackToSignIn(),
          child: const Column(
            children: [
              _EmailForm(),
              SizedBox(height: 20),
              _SubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailForm extends StatelessWidget {
  const _EmailForm();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgotPasswordCubit>();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
          buildWhen: (previous, current) => previous.email != current.email,
          builder: (context, state) {
            final showError = state.email.isNotEmpty && !state.isValid;
            return TextFormField(
              autofillHints: const [AutofillHints.email],
              decoration: InputDecoration(
                labelText: 'auth.forgotPassword.email'.tr(),
                hintText: 'auth.signIn.emailHint'.tr(),
                prefixIcon: const Icon(Icons.email_outlined),
                errorText:
                    showError ? 'auth.validation.emailInvalid'.tr() : null,
                suffixIcon: state.email.isEmpty
                    ? null
                    : Icon(
                        state.isValid
                            ? Icons.check_circle_outline_rounded
                            : Icons.error_outline_rounded,
                        color: state.isValid
                            ? context.colorScheme.primary
                            : context.colorScheme.error,
                      ),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onChanged: cubit.onEmailChanged,
              onFieldSubmitted: (_) {
                if (state.isValid && !state.status.isLoading) cubit.submit();
              },
            );
          },
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
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
                    context.read<ForgotPasswordCubit>().submit();
                  }
                : null,
            icon: loading
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send_rounded),
            label: Text('auth.forgotPassword.submit'.tr()),
          ),
        );
      },
    );
  }
}

class _BackToSignIn extends StatelessWidget {
  const _BackToSignIn();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'auth.forgotPassword.rememberPassword'.tr(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
        ),
        TextButton(
          onPressed: () => Navigator.maybePop(context),
          child: Text('auth.forgotPassword.backToSignIn'.tr()),
        ),
      ],
    );
  }
}
