import 'package:awesome_extensions/awesome_extensions.dart';
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
              pathParameters: {
                'from': VerifyOtpFrom.signUp.name,
              },
            );
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
    final cubit = context.read<SignUpCubit>();
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
            padding: AppSpacing.spacing_2.horizontalPadding,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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

                  const SizedBox(height: 32),

                  // Welcome section with better typography
                  _WelcomeSection(),

                  const SizedBox(height: 32),

                  // Enhanced form
                  const _SignUpForm(),

                  const SizedBox(height: 24),

                  // Enhanced terms section
                  _TermsSection(),

                  const SizedBox(height: 32),

                  // Enhanced sign up button
                  _SignUpButton(),

                  const SizedBox(height: 24),

                  // Sign in prompt
                  _SignInPrompt(),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'auth.signUp.title'.tr(),
          style: context.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.primary,
            fontSize: 32,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'auth.signUp.subtitle'.tr(),
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.colorScheme.onSurface.withOpacity(0.7),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _TermsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignUpCubit>();
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.agreeToTerms != current.agreeToTerms,
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: context.colorScheme.surface.withOpacity(0.8),
            border: Border.all(
              color: context.colorScheme.outline.withOpacity(0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: context.colorScheme.shadow.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color:
                        state.agreeToTerms ? context.colorScheme.primary : context.colorScheme.outline.withOpacity(0.3),
                    width: 2,
                  ),
                  color: state.agreeToTerms ? context.colorScheme.primary : Colors.transparent,
                ),
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    cubit.onAgreeToTermsChanged(!state.agreeToTerms);
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: state.agreeToTerms
                        ? Icon(
                            Icons.check_rounded,
                            color: context.colorScheme.onPrimary,
                            size: 16,
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    cubit.onAgreeToTermsChanged(!state.agreeToTerms);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.onSurface,
                          ),
                          children: [
                            TextSpan(text: 'auth.signUp.agreeToThe'.tr()),
                            const TextSpan(text: ' '),
                            TextSpan(
                              text: 'auth.signUp.termsAndConditions'.tr(),
                              style: TextStyle(
                                color: context.colorScheme.primary,
                                decoration: TextDecoration.underline,
                                decorationThickness: 1.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: ' '),
                            TextSpan(text: 'auth.signUp.and'.tr()),
                            const TextSpan(text: ' '),
                            TextSpan(
                              text: 'auth.signUp.privacyPolicy'.tr(),
                              style: TextStyle(
                                color: context.colorScheme.primary,
                                decoration: TextDecoration.underline,
                                decorationThickness: 1.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignUpCubit>();
    return BlocBuilder<SignUpCubit, SignUpState>(
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
                    Icons.person_add_rounded,
                    color:
                        state.isValid ? context.colorScheme.onPrimary : context.colorScheme.onSurface.withOpacity(0.4),
                  ),
            label: Text(
              'auth.signUp.submit'.tr(),
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

class _SignInPrompt extends StatelessWidget {
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'auth.signUp.alreadyMember'.tr(),
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).pop();
              },
              child: Text(
                'auth.signUp.login'.tr(),
                style: TextStyle(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.underline,
                  decorationThickness: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignUpForm extends StatefulWidget {
  const _SignUpForm();

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<_SignUpForm> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _fieldAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fieldAnimations = List.generate(7, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          (index * 0.1).clamp(0.0, 1.0),
          (0.5 + (index * 0.1)).clamp(0.0, 1.0),
          curve: Curves.easeOutCubic,
        ),
      ));
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignUpCubit>();
    return Container(
      padding: AppSpacing.spacing_2.padding,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.primary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: context.colorScheme.shadow.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: context.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildAnimatedField(
            0,
            EnhancedTextField(
              labelText: 'auth.signUp.username'.tr(),
              hintText: 'auth.signUp.usernameHint'.tr(),
              prefixIcon: Icon(
                Icons.person_outline_rounded,
                color: context.colorScheme.primary,
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onChanged: cubit.onUsernameChanged,
            ),
          ),
          AppSpacing.spacing_3.heightBox,
          Row(
            children: [
              Expanded(
                child: _buildAnimatedField(
                  1,
                  EnhancedTextField(
                    labelText: 'auth.signUp.firstName'.tr(),
                    hintText: 'auth.signUp.firstNameHint'.tr(),
                    prefixIcon: Icon(
                      Icons.badge_outlined,
                      color: context.colorScheme.primary,
                    ),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    onChanged: cubit.onFirstNameChanged,
                  ),
                ),
              ),
              AppSpacing.spacing_2.widthBox,
              Expanded(
                child: _buildAnimatedField(
                  2,
                  EnhancedTextField(
                    labelText: 'auth.signUp.lastName'.tr(),
                    hintText: 'auth.signUp.lastNameHint'.tr(),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    onChanged: cubit.onLastNameChanged,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.spacing_3.heightBox,
          _buildAnimatedField(
            3,
            EnhancedTextField(
              labelText: 'auth.signUp.email'.tr(),
              hintText: 'auth.signUp.emailHint'.tr(),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: context.colorScheme.primary,
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onChanged: cubit.onEmailChanged,
            ),
          ),
          AppSpacing.spacing_3.heightBox,
          _buildAnimatedField(
            4,
            EnhancedTextField(
              labelText: 'auth.signUp.phone'.tr(),
              hintText: 'auth.signUp.phoneHint'.tr(),
              prefixIcon: Icon(
                Icons.phone_outlined,
                color: context.colorScheme.primary,
              ),
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              onChanged: cubit.onPhoneChanged,
              maxLength: 10,
              showCounter: true,
            ),
          ),
          AppSpacing.spacing_3.heightBox,
          _buildAnimatedField(
            5,
            PasswordTextField(
              labelText: 'auth.signUp.password'.tr(),
              hintText: 'auth.signUp.passwordHint'.tr(),
              showStrengthIndicator: true,
              onChanged: cubit.onPasswordChanged,
            ),
          ),
          AppSpacing.spacing_3.heightBox,
          _buildAnimatedField(
            6,
            PasswordTextField(
              labelText: 'auth.signUp.confirmPassword'.tr(),
              hintText: 'auth.signUp.confirmPasswordHint'.tr(),
              onChanged: cubit.onCPasswordChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedField(int index, Widget child) {
    return AnimatedBuilder(
      animation: _fieldAnimations[index],
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _fieldAnimations[index].value)),
          child: Opacity(
            opacity: _fieldAnimations[index].value,
            child: child,
          ),
        );
      },
    );
  }
}
