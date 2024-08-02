import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome Youcef'),
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppRoutes.newSurvey.push(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
