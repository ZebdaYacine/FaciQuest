import 'dart:io';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

Future<void> showPaymentModal(BuildContext context,
    {double? price, String? collectorId}) async {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: BoxConstraints(maxHeight: context.height * 0.9),
    builder: (context) {
      return PaymentModal(price: price ?? 0.0, collectorId: collectorId);
    },
  ).catchError((error) {
    debugPrint('Error showing payment modal: $error');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('error.generic'.tr())),
      );
    }
  });
}

class PaymentModal extends StatefulWidget {
  const PaymentModal({super.key, required this.price, this.collectorId});
  final double price;
  final String? collectorId;

  @override
  State<PaymentModal> createState() => _PaymentModalState();
}

class _PaymentModalState extends State<PaymentModal> {
  final _formKey = GlobalKey<FormState>();
  final _billingEmailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  bool _sendRenewalReceipts = true;
  bool _isProcessingPayment = false;

  // File upload related
  XFile? _baridiMobProofFile;
  XFile? _ccpProofFile;
  bool _isUploadingBaridiMob = false;
  bool _isUploadingCcp = false;
  final ImagePicker _imagePicker = ImagePicker();

  // Survey repository for API calls
  late final SurveyRepository _surveyRepository;

  // Constants for validation
  static const int _maxFileSizeInMB = 5;
  static const int _maxFileSizeInBytes = _maxFileSizeInMB * 1024 * 1024;
  static const List<String> _allowedImageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'pdf'
  ];

  @override
  void initState() {
    super.initState();
    _surveyRepository = getIt.get<SurveyRepository>();
  }

  @override
  void dispose() {
    _billingEmailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  String _getFileExtension(String fileName) {
    return fileName.toLowerCase().split('.').last;
  }

  bool _isValidFileType(String fileName) {
    final extension = _getFileExtension(fileName);
    return _allowedImageExtensions.contains(extension);
  }

  Future<bool> _isValidFileSize(XFile file) async {
    final fileSize = await file.length();
    return fileSize <= _maxFileSizeInBytes;
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<void> _copyToClipboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('payment.copied_success'.tr())),
        );
      }
    } catch (e) {
      debugPrint('Failed to copy to clipboard: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('payment.copy_failed'.tr())),
        );
      }
    }
  }

  Future<void> _handleFileUpload({required bool isBaridiMob}) async {
    try {
      if (isBaridiMob) {
        setState(() => _isUploadingBaridiMob = true);
      } else {
        setState(() => _isUploadingCcp = true);
      }

      final result = await _showFilePickerOptions();
      if (result != null) {
        // Validate file
        if (!_isValidFileType(result.name)) {
          _showErrorSnackBar('payment.invalid_file_type'.tr());
          return;
        }

        if (!(await _isValidFileSize(result))) {
          _showErrorSnackBar(
              '${'payment.file_too_large'.tr()} (Max: $_maxFileSizeInMB MB)');
          return;
        }

        setState(() {
          if (isBaridiMob) {
            _baridiMobProofFile = result;
          } else {
            _ccpProofFile = result;
          }
        });

        _showSuccessSnackBar(
          '${('payment.file_uploaded_success'.tr())}: ${result.name}',
        );
      }
    } catch (e) {
      debugPrint('Error uploading file: $e');
      _showErrorSnackBar('payment.upload_file_error'.tr());
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingBaridiMob = false;
          _isUploadingCcp = false;
        });
      }
    }
  }

  Future<XFile?> _showFilePickerOptions() async {
    return await showModalBottomSheet<XFile?>(
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'payment.file_source_title'.tr(),
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildFileOption(
                icon: Icons.camera_alt,
                title: 'payment.camera'.tr(),
                onTap: () async {
                  final file = await _imagePicker.pickImage(
                    source: ImageSource.camera,
                    maxWidth: 1920,
                    maxHeight: 1080,
                    imageQuality: 85,
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context, file);
                },
              ),
              _buildFileOption(
                icon: Icons.photo_library,
                title: 'payment.photo_gallery'.tr(),
                onTap: () async {
                  final file = await _imagePicker.pickImage(
                    source: ImageSource.gallery,
                    maxWidth: 1920,
                    maxHeight: 1080,
                    imageQuality: 85,
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context, file);
                },
              ),
              _buildFileOption(
                icon: Icons.folder,
                title: 'payment.files'.tr(),
                onTap: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: _allowedImageExtensions,
                    allowMultiple: false,
                  );
                  if (!context.mounted) return;
                  if (result?.files.single != null) {
                    final platformFile = result!.files.single;
                    final xFile = XFile(
                      platformFile.path!,
                      name: platformFile.name,
                      length: platformFile.size,
                    );
                    Navigator.pop(context, xFile);
                  } else {
                    Navigator.pop(context, null);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: context.colorScheme.primary),
      title: Text(title),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: context.colorScheme.error,
        ),
      );
    }
  }

  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showInfoSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: context.colorScheme.primary,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildUploadedFilePreview(XFile? file,
      {required VoidCallback onRemove}) {
    if (file == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              _getFileExtension(file.name) == 'pdf'
                  ? Icons.picture_as_pdf
                  : Icons.image,
              color: context.colorScheme.primary,
              size: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.name,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  FutureBuilder<int>(
                    future: file.length(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          _formatFileSize(snapshot.data!),
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onRemove,
              icon: Icon(
                Icons.delete_outline,
                color: context.colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check if collectorId is available
    if (widget.collectorId == null || widget.collectorId!.isEmpty) {
      _showErrorSnackBar(
          'Payment error: Collector ID not found. Please try again.');
      return;
    }

    // Check if at least one proof of payment is uploaded
    if (_baridiMobProofFile == null && _ccpProofFile == null) {
      _showErrorSnackBar('payment.upload_proof_required'.tr());
      return;
    }

    setState(() {
      _isProcessingPayment = true;
    });

    try {
      // Upload files sequentially to avoid overwhelming the server
      // and to provide better progress feedback

      int totalFiles = 0;
      int uploadedFiles = 0;

      if (_baridiMobProofFile != null) totalFiles++;
      if (_ccpProofFile != null) totalFiles++;

      // Upload Baridi Mob proof if available
      if (_baridiMobProofFile != null) {
        debugPrint('Uploading Baridi Mob proof: ${_baridiMobProofFile!.name}');
        final baridiMobFile = File(_baridiMobProofFile!.path);

        // Validate file exists
        if (!await baridiMobFile.exists()) {
          throw Exception(
              'Baridi Mob proof file not found. Please re-select the file.');
        }

        // Show progress
        _showInfoSnackBar(
            '${'payment.uploading'.tr()} Baridi Mob... (${uploadedFiles + 1}/$totalFiles)');

        await _surveyRepository.confirmPayment(
            widget.collectorId!, baridiMobFile);
        uploadedFiles++;

        debugPrint('Successfully uploaded Baridi Mob proof');
      }

      // Upload CCP proof if available
      if (_ccpProofFile != null) {
        debugPrint('Uploading CCP proof: ${_ccpProofFile!.name}');
        final ccpFile = File(_ccpProofFile!.path);

        // Validate file exists
        if (!await ccpFile.exists()) {
          throw Exception(
              'CCP proof file not found. Please re-select the file.');
        }

        // Show progress
        _showInfoSnackBar(
            '${'payment.uploading'.tr()} CCP... (${uploadedFiles + 1}/$totalFiles)');

        await _surveyRepository.confirmPayment(widget.collectorId!, ccpFile);
        uploadedFiles++;

        debugPrint('Successfully uploaded CCP proof');
      }

      if (mounted) {
        Navigator.of(context).pop();
        _showSuccessSnackBar('payment.payment_submitted_success'.tr());
      }
    } catch (e) {
      debugPrint('Payment error: $e');
      String errorMessage = 'payment.payment_failed'.tr();

      // Handle specific error types
      if (e.toString().contains('network') ||
          e.toString().contains('connection')) {
        errorMessage = 'payment.network_error'.tr();
      } else if (e.toString().contains('file') ||
          e.toString().contains('upload')) {
        errorMessage = 'payment.upload_file_error'.tr();
      }

      _showErrorSnackBar(errorMessage);
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingPayment = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackDrop(
      showDivider: false,
      showHeaderContent: false,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'payment.billing_details'.tr(),
              style: context.textTheme.titleLarge,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _billingEmailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'payment.billing_email'.tr(),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'payment.validation.email_required'.tr();
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'payment.validation.email_invalid'.tr();
                          }
                          return null;
                        },
                      ),
                      AppSpacing.spacing_1.heightBox,
                      TextFormField(
                        controller: _firstNameController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'payment.first_name'.tr(),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'payment.validation.first_name_required'
                                .tr();
                          }
                          return null;
                        },
                      ),
                      AppSpacing.spacing_1.heightBox,
                      TextFormField(
                        controller: _lastNameController,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).unfocus(),
                        decoration: InputDecoration(
                          labelText: 'payment.last_name'.tr(),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'payment.validation.last_name_required'.tr();
                          }
                          return null;
                        },
                      ),
                      CheckboxListTile(
                        value: _sendRenewalReceipts,
                        controlAffinity: ListTileControlAffinity.leading,
                        dense: true,
                        onChanged: (value) {
                          setState(() {
                            _sendRenewalReceipts = value ?? true;
                          });
                        },
                        title: Text('payment.send_renewal_receipts'.tr()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AppSpacing.spacing_2.heightBox,
            Text(
              'payment.payment_method'.tr(),
              style: context.textTheme.titleLarge,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    ExpansionTile(
                      title: Text('payment.baridi_mob'.tr()),
                      initiallyExpanded: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text('payment.rip'.tr()),
                              InkWell(
                                onTap: () =>
                                    _copyToClipboard('0799992017867632'),
                                child: Ink(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text('0799992017867632'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.spacing_1.heightBox,
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: _isUploadingBaridiMob
                                    ? null
                                    : () =>
                                        _handleFileUpload(isBaridiMob: true),
                                child: Center(
                                  child: Column(
                                    children: [
                                      AppSpacing.spacing_1.heightBox,
                                      _isUploadingBaridiMob
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2),
                                            )
                                          : const Icon(Icons.upload_file),
                                      AppSpacing.spacing_1.heightBox,
                                      Text(
                                        _isUploadingBaridiMob
                                            ? 'payment.uploading'.tr()
                                            : 'payment.upload_proof'.tr(),
                                      ),
                                      AppSpacing.spacing_1.heightBox,
                                    ],
                                  ),
                                ),
                              ),
                              _buildUploadedFilePreview(
                                _baridiMobProofFile,
                                onRemove: () {
                                  setState(() {
                                    _baridiMobProofFile = null;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.spacing_2.heightBox,
                      ],
                    ),
                    ExpansionTile(
                      title: Text('payment.ccp_transfer'.tr()),
                      initiallyExpanded: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text('payment.ccp'.tr()),
                              InkWell(
                                onTap: () => _copyToClipboard('20178676'),
                                child: Ink(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text('20178676'),
                                ),
                              ),
                              AppSpacing.spacing_1.widthBox,
                              Text('payment.key'.tr()),
                              InkWell(
                                onTap: () => _copyToClipboard('32'),
                                child: Ink(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text('32'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0).copyWith(top: 0),
                          child: Row(
                            children: [
                              Text('payment.to'.tr()),
                              InkWell(
                                onTap: () => _copyToClipboard('Goudjal Youcef'),
                                child: Ink(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text('Goudjal Youcef'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: _isUploadingCcp
                                    ? null
                                    : () =>
                                        _handleFileUpload(isBaridiMob: false),
                                child: Center(
                                  child: Column(
                                    children: [
                                      AppSpacing.spacing_1.heightBox,
                                      _isUploadingCcp
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2),
                                            )
                                          : const Icon(Icons.upload_file),
                                      AppSpacing.spacing_1.heightBox,
                                      Text(
                                        _isUploadingCcp
                                            ? 'payment.uploading'.tr()
                                            : 'payment.upload_proof'.tr(),
                                      ),
                                      AppSpacing.spacing_1.heightBox,
                                    ],
                                  ),
                                ),
                              ),
                              _buildUploadedFilePreview(
                                _ccpProofFile,
                                onRemove: () {
                                  setState(() {
                                    _ccpProofFile = null;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.spacing_2.heightBox,
                      ],
                    ),
                    ExpansionTile(
                      title: Text('payment.edahabia_card'.tr()),
                      subtitle: Text('payment.ccp_card'.tr()),
                      children: [
                        Text('payment.coming_soon'.tr()),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "\u2022",
                          style: TextStyle(fontSize: 30),
                        ), //bullet text
                        AppSpacing.spacing_1.widthBox,
                        Expanded(
                          child: RichText(
                            maxLines: 2,
                            text: TextSpan(
                              style: context.textTheme.bodySmall,
                              children: [
                                TextSpan(
                                  text: 'payment.bank_transfer_info'.tr(),
                                  style: context.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.spacing_1.heightBox,
                    Row(
                      children: [
                        const Text(
                          "\u2022",
                          style: TextStyle(fontSize: 30),
                        ), //bullet text
                        AppSpacing.spacing_1.widthBox,
                        Expanded(
                          child: Text(
                            'payment.activation_info'.tr(),
                            style: context.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      actions: Column(
        children: [
          Row(
            children: [
              Text(
                'payment.total'.tr(),
                style: context.textTheme.titleLarge,
              ),
              const Spacer(),
              Text(
                '${widget.price.toStringAsFixed(2).replaceAll('.', ',')} DZD',
                style: context.textTheme.titleLarge,
              ),
            ],
          ),
          AppSpacing.spacing_2.heightBox,
          FilledButton(
            onPressed: _isProcessingPayment ? null : _handlePayment,
            child: Center(
              child: _isProcessingPayment
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text('payment.pay'.tr()),
            ),
          ),
        ],
      ),
    );
  }
}
