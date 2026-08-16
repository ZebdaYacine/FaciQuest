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
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'wallet.cashout_modal.available_balance_info'.tr(
                                  args: [
                                    state.wallet.amount.toStringAsFixed(2)
                                  ]),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: 'wallet.cashout_modal.amount_label'.tr(),
                      hintText: 'wallet.cashout_modal.amount_hint'.tr(),
                      prefixText: 'DA ',
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
                  const SizedBox(height: 16),
                  DropdownButtonFormField<PaymentMethod>(
                    initialValue: _selectedPaymentMethod,
                    decoration: InputDecoration(
                      labelText:
                          'wallet.cashout_modal.payment_method_label'.tr(),
                      border: const OutlineInputBorder(),
                    ),
                    items: PaymentMethod.values.map((method) {
                      return DropdownMenuItem(
                        value: method,
                        child: Text(method.displayName),
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
                  const SizedBox(height: 16),
                  if (_selectedPaymentMethod == PaymentMethod.ccp)
                    TextFormField(
                      controller: _ccpController,
                      decoration: InputDecoration(
                        labelText: 'wallet.cashout_modal.ccp_label'.tr(),
                        hintText: 'wallet.cashout_modal.ccp_hint'.tr(),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _handleSubmit(context, state),
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
                    TextFormField(
                      controller: _ripController,
                      decoration: InputDecoration(
                        labelText: 'wallet.cashout_modal.rip_label'.tr(),
                        hintText: 'wallet.cashout_modal.rip_hint'.tr(),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _handleSubmit(context, state),
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
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
      actions: BlocBuilder<WalletCubit, WalletState>(
        builder: (context, state) {
          return ElevatedButton(
            onPressed: () => _handleSubmit(context, state),
            child: Center(child: Text('wallet.cashout_modal.submit'.tr())),
          );
        },
      ),
    );
  }
}
