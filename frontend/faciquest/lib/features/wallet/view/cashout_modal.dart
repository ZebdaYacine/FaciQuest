import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> cashOutModal(BuildContext context) {
  return showModalBottomSheet(
    context: context,
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
  String _email = '';
  double _amount = 0;
  @override
  Widget build(BuildContext context) {
    return AppBackDrop(
      headerActions: BackdropHeaderActions.closeOnly,
      titleText: 'Cash Out',
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email address',
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              onSaved: (value) => _email = value ?? '',
            ),
            const SizedBox(height: 16),
            BlocBuilder<WalletCubit, WalletState>(
              builder: (context, state) {
                return TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    hintText: 'Enter amount to cash out',
                    prefixText: 'DA',
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
                    if (state is WalletLoaded && amount > state.walletBalance) {
                      return 'Amount cannot exceed your wallet balance';
                    }
                    return null;
                  },
                  onSaved: (value) =>
                      _amount = double.tryParse(value ?? '0') ?? 0,
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      actions: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            _formKey.currentState?.save();
            context.read<WalletCubit>().cashOut(_amount, _email);
            Navigator.of(context).pop();
          }
        },
        child: const Center(child: Text('Cash Out')),
      ),
    );
  }
}
