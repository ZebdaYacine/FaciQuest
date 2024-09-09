import 'dart:io';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FileUploadQuestionPreview extends StatefulWidget {
  const FileUploadQuestionPreview({
    required this.question,
    super.key,
  });
  final FileUploadQuestion question;

  @override
  State<FileUploadQuestionPreview> createState() =>
      _FileUploadQuestionPreviewState();
}

class _FileUploadQuestionPreviewState extends State<FileUploadQuestionPreview> {
  bool isLoading = false;
  File? file;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.question.instructions != null) ...[
          Text(widget.question.instructions!),
          AppSpacing.spacing_1.heightBox,
        ],
        ElevatedButton.icon(
          icon: isLoading
              ? const CircularProgressIndicator()
              : const Icon(Icons.cloud_upload_outlined),
          onPressed: () async {
            try {
              isLoading = true;
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: widget.question.allowedExtensions
                    .expand(
                      (element) => element.allowedExtensions,
                    )
                    .toList(),
              );
              if (result?.files.firstOrNull != null) {
                file = File(result!.files.first.path!);
              }
              isLoading = false;
              setState(() {});
            } on Exception catch (_) {}
          },
          label: const Text('Pick File'),
        ),
        if (file != null) ...[
          // AppSpacing.spacing_1.heightBox,
          // Text(file!.name),
          // AppSpacing.spacing_1.heightBox,
          // Text(file!.size.toString()),
          AppSpacing.spacing_1.heightBox,
          Text(file!.path),
        ]
      ],
    );
  }
}
