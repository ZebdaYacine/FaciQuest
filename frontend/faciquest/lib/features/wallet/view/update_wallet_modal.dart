import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> updateWalletModal(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
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
      titleText: 'Update Wallet Profile',
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
                content: const Text('Wallet updated successfully'),
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      hintText: 'Enter wallet amount',
                      prefixText: 'DA ',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      final amount = double.tryParse(value);
                      if (amount == null) {
                        return 'Please enter a valid number';
                      }
                      if (amount < 0) {
                        return 'Amount cannot be negative';
                      }
                      return null;
                    },
                  ),
                  AppSpacing.spacing_2.heightBox,
                  TextFormField(
                    controller: _nbrSurveysController,
                    decoration: const InputDecoration(
                      labelText: 'Number of Surveys',
                      hintText: 'Enter number of surveys',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter number of surveys';
                      }
                      final number = int.tryParse(value);
                      if (number == null) {
                        return 'Please enter a valid number';
                      }
                      if (number < 0) {
                        return 'Number cannot be negative';
                      }
                      return null;
                    },
                  ),
                  AppSpacing.spacing_2.heightBox,
                  DropdownButtonFormField<PaymentMethod>(
                    initialValue: _selectedPaymentMethod,
                    decoration: const InputDecoration(
                      labelText: 'Payment Method',
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
                      decoration: const InputDecoration(
                        labelText: 'CCP Number',
                        hintText: 'Enter CCP number',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (_selectedPaymentMethod == PaymentMethod.ccp && (value == null || value.isEmpty)) {
                          return 'Please enter CCP number';
                        }
                        return null;
                      },
                    ),
                  if (_selectedPaymentMethod == PaymentMethod.rip || _selectedPaymentMethod == PaymentMethod.baridimob)
                    TextFormField(
                      controller: _ripController,
                      decoration: const InputDecoration(
                        labelText: 'RIP Number',
                        hintText: 'Enter RIP number',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if ((_selectedPaymentMethod == PaymentMethod.rip ||
                                _selectedPaymentMethod == PaymentMethod.baridimob) &&
                            (value == null || value.isEmpty)) {
                          return 'Please enter RIP number';
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
        child: const Center(child: Text('Update Wallet')),
      ),
    );
  }
}
