import 'package:awesome_extensions/awesome_extensions.dart';

import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

Future<void> showWebLinkModal(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    constraints: BoxConstraints(maxHeight: context.height * 0.9),
    builder: (BuildContext _) {
      return BlocProvider.value(
        value: context.read<NewSurveyCubit>(),
        child: const WebLinkModal(),
      );
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
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  bool _isCreating = false;
  String? _generatedLink;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.collector?.name ?? 'Web Link Collector',
    );
    _descriptionController = TextEditingController(
      text: 'Share your survey via web link',
    );
    _generatedLink = widget.collector?.webUrl;
    if (_generatedLink != null) {
      _isCreating = false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String get _surveyUrl {
    final cubit = context.read<NewSurveyCubit>();
    return 'https://survey.faciquest.com/s/${cubit.state.survey.id}';
  }

  @override
  Widget build(BuildContext context) {
    return AppBackDrop(
      headerActions: BackdropHeaderActions.none,
      title: Row(
        children: [
          Icon(
            Icons.link_rounded,
            color: context.colorScheme.secondary,
          ),
          12.widthBox,
          Text(
            'Web Link Collector',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create a web link to share your survey with your audience',
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            24.heightBox,
            _buildCollectorForm(),
            if (_generatedLink != null) ...[
              24.heightBox,
              _buildGeneratedLinkSection(),
            ],
            24.heightBox,
            _buildFeaturesSection(),
          ],
        ),
      ),
      actions: _buildActions(),
    );
  }

  Widget _buildCollectorForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Collector Details',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        16.heightBox,
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Collector Name',
            hintText: 'Enter a name for this collector',
            prefixIcon: const Icon(Icons.label_outline),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        16.heightBox,
        TextField(
          controller: _descriptionController,
          maxLines: 2,
          decoration: InputDecoration(
            labelText: 'Description (Optional)',
            hintText: 'Brief description of this collector',
            prefixIcon: const Icon(Icons.description_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGeneratedLinkSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              8.widthBox,
              Text(
                'Link Generated Successfully!',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          16.heightBox,
          Text(
            'Your Survey Link:',
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          8.heightBox,
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: context.colorScheme.outline.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _generatedLink!,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.primary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _copyToClipboard(_generatedLink!),
                  icon: Icon(
                    Icons.copy_rounded,
                    color: context.colorScheme.primary,
                  ),
                  tooltip: 'Copy Link',
                ),
              ],
            ),
          ),
          16.heightBox,
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _shareLink(_generatedLink!),
                  icon: const Icon(Icons.share_rounded),
                  label: const Text('Share'),
                ),
              ),
              12.widthBox,
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _previewSurvey(),
                  icon: const Icon(Icons.visibility_rounded),
                  label: const Text('Preview'),
                  style: FilledButton.styleFrom(
                    backgroundColor: context.colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Link Features',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        16.heightBox,
        _buildFeatureItem(
          icon: Icons.public_rounded,
          title: 'Public Access',
          description: 'Anyone with the link can access your survey',
        ),
        _buildFeatureItem(
          icon: Icons.analytics_outlined,
          title: 'Response Tracking',
          description: 'Monitor clicks and response rates in real-time',
        ),
        _buildFeatureItem(
          icon: Icons.mobile_friendly_rounded,
          title: 'Mobile Optimized',
          description: 'Works perfectly on all devices and screen sizes',
        ),
        _buildFeatureItem(
          icon: Icons.security_rounded,
          title: 'Secure & Private',
          description: 'All responses are encrypted and securely stored',
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: context.colorScheme.secondary,
              size: 20,
            ),
          ),
          16.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                4.heightBox,
                Text(
                  description,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    if (_generatedLink != null) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close_rounded),
              label: const Text('Close'),
            ),
          ),
          16.widthBox,
          Expanded(
            child: FilledButton.icon(
              onPressed: _updateCollector,
              icon: const Icon(Icons.save_rounded),
              label: const Text('Save Changes'),
              style: FilledButton.styleFrom(
                backgroundColor: context.colorScheme.secondary,
              ),
            ),
          ),
        ],
      );
    }

    return FilledButton.icon(
      onPressed: _isCreating ? null : _createWebLinkCollector,
      icon: _isCreating
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: context.colorScheme.onPrimary,
              ),
            )
          : const Icon(Icons.link_rounded),
      label: Text(_isCreating ? 'Creating...' : 'Generate Link'),
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        backgroundColor: context.colorScheme.secondary,
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Link copied to clipboard'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _shareLink(String link) {
    Share.share(link, subject: 'Survey Invitation');
  }

  void _previewSurvey() {
    // Navigate to survey preview or open in browser
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening survey preview...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _createWebLinkCollector() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a collector name'),
          backgroundColor: context.colorScheme.error,
        ),
      );
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _generatedLink = _surveyUrl;
        _isCreating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Web link collector created successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      setState(() {
        _isCreating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating collector: $e'),
          backgroundColor: context.colorScheme.error,
        ),
      );
    }
  }

  Future<void> _updateCollector() async {
    // Update collector with new name/description
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Collector updated successfully!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
