import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';

Future<void> showWebLinkModal(BuildContext context) async {
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return const WebLinkModal();
    },
  );
}

class WebLinkModal extends StatefulWidget {
  const WebLinkModal({
    super.key,
    this.collector,
  });
  final CollectorEntity? collector;

  @override
  State<WebLinkModal> createState() => _WebLinkModalState();
}

class _WebLinkModalState extends State<WebLinkModal> {
  String link = '';
  @override
  void initState() {
    link = widget.collector?.webUrl ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackDrop(
      headerActions: BackdropHeaderActions.none,
      titleText: 'Web Link'.tr(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            initialValue: link,
            onChanged: (value) => link = value,
            decoration: InputDecoration(
              hintText: 'Enter collector nickname'.tr(),
            ),
          )
        ],
      ),
      actions: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: context.colorScheme.onPrimary,
          backgroundColor: context.colorScheme.primary,
        ),
        onPressed: () {},
        child: const Center(
          child: Text('Generate Link'),
        ),
      ),
    );
  }
}
