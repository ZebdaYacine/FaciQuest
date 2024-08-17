import 'dart:io';

import 'package:faciquest/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatelessWidget {
  const ImagePickerWidget(
      {super.key,
      this.image,
      this.imageUrl,
      this.onImageSelected,
      this.fit = BoxFit.cover,
      this.radius});
  final File? image;
  final String? imageUrl;
  final ValueChanged<File?>? onImageSelected;
  final BoxFit fit;
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
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
                    leading: Icon(Icons.camera_alt_outlined),
                    title: const Text('Camera'),
                    onTap: () async {
                      final image = await ImagePicker().pickImage(
                        source: ImageSource.camera,
                        imageQuality: 70,
                      );
                      if (image != null) {
                        onImageSelected?.call(File(image.path));
                      }
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Gallery'),
                    leading: Icon(Icons.image_outlined),
                    onTap: () async {
                      final image = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 70,
                      );
                      if (image != null) {
                        onImageSelected?.call(File(image.path));
                      }
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      child: image != null
          ? Image.file(
              image!,
              fit: fit,
            )
          : imageUrl != null
              ? Image.network(
                  imageUrl!,
                  fit: fit,
                )
              : Ink(
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
                ),
    );
  }
}
