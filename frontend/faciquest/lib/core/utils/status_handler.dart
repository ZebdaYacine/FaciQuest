import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:flutter/material.dart';

void statusHandler(
  BuildContext context,
  Status status, {
  String? msg,
  bool handleLoading = true,
  bool handleInfo = true,
  bool handleSuccess = true,
  bool handleFailure = true,
  Duration? duration,
}) {
  duration ??= 2.seconds;
  switch (status) {
    case Status.initial:
    case Status.success:
      if (handleSuccess) {
        if (msg != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: const SizedBox(),
              duration: duration,
            ),
          );
        }
      }
    case Status.showLoading:
      if (handleLoading) {
        showDialog<void>(
          barrierColor: const Color(0x01000000),
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              actions: [
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            );
          },
        );
      }
    case Status.hideLoading:
      if (handleLoading) {
        Navigator.pop(context);
      }
    case Status.info:
      if (handleInfo) {
        if (msg != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: context.colorScheme.surfaceContainer,
              elevation: 0,
              content: Text(
                msg,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
              duration: duration,
            ),
          );
        }
      }
    case Status.failure:
      if (handleFailure) {
        if (msg != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: context.colorScheme.errorContainer,
              elevation: 0,
              content: Text(
                msg,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.onErrorContainer,
                ),
              ),
              duration: duration,
            ),
          );
        }
      }
  }
}
