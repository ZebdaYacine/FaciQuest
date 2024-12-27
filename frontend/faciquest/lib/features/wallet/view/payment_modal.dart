import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:flutter/material.dart';

showPaymentModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    constraints: BoxConstraints(maxHeight: context.height * 0.9),
    builder: (context) {
      return const PaymentModal();
    },
  );
}

class PaymentModal extends StatelessWidget {
  const PaymentModal({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackDrop(
      showDivider: false,
      showHeaderContent: false,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Billing Details *',
              style: context.textTheme.titleLarge,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Billing Email :',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    AppSpacing.spacing_1.heightBox,
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'First Name :',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    AppSpacing.spacing_1.heightBox,
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Last Name :',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    CheckboxListTile(
                      value: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                      onChanged: (value) {},
                      title: const Text('Send me renewal receipts by email'),
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.spacing_2.heightBox,
            Text(
              'Payment Method *',
              style: context.textTheme.titleLarge,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    ExpansionTile(
                      title: const Text('Baridi Mob'),
                      initiallyExpanded: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Text(
                                'Rip : ',
                              ),
                              InkWell(
                                onTap: () {
                                  // TODO copy to clipboard
                                },
                                child: Ink(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text('0799992017867632'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.spacing_1.heightBox,
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {},
                            child: Center(
                              child: Column(
                                children: [
                                  AppSpacing.spacing_1.heightBox,
                                  const Icon(Icons.upload_file),
                                  AppSpacing.spacing_1.heightBox,
                                  const Text('Upload proof of payment'),
                                  AppSpacing.spacing_1.heightBox,
                                ],
                              ),
                            ),
                          ),
                        ),
                        AppSpacing.spacing_2.heightBox,
                      ],
                    ),
                    ExpansionTile(
                      title: const Text('CCP Transfer'),
                      initiallyExpanded: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Text(
                                'ccp : ',
                              ),
                              InkWell(
                                onTap: () {
                                  // TODO copy to clipboard
                                },
                                child: Ink(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text('20178676'),
                                ),
                              ),
                              AppSpacing.spacing_1.widthBox,
                              const Text('Key : '),
                              InkWell(
                                onTap: () {
                                  // TODO copy to clipboard
                                },
                                child: Ink(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text('32'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0).copyWith(top: 0),
                          child: Row(
                            children: [
                              const Text(
                                'to : ',
                              ),
                              InkWell(
                                onTap: () {
                                  // TODO copy to clipboard
                                },
                                child: Ink(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text('Goudjal Youcef'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {},
                            child: Center(
                              child: Column(
                                children: [
                                  AppSpacing.spacing_1.heightBox,
                                  const Icon(Icons.upload_file),
                                  AppSpacing.spacing_1.heightBox,
                                  const Text('Upload proof of payment'),
                                  AppSpacing.spacing_1.heightBox,
                                ],
                              ),
                            ),
                          ),
                        ),
                        AppSpacing.spacing_2.heightBox,
                      ],
                    ),
                    const ExpansionTile(
                      title: Text('Edahabia card'),
                      subtitle: Text('CCP card'),
                      children: [
                        Text('coming soon'),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "\u2022",
                          style: TextStyle(fontSize: 30),
                        ), //bullet text
                        AppSpacing.spacing_1.widthBox,
                        Expanded(
                          child: RichText(
                            maxLines: 2,
                            text: TextSpan(
                              style: context.textTheme.bodySmall,
                              children: [
                                TextSpan(
                                  text: 'Direct bank deposit or wire transfer ',
                                  style: context.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(
                                  text:
                                      '(3-5 business days from when you send the transfer)',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.spacing_1.heightBox,
                    Row(
                      children: [
                        const Text(
                          "\u2022",
                          style: TextStyle(fontSize: 30),
                        ), //bullet text
                        AppSpacing.spacing_1.widthBox,
                        Expanded(
                          child: Text(
                            'The collector will be activated once payment clears.',
                            style: context.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      actions: Column(
        children: [
          Row(
            children: [
              Text(
                'Total :',
                style: context.textTheme.titleLarge,
              ),
              const Spacer(),
              Text(
                '300,00 DZD',
                style: context.textTheme.titleLarge,
              ),
            ],
          ),
          AppSpacing.spacing_2.heightBox,
          FilledButton(
            onPressed: () {},
            child: const Center(child: Text('Pay')),
          ),
        ],
      ),
    );
  }
}
