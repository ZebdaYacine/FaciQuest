import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> cashOutModal(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: BoxConstraints(maxHeight: context.height * 0.9),
    builder: (_) => BlocProvider.value(
      value: context.read<WalletCubit>(),
      child: const CashOutModal(),
    ),
  );
}

class CashOutModal extends StatefulWidget {
  const CashOutModal({super.key});

  @override
  State<CashOutModal> createState() => _CashOutModalState();
}

class _CashOutModalState extends State<CashOutModal> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _ccpController = TextEditingController();
  final _ripController = TextEditingController();
  PaymentMethod _selectedPaymentMethod = PaymentMethod.ccp;

  @override
  void dispose() {
    _amountController.dispose();
    _ccpController.dispose();
    _ripController.dispose();
    super.dispose();
  }

  void _handleSubmit(BuildContext context, WalletState state) {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (state is! WalletLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('wallet.please_wait_loading'.tr()),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final request = CashOutRequest(
      amount: double.tryParse(_amountController.text) ?? 0.0,
      ccp: _ccpController.text,
      rip: _ripController.text,
      paymentMethod: _selectedPaymentMethod.value,
    );

    context.read<WalletCubit>().cashOutRequest(request);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('wallet.success.cashout_submitted'.tr()),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBackDrop(
      headerActions: BackdropHeaderActions.closeOnly,
      titleText: 'wallet.cashout_modal.title'.tr(),
      body: BlocConsumer<WalletCubit, WalletState>(
        listener: (context, state) {
          if (state is WalletError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          // Pre-fill payment info from loaded wallet
          if (state is WalletLoaded && _ccpController.text.isEmpty) {
            _ccpController.text = state.wallet.ccp;
            _ripController.text = state.wallet.rip;
            _selectedPaymentMethod =
                PaymentMethodExtension.fromString(state.wallet.paymentMethod);
          }

          return Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (state is WalletLoaded)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            context.colorScheme.primaryContainer
                                .withValues(alpha: 0.8),
                            context.colorScheme.secondaryContainer
                                .withValues(alpha: 0.4),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: context.colorScheme.primary
                              .withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: context.colorScheme.primary
                                  .withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.account_balance_wallet_rounded,
                              color: context.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'wallet.cashout_modal.available_balance_info'.tr(
                                  args: [
                                    state.wallet.amount.toStringAsFixed(2)
                                  ]),
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                  EnhancedTextField(
                    controller: _amountController,
                    labelText: 'wallet.cashout_modal.amount_label'.tr(),
                    hintText: 'wallet.cashout_modal.amount_hint'.tr(),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 8, top: 12, bottom: 12),
                      child: Text(
                        'DA',
                        style: context.textTheme.titleMedium?.copyWith(
                          color: context.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'wallet.validation.amount_required'.tr();
                      }
                      final amount = double.tryParse(value);
                      if (amount == null) {
                        return 'wallet.validation.amount_invalid'.tr();
                      }
                      if (amount <= 0) {
                        return 'wallet.validation.amount_positive'.tr();
                      }
                      if (state is WalletLoaded &&
                          amount > state.wallet.amount) {
                        return 'wallet.validation.amount_exceeds_balance'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<PaymentMethod>(
                    initialValue: _selectedPaymentMethod,
                    decoration: InputDecoration(
                      labelText:
                          'wallet.cashout_modal.payment_method_label'.tr(),
                      filled: true,
                      fillColor: context.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: context.colorScheme.outline
                              .withValues(alpha: 0.2),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: context.colorScheme.outline
                              .withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: context.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                    ),
                    icon: Icon(Icons.keyboard_arrow_down_rounded,
                        color: context.colorScheme.primary),
                    items: PaymentMethod.values.map((method) {
                      return DropdownMenuItem(
                        value: method,
                        child: Text(
                          method.displayName,
                          style: context.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedPaymentMethod = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  if (_selectedPaymentMethod == PaymentMethod.ccp)
                    EnhancedTextField(
                      controller: _ccpController,
                      labelText: 'wallet.cashout_modal.ccp_label'.tr(),
                      hintText: 'wallet.cashout_modal.ccp_hint'.tr(),
                      prefixIcon: const Icon(Icons.numbers_rounded),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _handleSubmit(context, state),
                      validator: (value) {
                        if (_selectedPaymentMethod == PaymentMethod.ccp &&
                            (value == null || value.isEmpty)) {
                          return 'wallet.validation.ccp_required'.tr();
                        }
                        return null;
                      },
                    ),
                  if (_selectedPaymentMethod == PaymentMethod.rip ||
                      _selectedPaymentMethod == PaymentMethod.baridimob)
                    EnhancedTextField(
                      controller: _ripController,
                      labelText: 'wallet.cashout_modal.rip_label'.tr(),
                      hintText: 'wallet.cashout_modal.rip_hint'.tr(),
                      prefixIcon: const Icon(Icons.numbers_rounded),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _handleSubmit(context, state),
                      validator: (value) {
                        if ((_selectedPaymentMethod == PaymentMethod.rip ||
                                _selectedPaymentMethod ==
                                    PaymentMethod.baridimob) &&
                            (value == null || value.isEmpty)) {
                          return 'wallet.validation.rip_required'.tr();
                        }
                        return null;
                      },
                    ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
      actions: BlocBuilder<WalletCubit, WalletState>(
        builder: (context, state) {
          final isLoading = state is WalletLoading;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: BouncyButton(
              onTap: isLoading ? null : () => _handleSubmit(context, state),
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: isLoading
                      ? null
                      : LinearGradient(
                          colors: [
                            context.colorScheme.primary,
                            context.colorScheme.primary.withValues(alpha: 0.8),
                          ],
                        ),
                  color: isLoading
                      ? context.colorScheme.onSurface.withValues(alpha: 0.12)
                      : null,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isLoading
                      ? null
                      : [
                          BoxShadow(
                            color: context.colorScheme.primary
                                .withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: Center(
                  child: isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: context.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        )
                      : Text(
                          'wallet.cashout_modal.submit'.tr(),
                          style: context.textTheme.titleMedium?.copyWith(
                            color: context.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
