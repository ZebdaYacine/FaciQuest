import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:flutter/material.dart';

Future<void> showLanguageModal(BuildContext context) async {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return AppBackDrop(
        headerActions: BackdropHeaderActions.none,
        titleText: 'Language',
        body: Column(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          children: [
            ...LanguageManager.instance.supportedLocales.map(
              (e) {
                final isSelected = context.locale == e;
                return Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.colorScheme.primaryContainer
                        : context.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? context.colorScheme.primary
                          : context.colorScheme.outline.withOpacity(0.5),
                    ),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        LanguageManager.localeAssets(e),
                        fit: BoxFit.cover,
                        width: 24,
                        height: 24,
                      ),
                    ),
                    title: Text(
                      LanguageManager.localeTitle(e),
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : null,
                        color: isSelected
                            ? context.colorScheme.primary
                            : context.colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      e.countryCode ?? '',
                      style: TextStyle(
                        color: isSelected
                            ? context.colorScheme.primary.withOpacity(0.8)
                            : context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle_rounded,
                            color: context.colorScheme.primary,
                          )
                        : null,
                    onTap: () {
                      context.setLocale(e);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}
