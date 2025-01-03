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
                  AppSpacing.spacing_3.heightBox,
                  Row(
                    children: [
                      BlocBuilder<SignUpCubit, SignUpState>(
                        buildWhen: (previous, current) =>
                            previous.agreeToTerms != current.agreeToTerms,
                        builder: (context, state) {
                          return Checkbox(
                            value: state.agreeToTerms,
                            onChanged: cubit.onAgreeToTermsChanged,
                          );
                        },
                      ),
                      Text('auth.signUp.agreeToThe'.tr()),
                      AppSpacing.spacing_1.widthBox,
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'auth.signUp.termsAndConditions'.tr(),
                          style: TextStyle(
                            color: context.colorScheme.primary,
                            decoration: TextDecoration.underline,
                            decorationThickness: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.spacing_3.heightBox,
                  BlocBuilder<SignUpCubit, SignUpState>(
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
                            'auth.signUp.submit'.tr(),
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

class _SignUpForm extends StatefulWidget {
  const _SignUpForm();

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<_SignUpForm> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignUpCubit>();
    return Container(
      padding: AppSpacing.spacing_3.padding,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'auth.signUp.username'.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: cubit.onUsernameChanged,
          ),
          AppSpacing.spacing_2.heightBox,
          TextFormField(
            decoration: InputDecoration(
              labelText: 'auth.signUp.firstName'.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: cubit.onFirstNameChanged,
          ),
          AppSpacing.spacing_2.heightBox,
          TextFormField(
            decoration: InputDecoration(
              labelText: 'auth.signUp.lastName'.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: cubit.onLastNameChanged,
          ),
          AppSpacing.spacing_2.heightBox,
          TextFormField(
            decoration: InputDecoration(
              labelText: 'auth.signUp.email'.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: cubit.onEmailChanged,
          ),
          AppSpacing.spacing_2.heightBox,
          TextFormField(
            decoration: InputDecoration(
              labelText: 'auth.signUp.phone'.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: cubit.onPhoneChanged,
          ),
          AppSpacing.spacing_2.heightBox,
          TextFormField(
            decoration: InputDecoration(
              labelText: 'auth.signUp.password'.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.visibility_off),
                onPressed: () {
                  // Toggle password visibility
                },
              ),
            ),
            obscureText: true,
            onChanged: cubit.onPasswordChanged,
          ),
          AppSpacing.spacing_2.heightBox,
          TextFormField(
            decoration: InputDecoration(
              labelText: 'auth.signUp.confirmPassword'.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.visibility_off),
                onPressed: () {
                  // Toggle password visibility
                },
              ),
            ),
            obscureText: true,
            onChanged: cubit.onCPasswordChanged,
          ),
        ],
      ),
    );
  }
}
