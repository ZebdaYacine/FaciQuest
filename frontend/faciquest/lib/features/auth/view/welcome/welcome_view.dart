import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> with TickerProviderStateMixin {
  late AnimationController _heroAnimationController;
  late AnimationController _contentAnimationController;
  late Animation<double> _heroScaleAnimation;
  late Animation<double> _heroOpacityAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _heroAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _heroScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _heroAnimationController,
      curve: Curves.elasticOut,
    ));

    _heroOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _heroAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentAnimationController,
      curve: Curves.easeOut,
    ));
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _heroAnimationController.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    _contentAnimationController.forward();
  }

  @override
  void dispose() {
    _heroAnimationController.dispose();
    _contentAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.colorScheme.primary.withOpacity(0.1),
              context.colorScheme.surface,
              context.colorScheme.primary.withOpacity(0.05),
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: AppSpacing.spacing_4.horizontalPadding,
            child: Column(
              children: [
                // Language selector at top
                Align(
                  alignment: Alignment.topRight,
                  child: _LanguageSelector(),
                ),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Hero section
                      AnimatedBuilder(
                        animation: _heroAnimationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _heroScaleAnimation.value,
                            child: Opacity(
                              opacity: _heroOpacityAnimation.value,
                              child: _HeroSection(),
                            ),
                          );
                        },
                      ),

                      // Content section
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: _ContentSection(),
                        ),
                      ),
                    ],
                  ),
                ),

                // Action buttons at bottom
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _ActionButtons(),
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

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App logo with modern styling
        Container(
          height: 140,
          width: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: context.colorScheme.primary.withOpacity(0.3),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
              BoxShadow(
                color: context.colorScheme.shadow.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
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
        ),

        const SizedBox(height: 32),

        // App name with stylized text
        Text(
          'FaciQuest',
          style: context.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 36,
            color: context.colorScheme.primary,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

class _ContentSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'welcome.title'.tr(),
          textAlign: TextAlign.center,
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: context.colorScheme.onSurface,
          ),
        ),

        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'welcome.description'.tr(),
            textAlign: TextAlign.center,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.onSurface.withOpacity(0.7),
              height: 1.5,
            ),
          ),
        ),

        const SizedBox(height: 22),

        // Feature highlights
        _FeatureHighlights(),
      ],
    );
  }
}

class _FeatureHighlights extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final features = [
      {'icon': Icons.quiz_outlined, 'title': 'smart_surveys', 'description': 'create_intelligent_questionnaires'},
      {'icon': Icons.analytics_outlined, 'title': 'real_time_analytics', 'description': 'get_instant_insights'},
      {'icon': Icons.security_outlined, 'title': 'secure_private', 'description': 'your_data_is_protected'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      spacing: 8,
      children: features.map((feature) {
        return Expanded(
          child: AspectRatio(
            aspectRatio: 0.7,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.colorScheme.surface.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: context.colorScheme.outline.withOpacity(0.1),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    feature['icon'] as IconData,
                    color: context.colorScheme.primary,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tr('welcome.${feature['title']}'),
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tr('welcome.${feature['description']}'),
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sign up button (primary)
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              AppRoutes.signUp.push(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.primary,
              foregroundColor: context.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              shadowColor: context.colorScheme.primary.withOpacity(0.3),
            ),
            child: Text(
              'welcome.get_started'.tr(),
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.onPrimary,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Sign in button (secondary)
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              AppRoutes.signIn.push(context);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: context.colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              side: BorderSide(
                color: context.colorScheme.primary,
                width: 2,
              ),
            ),
            child: Text(
              'welcome.sign_in'.tr(),
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colorScheme.primary,
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Terms and privacy
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              'welcome.byUsing'.tr(),
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () {
                // Handle terms tap
              },
              child: Text(
                'welcome.terms'.tr(),
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.primary,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'welcome.and'.tr(),
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () {
                // Handle privacy tap
              },
              child: Text(
                'welcome.privacy'.tr(),
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.primary,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
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
          color: context.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: PopupMenuButton<String>(
        icon: Icon(
          Icons.language_rounded,
          color: context.colorScheme.primary,
        ),
        onSelected: (String locale) {
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
