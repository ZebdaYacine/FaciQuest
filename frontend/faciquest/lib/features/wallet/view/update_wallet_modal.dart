import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> updateWalletModal(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: BoxConstraints(maxHeight: context.height * 0.9),
    builder: (_) => BlocProvider.value(
      value: context.read<WalletCubit>(),
      child: const UpdateWalletModal(),
    ),
  );
}

class UpdateWalletModal extends StatefulWidget {
  const UpdateWalletModal({super.key});

  @override
  State<UpdateWalletModal> createState() => _UpdateWalletModalState();
}

class _UpdateWalletModalState extends State<UpdateWalletModal> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _nbrSurveysController = TextEditingController();
  final _ccpController = TextEditingController();
  final _ripController = TextEditingController();
  PaymentMethod _selectedPaymentMethod = PaymentMethod.ccp;

  @override
  void dispose() {
    _amountController.dispose();
    _nbrSurveysController.dispose();
    _ccpController.dispose();
    _ripController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final request = UpdateWalletRequest(
        amount: double.tryParse(_amountController.text) ?? 0.0,
        nbrSurveys: int.tryParse(_nbrSurveysController.text) ?? 0,
        ccp: _ccpController.text,
        rip: _ripController.text,
        paymentMethod: _selectedPaymentMethod.value,
      );

      context.read<WalletCubit>().updateWallet(request);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackDrop(
      headerActions: BackdropHeaderActions.closeOnly,
      titleText: 'wallet.update_modal.title'.tr(),
      body: BlocConsumer<WalletCubit, WalletState>(
        listener: (context, state) {
          if (state is WalletError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: context.colorScheme.error,
              ),
            );
          } else if (state is WalletLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('wallet.success.updated'.tr()),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is WalletLoading || state is WalletUpdating) {
            return const Center(
              child: CircularProgressIndicator(),
            );
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
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: 'wallet.update_modal.amount_label'.tr(),
                      hintText: 'wallet.update_modal.amount_hint'.tr(),
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
                      if (amount < 0) {
                        return 'wallet.validation.amount_non_negative'.tr();
                      }
                      return null;
                    },
                  ),
                  AppSpacing.spacing_2.heightBox,
                  TextFormField(
                    controller: _nbrSurveysController,
                    decoration: InputDecoration(
                      labelText: 'wallet.update_modal.surveys_label'.tr(),
                      hintText: 'wallet.update_modal.surveys_hint'.tr(),
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'wallet.validation.surveys_required'.tr();
                      }
                      final number = int.tryParse(value);
                      if (number == null) {
                        return 'wallet.validation.surveys_invalid'.tr();
                      }
                      if (number < 0) {
                        return 'wallet.validation.surveys_non_negative'.tr();
                      }
                      return null;
                    },
                  ),
                  AppSpacing.spacing_2.heightBox,
                  DropdownButtonFormField<PaymentMethod>(
                    initialValue: _selectedPaymentMethod,
                    decoration: InputDecoration(
                      labelText:
                          'wallet.update_modal.payment_method_label'.tr(),
                      border: OutlineInputBorder(),
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
                  AppSpacing.spacing_2.heightBox,
                  if (_selectedPaymentMethod == PaymentMethod.ccp)
                    TextFormField(
                      controller: _ccpController,
                      decoration: InputDecoration(
                        labelText: 'wallet.update_modal.ccp_label'.tr(),
                        hintText: 'wallet.update_modal.ccp_hint'.tr(),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _handleSubmit(),
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
                        labelText: 'wallet.update_modal.rip_label'.tr(),
                        hintText: 'wallet.update_modal.rip_hint'.tr(),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _handleSubmit(),
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
                  AppSpacing.spacing_3.heightBox,
                ],
              ),
            ),
          );
        },
      ),
      actions: ElevatedButton(
        onPressed: _handleSubmit,
        child: Center(child: Text('wallet.update_modal.submit'.tr())),
      ),
    );
  }
}
