import 'package:awesome_extensions/awesome_extensions.dart';
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

class _SignInViewState extends State<SignInView> with TickerProviderStateMixin {
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

    // Start animation with slight delay
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
      create: (context) => SignInCubit(getIt()),
      child: BlocListener<SignInCubit, SignInState>(
        listener: (context, state) {
          statusHandler(context, state.status, msg: state.msg);
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
    final cubit = context.read<SignInCubit>();
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with language selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back button
                      Container(
                        decoration: BoxDecoration(
                          color: context.colorScheme.surface.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: context.colorScheme.outline.withOpacity(0.1),
                          ),
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      _LanguageSelector(),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Hero section with improved logo
                  Center(
                    child: _LogoSection(),
                  ),

                  const SizedBox(height: 50),

                  // Welcome text with better typography
                  _WelcomeSection(),

                  const SizedBox(height: 40),

                  // Enhanced form
                  const _LogInForm(),

                  const SizedBox(height: 24),

                  // Forgot password link with better styling
                  _ForgotPasswordLink(),

                  const SizedBox(height: 32),

                  // Enhanced sign in button
                  _SignInButton(),

                  const SizedBox(height: 32),

                  // Sign up prompt
                  _SignUpPrompt(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.primary.withOpacity(0.2),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: context.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                context.colorScheme.surface,
                context.colorScheme.surface.withOpacity(0.95),
              ],
            ),
          ),
          child: const Image(
            image: AssetImage('assets/images/logo.jpeg'),
            fit: BoxFit.contain,
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
          'auth.signIn.title'.tr(),
          style: context.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.primary,
            fontSize: 32,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'auth.signIn.subtitle'.tr(),
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.colorScheme.onSurface.withOpacity(0.7),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _ForgotPasswordLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          AppRoutes.forgotPassword.push(context);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.transparent,
          ),
          child: Text(
            'auth.signIn.forgotPassword'.tr(),
            style: TextStyle(
              color: context.colorScheme.primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              decorationThickness: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignInCubit>();
    return BlocBuilder<SignInCubit, SignInState>(
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
          child: ElevatedButton(
            onPressed: state.isValid
                ? () {
                    HapticFeedback.mediumImpact();
                    cubit.submit();
                  }
                : null,
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
            child: state.status.isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: context.colorScheme.onPrimary,
                    ),
                  )
                : Text(
                    'auth.signIn.submit'.tr(),
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: state.isValid
                          ? context.colorScheme.onPrimary
                          : context.colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _SignUpPrompt extends StatelessWidget {
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
              'auth.signIn.newToApp'.tr(),
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                AppRoutes.signUp.push(context);
              },
              child: Text(
                'auth.signIn.signUp'.tr(),
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

class _LogInForm extends StatefulWidget {
  const _LogInForm();

  @override
  _LogInFormState createState() => _LogInFormState();
}

class _LogInFormState extends State<_LogInForm> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignInCubit>();
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
      child: Column(
        children: [
          // Email field
          TextFormField(
            decoration: InputDecoration(
              labelText: 'auth.signIn.email'.tr(),
              hintText: 'auth.signIn.emailHint'.tr(),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: context.colorScheme.primary,
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
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onChanged: (value) => cubit.onEmailChanged(value),
          ),

          const SizedBox(height: 20),

          // Password field
          TextFormField(
            decoration: InputDecoration(
              labelText: 'auth.signIn.password'.tr(),
              hintText: 'auth.signIn.passwordHint'.tr(),
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
            textInputAction: TextInputAction.done,
            onChanged: (value) => cubit.onPasswordChanged(value),
            onFieldSubmitted: (_) {
              final state = context.read<SignInCubit>().state;
              if (state.isValid) {
                cubit.submit();
              }
            },
          ),
        ],
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: PopupMenuButton<String>(
        icon: Icon(
          Icons.language_rounded,
          color: context.colorScheme.primary,
        ),
        onSelected: (String locale) {
          HapticFeedback.lightImpact();
          context.setLocale(Locale(locale));
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        itemBuilder: (BuildContext context) => [
          const PopupMenuItem<String>(
            value: 'en',
            child: Row(
              children: [
                Image(
                  image: AssetImage('assets/images/en.png'),
                  width: 24,
                  height: 18,
                ),
                SizedBox(width: 12),
                Text('English'),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'ar',
            child: Row(
              children: [
                Image(
                  image: AssetImage('assets/images/ar.png'),
                  width: 24,
                  height: 18,
                ),
                SizedBox(width: 12),
                Text('العربية'),
              ],
            ),
          ),
           PopupMenuItem<String>(
            value: 'fr',
            child: Row(
              children: [
                Image(
                  image: AssetImage('assets/images/fr.png'),
                  width: 24,
                  height: 18,
                ),
                SizedBox(width: 12),
                Text('language.fr'.tr()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
