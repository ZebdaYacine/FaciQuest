import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../manager/language/language_manager.dart';

class AppLanguageMenu extends StatelessWidget {
  const AppLanguageMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return PopupMenuButton<Locale>(
      tooltip: 'profile.language'.tr(),
      icon: const Icon(Icons.language_rounded),
      onSelected: context.setLocale,
      style: IconButton.styleFrom(
        foregroundColor: scheme.primary,
        backgroundColor: scheme.surfaceContainerLow,
        side: BorderSide(color: scheme.outlineVariant),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      itemBuilder: (context) => LanguageManager.instance.supportedLocales
          .map(
            (locale) => PopupMenuItem<Locale>(
              value: locale,
              child: Row(
                children: [
                  Image.asset(
                    LanguageManager.localeAssets(locale),
                    width: 24,
                    height: 18,
                    semanticLabel: LanguageManager.localeTitle(locale),
                  ),
                  const SizedBox(width: 12),
                  Text(LanguageManager.localeTitle(locale)),
                  if (context.locale.languageCode == locale.languageCode) ...[
                    const Spacer(),
                    Icon(Icons.check_rounded, color: scheme.primary),
                  ],
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
