import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              AppRoutes.profile.push(context);
            },
            child: const CircleAvatar(
              child: Text('YG'),
            ),
          ),
          8.widthBox,
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            8.heightBox,
            Text(
              'Welcome to FaciQuest',
              style: context.textTheme.headlineMedium,
            ),
            8.heightBox,
            const Text('This is where you can view your surveys'),
            const Text('or create a new one'),
            8.heightBox,
            ElevatedButton(
              onPressed: () {
                AppRoutes.manageMySurveys.push(context);
              },
              child: const Text('Manage Surveys'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  return Card(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        AppRoutes.survey.push(
                          context,
                          pathParameters: {
                            'id': '$index',
                          },
                        );
                      },
                      child: Padding(
                        padding: 8.padding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Survey Title $index',
                              style: context.textTheme.headlineSmall,
                            ),
                            AppSpacing.spacing_0_5.heightBox,
                            Text(
                              'Description of survey $index',
                              style: context.textTheme.bodyMedium,
                              maxLines: 2,
                            ),
                            Row(
                              children: [
                                const Spacer(),
                                Text(
                                  '10 DZD',
                                  style:
                                      context.textTheme.titleMedium?.copyWith(
                                    color: Colors.green,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppRoutes.newSurvey.push(
            context,
            pathParameters: {
              'id': '-1',
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
