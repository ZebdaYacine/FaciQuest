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
      if (handleSuccess && msg != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor:
                context.colorScheme.primaryContainer.withOpacity(0.95),
            elevation: 2,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(8),
            content: Row(
              children: [
                Icon(Icons.check_circle,
                    color: context.colorScheme.onPrimaryContainer),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    msg,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            duration: duration,
          ),
        );
      }
    case Status.showLoading:
      if (handleLoading) {
        showDialog<void>(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: Card(
                color: context.colorScheme.surface.withOpacity(0.9),
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                          color: context.colorScheme.primary),
                      if (msg != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          msg,
                          style: context.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    case Status.hideLoading:
      if (handleLoading) {
        Navigator.pop(context);
      }
    case Status.info:
      if (handleInfo && msg != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor:
                context.colorScheme.secondaryContainer.withOpacity(0.95),
            elevation: 2,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(8),
            content: Row(
              children: [
                Icon(Icons.info_outline,
                    color: context.colorScheme.onSecondaryContainer),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    msg,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            duration: duration,
          ),
        );
      }
    case Status.failure:
      if (handleFailure && msg != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor:
                context.colorScheme.errorContainer.withOpacity(0.95),
            elevation: 2,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(8),
            content: Row(
              children: [
                Icon(Icons.error_outline,
                    color: context.colorScheme.onErrorContainer),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    msg,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
            duration: duration,
          ),
        );
      }
  }
}
