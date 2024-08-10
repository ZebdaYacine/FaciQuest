import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:flutter/material.dart';

class QuestionsPage extends StatelessWidget {
  const QuestionsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Questions Section',
              style: context.textTheme.headlineLarge,
            ),
            const Text('Please enter details below'),
            AppSpacing.spacing_2.heightBox,
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return null;
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: 10),
            ),
          ],
        ),
      ),
    );
  }
}
