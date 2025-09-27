import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HowItWorksView extends StatefulWidget {
  const HowItWorksView({super.key});

  @override
  State<HowItWorksView> createState() => _HowItWorksViewState();
}

class _HowItWorksViewState extends State<HowItWorksView> with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _contentAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentAnimationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentAnimationController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startAnimations() async {
    _headerAnimationController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _contentAnimationController.forward();
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _contentAnimationController.dispose();
    super.dispose();
  }

  Future<void> _launchYouTubeVideo() async {
    // Replace with your actual YouTube video URL
    const String youtubeUrl = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'; // Example URL

    try {
      final Uri uri = Uri.parse(youtubeUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('how_it_works.video_error'.tr()),
              backgroundColor: context.colorScheme.error,
            ),
          );
        }
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('how_it_works.video_error'.tr()),
            backgroundColor: context.colorScheme.error,
          ),
        );
      }
    }
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
              context.colorScheme.surface,
              context.colorScheme.surfaceContainerLowest,
              context.colorScheme.surface.withOpacity(0.98),
            ],
          ),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header Section
            SliverAppBar(
              expandedHeight: 240,
              floating: false,
              pinned: true,
              snap: false,
              elevation: 0,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        context.colorScheme.primary.withOpacity(0.1),
                        context.colorScheme.primaryContainer.withOpacity(0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: AppSpacing.spacing_3.padding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppSpacing.spacing_4.heightBox,
                          FadeTransition(
                            opacity: _headerAnimationController,
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        context.colorScheme.primary,
                                        context.colorScheme.primaryContainer,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: context.colorScheme.primary.withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.lightbulb_rounded,
                                    size: 32,
                                    color: Colors.white,
                                  ),
                                ),
                                AppSpacing.spacing_3.widthBox,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'profile.menu.how_it_works'.tr(),
                                        style: context.textTheme.headlineLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: context.colorScheme.onSurface,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      AppSpacing.spacing_1.heightBox,
                                      Text(
                                        'how_it_works.subtitle'.tr(),
                                        style: context.textTheme.bodyLarge?.copyWith(
                                          color: context.colorScheme.onSurfaceVariant,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Content Section
            SliverPadding(
              padding: AppSpacing.spacing_3.padding,
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          _buildStepSection(
                            context: context,
                            stepNumber: '01',
                            title: 'how_it_works.step1.title'.tr(),
                            description: 'how_it_works.step1.description'.tr(),
                            icon: Icons.person_add_rounded,
                            color: context.colorScheme.primary,
                            delay: 0,
                          ),
                          AppSpacing.spacing_4.heightBox,
                          _buildStepSection(
                            context: context,
                            stepNumber: '02',
                            title: 'how_it_works.step2.title'.tr(),
                            description: 'how_it_works.step2.description'.tr(),
                            icon: Icons.quiz_rounded,
                            color: context.colorScheme.secondary,
                            delay: 200,
                          ),
                          AppSpacing.spacing_4.heightBox,
                          _buildStepSection(
                            context: context,
                            stepNumber: '03',
                            title: 'how_it_works.step3.title'.tr(),
                            description: 'how_it_works.step3.description'.tr(),
                            icon: Icons.monetization_on_rounded,
                            color: context.colorScheme.tertiary,
                            delay: 400,
                          ),
                          AppSpacing.spacing_4.heightBox,
                          _buildStepSection(
                            context: context,
                            stepNumber: '04',
                            title: 'how_it_works.step4.title'.tr(),
                            description: 'how_it_works.step4.description'.tr(),
                            icon: Icons.account_balance_wallet_rounded,
                            color: context.colorScheme.primary,
                            delay: 600,
                          ),
                          AppSpacing.spacing_5.heightBox,
                          _buildFeatureSection(context),
                          AppSpacing.spacing_5.heightBox,
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 1000),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: 0.8 + (0.2 * value),
            child: Opacity(
              opacity: value,
              child: FloatingActionButton.extended(
                onPressed: _launchYouTubeVideo,
                backgroundColor: context.colorScheme.tertiary,
                foregroundColor: context.colorScheme.onTertiary,
                elevation: 8,
                extendedPadding: const EdgeInsets.symmetric(horizontal: 20),
                icon: const Icon(Icons.play_circle_outline_rounded, size: 24),
                label: Text(
                  'how_it_works.watch_video'.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepSection({
    required BuildContext context,
    required String stepNumber,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: AppSpacing.spacing_4.padding,
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: color.withOpacity(0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: context.colorScheme.shadow.withOpacity(0.05),
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color.withOpacity(0.8),
                          color,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            icon,
                            size: 28,
                            color: Colors.white,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                stepNumber,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.spacing_3.widthBox,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: context.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colorScheme.onSurface,
                            letterSpacing: -0.2,
                          ),
                        ),
                        AppSpacing.spacing_1.heightBox,
                        Text(
                          description,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureSection(BuildContext context) {
    final features = [
      {
        'title': 'how_it_works.features.smart_surveys'.tr(),
        'description': 'how_it_works.features.smart_surveys_desc'.tr(),
        'icon': Icons.psychology_rounded,
      },
      {
        'title': 'how_it_works.features.real_time'.tr(),
        'description': 'how_it_works.features.real_time_desc'.tr(),
        'icon': Icons.analytics_rounded,
      },
      {
        'title': 'how_it_works.features.secure'.tr(),
        'description': 'how_it_works.features.secure_desc'.tr(),
        'icon': Icons.security_rounded,
      },
    ];

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 40 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: AppSpacing.spacing_4.padding,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.colorScheme.primaryContainer.withOpacity(0.3),
                    context.colorScheme.secondaryContainer.withOpacity(0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: context.colorScheme.primary.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: context.colorScheme.primary,
                        size: 28,
                      ),
                      AppSpacing.spacing_2.widthBox,
                      Text(
                        'how_it_works.why_choose'.tr(),
                        style: context.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colorScheme.onSurface,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.spacing_3.heightBox,
                  ...features.asMap().entries.map((entry) {
                    final index = entry.key;
                    final feature = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == features.length - 1 ? 0 : AppSpacing.spacing_3,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: context.colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: context.colorScheme.shadow.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              feature['icon'] as IconData,
                              color: context.colorScheme.primary,
                              size: 24,
                            ),
                          ),
                          AppSpacing.spacing_3.widthBox,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  feature['title'] as String,
                                  style: context.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: context.colorScheme.onSurface,
                                  ),
                                ),
                                AppSpacing.spacing_0_5.heightBox,
                                Text(
                                  feature['description'] as String,
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: context.colorScheme.onSurfaceVariant,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
