import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  bool _motionConfigured = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 240),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.03),
      end: Offset.zero,
    ).animate(_fadeAnimation);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_motionConfigured) return;
    _motionConfigured = true;
    if (context.prefersReducedMotion) {
      _animationController.value = 1;
    } else {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(getIt()),
      child: BlocListener<SignInCubit, SignInState>(
        listener: (context, state) {
          statusHandler(context, state.status, msg: state.msg);
        },
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: const _SignInBody(),
          ),
        ),
      ),
    );
  }
}

class _SignInBody extends StatelessWidget {
  const _SignInBody();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              scheme.primaryContainer.withValues(alpha: 0.36),
              scheme.surface,
              scheme.secondaryContainer.withValues(alpha: 0.2),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: AdaptivePageBody(
              maxWidth: 600,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton.outlined(
                        tooltip:
                            MaterialLocalizations.of(context).backButtonTooltip,
                        onPressed: () => Navigator.maybePop(context),
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                      const AppLanguageMenu(),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const Center(child: AppLogo(size: 104)),
                  const SizedBox(height: 32),
                  Text(
                    'auth.signIn.title'.tr(),
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: scheme.primary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'auth.signIn.subtitle'.tr(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 28),
                  const _SignInForm(),
                  const SizedBox(height: 8),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        AppRoutes.forgotPassword.push(context);
                      },
                      child: Text('auth.signIn.forgotPassword'.tr()),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _SubmitButton(),
                  const SizedBox(height: 24),
                  const _SignUpPrompt(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignInForm extends StatefulWidget {
  const _SignInForm();

  @override
  State<_SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<_SignInForm> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignInCubit>();
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: AutofillGroup(
          child: Column(
            children: [
              TextFormField(
                autofillHints: const [AutofillHints.email],
                decoration: InputDecoration(
                  labelText: 'auth.signIn.email'.tr(),
                  hintText: 'auth.signIn.emailHint'.tr(),
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onChanged: cubit.onEmailChanged,
              ),
              const SizedBox(height: 16),
              TextFormField(
                autofillHints: const [AutofillHints.password],
                decoration: InputDecoration(
                  labelText: 'auth.signIn.password'.tr(),
                  hintText: 'auth.signIn.passwordHint'.tr(),
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    tooltip: _obscurePassword
                        ? 'auth.signIn.showPassword'.tr()
                        : 'auth.signIn.hidePassword'.tr(),
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: scheme.onSurfaceVariant,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                onChanged: cubit.onPasswordChanged,
                onFieldSubmitted: (_) {
                  if (context.read<SignInCubit>().state.isValid) cubit.submit();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SignInState>(
      buildWhen: (previous, current) =>
          previous.isValid != current.isValid ||
          previous.status != current.status,
      builder: (context, state) {
        final isLoading = state.status.isLoading;
        return SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: state.isValid && !isLoading
                ? () {
                    HapticFeedback.mediumImpact();
                    TextInput.finishAutofillContext();
                    context.read<SignInCubit>().submit();
                  }
                : null,
            child: isLoading
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text('auth.signIn.submit'.tr()),
          ),
        );
      },
    );
  }
}

class _SignUpPrompt extends StatelessWidget {
  const _SignUpPrompt();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            'auth.signIn.newToApp'.tr(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
        TextButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            AppRoutes.signUp.push(context);
          },
          child: Text('auth.signIn.signUp'.tr()),
        ),
      ],
    );
  }
}
