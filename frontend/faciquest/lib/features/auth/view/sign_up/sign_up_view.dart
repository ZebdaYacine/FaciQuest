import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
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
                  Text(
                    'auth.signUp.title'.tr(),
                    style: context.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  AppSpacing.spacing_1.heightBox,
                  Row(
                    children: [
                      Text(
                        'auth.signUp.alreadyMember'.tr(),
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: context.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      AppSpacing.spacing_1.widthBox,
                      GestureDetector(
                        onTap: () {
                          context.pop();
                        },
                        child: Text(
                          'auth.signUp.login'.tr(),
                          style: TextStyle(
                            color: context.colorScheme.primary,
                            decoration: TextDecoration.underline,
                            decorationThickness: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.spacing_4.heightBox,
                  const _SignUpForm(),
                  AppSpacing.spacing_4.heightBox,
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: context.colorScheme.surfaceContainerLowest,
                      border: Border.all(
                        color: context.colorScheme.outline.withOpacity(0.1),
                      ),
                    ),
                    padding: AppSpacing.spacing_3.padding,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<SignUpCubit, SignUpState>(
                          buildWhen: (previous, current) => previous.agreeToTerms != current.agreeToTerms,
                          builder: (context, state) {
                            return Container(
                              margin: const EdgeInsets.only(top: 2),
                              child: Transform.scale(
                                scale: 1.2,
                                child: Checkbox(
                                  value: state.agreeToTerms,
                                  onChanged: cubit.onAgreeToTermsChanged,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                            );
                          },
                        ),
                        AppSpacing.spacing_2.widthBox,
                        Expanded(
                          child: Wrap(
                            children: [
                              Text(
                                'auth.signUp.agreeToThe'.tr(),
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: context.colorScheme.onSurface,
                                ),
                              ),
                              const Text(' '),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  'auth.signUp.termsAndConditions'.tr(),
                                  style: TextStyle(
                                    color: context.colorScheme.primary,
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 1.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.spacing_4.heightBox,
                  BlocBuilder<SignUpCubit, SignUpState>(
                    builder: (context, state) {
                      return PrimaryButton(
                        onPressed: state.isValid ? cubit.submit : null,
                        isLoading: state.status.isLoading,
                        icon: const Icon(Icons.person_add_rounded),
                        child: Text('auth.signUp.submit'.tr()),
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
          index * 0.1,
          0.5 + (index * 0.1),
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
      padding: AppSpacing.spacing_4.padding,
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
              hintText: 'Enter your username',
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
                    hintText: 'First name',
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
                    hintText: 'Last name',
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
              hintText: 'Enter your email address',
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
              hintText: 'Enter your phone number',
              prefixIcon: Icon(
                Icons.phone_outlined,
                color: context.colorScheme.primary,
              ),
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              onChanged: cubit.onPhoneChanged,
            ),
          ),
          AppSpacing.spacing_3.heightBox,
          _buildAnimatedField(
            5,
            PasswordTextField(
              labelText: 'auth.signUp.password'.tr(),
              hintText: 'Create a strong password',
              showStrengthIndicator: true,
              onChanged: cubit.onPasswordChanged,
            ),
          ),
          AppSpacing.spacing_3.heightBox,
          _buildAnimatedField(
            6,
            PasswordTextField(
              labelText: 'auth.signUp.confirmPassword'.tr(),
              hintText: 'Confirm your password',
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
