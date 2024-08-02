import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/core/widgets/widgets.dart';
import 'package:flutter/material.dart';

Future<void> showLanguageModal(BuildContext context) async {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return AppBackDrop(
        headerActions: BackdropHeaderActions.none,
        titleText: 'Langage',
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...LanguageManager.instance.supportedLocales.map(
              (e) {
                return ListTile(
                  leading: SizedBox(
                    width: 24,
                    height: 24,
                    child: Image.asset(
                      LanguageManager.localeAssets(e),
                    ),
                  ),
                  title: Text(LanguageManager.localeTitle(e)),
                  subtitle: Text(e.countryCode ?? ''),
                  selected: context.locale == e,
                  onTap: () {
                    context.setLocale(e);
                    Navigator.pop(context);
                  },
                );
              },
            )
          ],
        ),
      );
    },
  );
}
