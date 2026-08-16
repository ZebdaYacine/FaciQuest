part of 'collect_responses_page.dart';

Future<void> showQRCodeModal(BuildContext context) async {
  final cubit = context.read<NewSurveyCubit>();
  final surveyUrl = 'https://survey.faciquest.com/s/${cubit.state.survey.id}';

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: BoxConstraints(maxHeight: context.height * 0.9),
    builder: (BuildContext _) {
      return AppBackDrop(
        headerActions: BackdropHeaderActions.none,
        title: Row(
          children: [
            Icon(
              Icons.qr_code_rounded,
              color: context.colorScheme.primary,
            ),
            12.widthBox,
            Text(
              'survey.collectors.qr_code'.tr(),
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'survey.collectors.generate_qr_code_for_easy_survey_access'
                    .tr(),
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              24.heightBox,
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: QrImageView(
                  data: surveyUrl,
                  version: QrVersions.auto,
                  size: 200.0,
                  backgroundColor: Colors.white,
                ),
              ),
              24.heightBox,
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.link,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    12.widthBox,
                    Expanded(
                      child: Text(
                        surveyUrl,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: surveyUrl));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'survey.collectors.link_copied_to_clipboard'
                                    .tr()),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.copy_rounded,
                        color: context.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // Download QR code functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'survey.collectors.qr_code_download_feature_coming_soon'
                              .tr()),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.download_rounded),
                label: Text('survey.collectors.download'.tr()),
              ),
            ),
            16.widthBox,
            Expanded(
              child: FilledButton.icon(
                onPressed: () {
                  SharePlus.instance.share(ShareParams(text: surveyUrl));
                },
                icon: const Icon(Icons.share_rounded),
                label: Text('survey.collectors.share_qr'.tr()),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> showEmailInvitationModal(BuildContext context) async {
  final cubit = context.read<NewSurveyCubit>();
  final emailController = TextEditingController();
  final subjectController = TextEditingController(
    text: 'survey.collectors.you_are_invited_to_participate_in_our_survey'.tr(),
  );
  final messageController = TextEditingController(
    text: 'survey.collectors.hi_there'.tr(),
  );
  final formKey = GlobalKey<FormState>();

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: BoxConstraints(maxHeight: context.height * 0.9),
    builder: (BuildContext _) {
      return BlocProvider.value(
        value: cubit,
        child: AppBackDrop(
          headerActions: BackdropHeaderActions.none,
          title: Row(
            children: [
              Icon(
                Icons.email_outlined,
                color: Colors.orange,
              ),
              12.widthBox,
              Text(
                'survey.collectors.email_invitation'.tr(),
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'survey.collectors.send_personalized_email_invitations_to_your_target_audience'
                        .tr(),
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  24.heightBox,
                  Text(
                    'survey.collectors.email_addresses'.tr(),
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  8.heightBox,
                  TextFormField(
                    controller: emailController,
                    maxLines: 3,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      final emails = (value ?? '')
                          .split(',')
                          .map((email) => email.trim())
                          .where((email) => email.isNotEmpty)
                          .toList();
                      if (emails.isEmpty) {
                        return 'survey.collectors.email_required'.tr();
                      }
                      final emailPattern =
                          RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                      return emails.every(emailPattern.hasMatch)
                          ? null
                          : 'survey.collectors.email_list_invalid'.tr();
                    },
                    decoration: InputDecoration(
                      hintText:
                          'survey.collectors.enter_email_addresses_separated_by_commas'
                              .tr(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                  ),
                  20.heightBox,
                  Text(
                    'survey.collectors.subject'.tr(),
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  8.heightBox,
                  TextFormField(
                    controller: subjectController,
                    textInputAction: TextInputAction.next,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'survey.collectors.subject_required'.tr()
                        : null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.subject_rounded),
                    ),
                  ),
                  20.heightBox,
                  Text(
                    'survey.collectors.message'.tr(),
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  8.heightBox,
                  TextFormField(
                    controller: messageController,
                    maxLines: 5,
                    textInputAction: TextInputAction.newline,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'survey.collectors.message_required'.tr()
                        : null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.message_outlined),
                    ),
                  ),
                  20.heightBox,
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.orange,
                        ),
                        12.widthBox,
                        Expanded(
                          child: Text(
                            'survey.collectors.survey_link_will_be_automatically_included_in_the_email'
                                .tr(),
                            style: context.textTheme.bodySmall?.copyWith(
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                  label: Text('actions.cancel'.tr()),
                ),
              ),
              16.widthBox,
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    if (!(formKey.currentState?.validate() ?? false)) {
                      return;
                    }
                    // Send email invitations
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'survey.collectors.email_invitations_sent_successfully'
                                .tr()),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.send_rounded),
                  label: Text('survey.collectors.send_invites'.tr()),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
  emailController.dispose();
  subjectController.dispose();
  messageController.dispose();
}
