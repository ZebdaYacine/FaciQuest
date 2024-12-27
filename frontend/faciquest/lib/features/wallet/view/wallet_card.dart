import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        child: BlocBuilder<WalletCubit, WalletState>(
          builder: (context, state) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                        showBalance
                            ? (state is WalletLoaded)
                                ? '${state.walletBalance.toStringAsFixed(2).replaceAll('.', ',')} DA'
                                : '.....'
                            : '***********',
                        style: context.textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton.filled(
                  onPressed: () {
                    cashOutModal(context);
                  },
                  icon: const Icon(Icons.arrow_outward_rounded),
                ),
              ],
            );
          },
        ));
  }
}
