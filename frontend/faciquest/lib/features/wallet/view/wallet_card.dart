import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:flutter/material.dart';

class WalletCardWidget extends StatefulWidget {
  const WalletCardWidget({
    super.key,
  });

  @override
  State<WalletCardWidget> createState() => _WalletCardWidgetState();
}

class _WalletCardWidgetState extends State<WalletCardWidget> {
  bool showBalance = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: AppSpacing.spacing_2.padding,
        padding: AppSpacing.spacing_2.padding,
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'wallet',
                  style: context.textTheme.bodyMedium,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        showBalance = !showBalance;
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.remove_red_eye_outlined,
                      ),
                    ),
                    Center(
                      child: Text(
                        showBalance ? '  12.000,00 DZD' : '***********',
                        style: context.textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            IconButton.filled(
              onPressed: () {},
              icon: const Icon(Icons.arrow_outward_rounded),
            ),
            IconButton.filled(
              onPressed: () {},
              icon: const Icon(Icons.add),
            ),
          ],
        ));
  }
}
