import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = getIt<AuthBloc>().state.user;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.colorScheme.surface,
        actions: [
          Container(
            margin: AppSpacing.spacing_2.rightPadding,
            padding: AppSpacing.spacing_2.horizontalPadding,
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (user != null && user.isNotEmpty)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${user.firstName} ${user.lastName}',
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        '+213${user.phone}',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                AppSpacing.spacing_2.widthBox,
                CircleAvatar(
                  backgroundColor: context.colorScheme.primaryContainer,
                  child: Text(
                    'YG',
                    style: TextStyle(
                      color: context.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WalletCardWidget(),
              Padding(
                padding: AppSpacing.spacing_3.padding,
                child: Text(
                  'My Account',
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.primary,
                  ),
                ),
              ),
              _buildListTile(
                context,
                title: 'Profile',
                icon: Icons.person_outline_rounded,
                onTap: () => AppRoutes.personalInfo.push(context),
              ),
              _buildListTile(
                context,
                title: 'Change Password',
                icon: Icons.lock_outline_rounded,
                onTap: () => AppRoutes.setNewPassword.push(context),
              ),
              AppSpacing.spacing_2.heightBox,
              Container(
                height: 4,
                margin: AppSpacing.spacing_2.horizontalPadding,
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              AppSpacing.spacing_2.heightBox,
              Padding(
                padding: AppSpacing.spacing_3.padding,
                child: Text(
                  'More Actions',
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.primary,
                  ),
                ),
              ),
              _buildListTile(
                context,
                title: 'How it works',
                icon: Icons.info_outline_rounded,
                onTap: () => AppRoutes.howItWorks.push(context),
              ),
              _buildListTile(
                context,
                title: 'Language',
                icon: Icons.language_rounded,
                onTap: () => showLanguageModal(context),
                showTrailing: false,
              ),
              BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, state) {
                  return _buildListTile(
                    context,
                    title: 'Theme',
                    icon: state.themeMode == ThemeMode.light
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                    onTap: () => getIt<ThemeBloc>().add(ThemeModeChanged(
                      themeMode: state.themeMode == ThemeMode.light
                          ? ThemeMode.dark
                          : ThemeMode.light,
                    )),
                    showTrailing: false,
                  );
                },
              ),
              _buildListTile(
                context,
                title: 'Logout',
                icon: Icons.logout_rounded,
                onTap: () => getIt<AuthBloc>().add(SignOutRequested()),
                showTrailing: false,
                isDestructive: true,
              ),
              AppSpacing.spacing_3.heightBox,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool showTrailing = true,
    bool isDestructive = false,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: AppSpacing.spacing_3.horizontalPadding,
      title: Text(
        title,
        style: context.textTheme.titleMedium?.copyWith(
          color: isDestructive
              ? context.colorScheme.error
              : context.colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      leading: Icon(
        icon,
        color: isDestructive
            ? context.colorScheme.error
            : context.colorScheme.primary,
      ),
      trailing: showTrailing
          ? Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: context.colorScheme.onSurfaceVariant,
            )
          : null,
    );
  }
}
