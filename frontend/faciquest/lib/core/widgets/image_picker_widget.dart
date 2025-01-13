import 'dart:io';
import 'dart:typed_data';

import 'package:faciquest/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatelessWidget {
  const ImagePickerWidget({
    super.key,
    this.image,
    this.imageBytes,
    this.imageUrl,
    this.onImageSelected,
    this.fit = BoxFit.cover,
    this.useImageBytes = false,
    this.radius,
  });
  final File? image;
  final Uint8List? imageBytes;
  final bool useImageBytes;
  final String? imageUrl;
  final ValueChanged<File?>? onImageSelected;
  final BoxFit fit;
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: () {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return AppBackDrop(
            headerActions: BackdropHeaderActions.none,
            titleText: 'Pick an image ',
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text('Camera'),
                  onTap: () async {
                    final image = await ImagePicker().pickImage(
                      source: ImageSource.camera,
                      imageQuality: 70,
                    );
                    if (image != null) {
                      onImageSelected?.call(File(image.path));
                    }
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Gallery'),
                  leading: const Icon(Icons.image_outlined),
                  onTap: () async {
                    final image = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 70,
                    );
                    if (image != null) {
                      onImageSelected?.call(File(image.path));
                    }
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      );
    }, child: Builder(builder: (context) {
      if (useImageBytes && imageBytes != null) {
        return Image.memory(
          imageBytes!,
          fit: fit,
        );
      }

      if (image != null) {
        return Image.file(
          image!,
          fit: fit,
        );
      }

      if (imageUrl != null) {
        return Image.network(
          imageUrl!,
          fit: fit,
        );
      }
      return Ink(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade400,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Icon(
              Icons.upload_rounded,
              size: 60,
              color: Colors.grey.shade400,
            ),
          ),
        ),
      );
    }));
  }
}
