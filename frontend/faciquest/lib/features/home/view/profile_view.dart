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
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (user != null && user.isNotEmpty)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${user.firstName} ${user.lastName}'),
                    Text('+${user.phone}'),
                  ],
                ),
              AppSpacing.spacing_1.widthBox,
              const CircleAvatar(
                child: Text('YG'),
              ),
              AppSpacing.spacing_2.widthBox,
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WalletCardWidget(),
            Padding(
              padding: AppSpacing.spacing_2.padding,
              child: Text('My Account', style: context.textTheme.headlineSmall),
            ),
            ListTile(
              onTap: () => AppRoutes.personalInfo.push(context),
              title: const Text('Profile'),
              leading: const Icon(Icons.person),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              onTap: () => AppRoutes.setNewPassword.push(context),
              title: const Text('Change Password'),
              leading: const Icon(Icons.password),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              onTap: () {},
              title: const Text('Notifications'),
              leading: const Icon(Icons.notifications),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            const Divider(
              thickness: 4,
            ),
            Padding(
              padding: AppSpacing.spacing_2.padding,
              child:
                  Text('More Actions', style: context.textTheme.headlineSmall),
            ),
            ListTile(
              onTap: () => AppRoutes.howItWorks.push(context),
              title: const Text('How its work'),
              leading: const Icon(Icons.info),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            // ListTile(
            //   onTap: () {},
            //   title: const Text('Help'),
            //   leading: const Icon(Icons.help),
            //   trailing: const Icon(Icons.arrow_forward_ios),
            // ),
            ListTile(
              onTap: () => showLanguageModal(context),
              title: const Text('Language'),
              leading: const Icon(Icons.language),
            ),
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return ListTile(
                  onTap: () => getIt<ThemeBloc>().add(ThemeModeChanged(
                      themeMode: state.themeMode == ThemeMode.light
                          ? ThemeMode.dark
                          : ThemeMode.light)),
                  title: const Text('Theme'),
                  leading: state.themeMode == ThemeMode.light
                      ? const Icon(Icons.dark_mode)
                      : const Icon(Icons.light_mode),
                );
              },
            ),
            ListTile(
              onTap: () => getIt<AuthBloc>().add(SignOutRequested()),
              title: const Text('Logout'),
              leading: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }
}
