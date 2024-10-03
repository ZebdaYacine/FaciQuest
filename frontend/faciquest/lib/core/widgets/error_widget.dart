import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class KErrorWidget extends StatelessWidget {
  const KErrorWidget({
    super.key,
    this.message,
  });
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset(
          'assets/lottie/error.json',
          repeat: false,
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: context.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ]
      ],
    );
  }
}
