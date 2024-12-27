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
      padding: AppSpacing.spacing_3.padding,
      height: 196,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colorScheme.primary,
            context.colorScheme.primaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: BlocBuilder<WalletCubit, WalletState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_rounded,
                    color: context.colorScheme.onPrimary,
                    size: 28,
                  ),
                  AppSpacing.spacing_2.widthBox,
                  Text(
                    'Wallet Balance',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      showBalance = !showBalance;
                      setState(() {});
                    },
                    icon: Icon(
                      showBalance ? Icons.visibility_off : Icons.visibility,
                      color: context.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
              AppSpacing.spacing_2.heightBox,
              Text(
                showBalance
                    ? (state is WalletLoaded)
                        ? '${state.walletBalance.toStringAsFixed(2).replaceAll('.', ',')} DA'
                        : '.....'
                    : '***********',
                style: context.textTheme.headlineMedium?.copyWith(
                  color: context.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: () => cashOutModal(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: context.colorScheme.onPrimary,
                    foregroundColor: context.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  icon: Icon(
                    Icons.arrow_outward_rounded,
                    color: context.colorScheme.primary,
                  ),
                  label: const Text('Cash Out'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
