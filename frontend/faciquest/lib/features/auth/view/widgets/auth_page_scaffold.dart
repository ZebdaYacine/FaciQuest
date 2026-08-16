import 'package:faciquest/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Shared adaptive shell for authentication forms.
class AuthPageScaffold extends StatefulWidget {
  const AuthPageScaffold({
    required this.title,
    required this.description,
    required this.icon,
    required this.child,
    super.key,
    this.information,
    this.footer,
    this.showBackButton = true,
    this.showLanguageMenu = true,
  });

  final String title;
  final String description;
  final IconData icon;
  final Widget child;
  final Widget? information;
  final Widget? footer;
  final bool showBackButton;
  final bool showLanguageMenu;

  @override
  State<AuthPageScaffold> createState() => _AuthPageScaffoldState();
}

class _AuthPageScaffoldState extends State<AuthPageScaffold>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  bool _motionConfigured = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 240),
      vsync: this,
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.03),
      end: Offset.zero,
    ).animate(_fade);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_motionConfigured) return;
    _motionConfigured = true;
    if (context.prefersReducedMotion) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: AdaptivePageBody(
              maxWidth: 600,
              child: FadeTransition(
                key: const Key('auth-page-entrance'),
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: Column(
                    children: [
                      _Header(
                        showBackButton: widget.showBackButton,
                        showLanguageMenu: widget.showLanguageMenu,
                      ),
                      const SizedBox(height: 28),
                      _Illustration(icon: widget.icon),
                      const SizedBox(height: 24),
                      Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: scheme.primary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.description,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                      ),
                      if (widget.information != null) ...[
                        const SizedBox(height: 20),
                        widget.information!,
                      ],
                      const SizedBox(height: 28),
                      widget.child,
                      if (widget.footer != null) ...[
                        const SizedBox(height: 20),
                        widget.footer!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.showBackButton,
    required this.showLanguageMenu,
  });

  final bool showBackButton;
  final bool showLanguageMenu;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (showBackButton)
          IconButton.outlined(
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.maybePop(context);
            },
            icon: const Icon(Icons.arrow_back_rounded),
          )
        else
          const SizedBox.square(dimension: 48),
        if (showLanguageMenu) const AppLanguageMenu(),
      ],
    );
  }
}

class _Illustration extends StatelessWidget {
  const _Illustration({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      excludeSemantics: true,
      child: Container(
        width: 88,
        height: 88,
        decoration: BoxDecoration(
          color: scheme.primaryContainer,
          shape: BoxShape.circle,
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Icon(icon, size: 40, color: scheme.onPrimaryContainer),
      ),
    );
  }
}

class AuthInfoPanel extends StatelessWidget {
  const AuthInfoPanel({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: scheme.onPrimaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onPrimaryContainer,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
