import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:faciquest/features/survey/view/new_survey/questions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewSurveyView extends StatelessWidget {
  const NewSurveyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewSurveyCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('New Survey'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocSelector<NewSurveyCubit, NewSurveyState, NewSurveyPages>(
              selector: (state) => state.page,
              builder: (context, value) {
                switch (value) {
                  case NewSurveyPages.surveyDetails:
                    return _SurveyDetails();

                  case NewSurveyPages.questions:
                    return QuestionsPage();
                }
              },
            ),
            // Builder(builder: (context) {
            //   return Padding(
            //     padding: AppSpacing.spacing_2.padding,
            //     child: ElevatedButton(
            //       onPressed: () => context.read<NewSurveyCubit>().next(),
            //       child: const Center(child: Text('next')),
            //     ),
            //   );
            // }),
          ],
        ),
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
            onPressed: () => showQuestionModal(context),
            child: Icon(Icons.add),
          );
        }),
      ),
    );
  }
}

class _SurveyDetails extends StatelessWidget {
  const _SurveyDetails();

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SingleChildScrollView(
      child: Padding(
        padding: AppSpacing.spacing_2.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create New Survey',
              style: context.textTheme.headlineLarge,
            ),
            const Text('Please enter details below'),
            AppSpacing.spacing_2.heightBox,
            const _NewSurveyForm(),
          ],
        ),
      ),
    ));
  }
}

class _NewSurveyForm extends StatefulWidget {
  const _NewSurveyForm();

  @override
  State<_NewSurveyForm> createState() => __NewSurveyFormState();
}

class __NewSurveyFormState extends State<_NewSurveyForm> with BuildFormMixin {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NewSurveyCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Survey Name *', style: context.textTheme.bodyLarge),
        buildInputForm(
          'Survey Name',
          onChange: cubit.onSurveyNameChanged,
        ),
        AppSpacing.spacing_2.heightBox,
        Text('Survey Description', style: context.textTheme.bodyLarge),
        buildInputForm(
          'Survey Description',
          maxLines: 3,
          onChange: cubit.onSurveyDescriptionChanged,
        ),
        // AppSpacing.spacing_2.heightBox,
        // Text('Survey Language *', style: context.textTheme.bodyLarge),
        // AppSpacing.spacing_1.heightBox,
        // DropdownButton(
        //   value: 'English',
        //   isExpanded: true,
        //   items: const <DropdownMenuItem<String>>[
        //     DropdownMenuItem(value: 'العربية', child: Text('العربية')),
        //     DropdownMenuItem(
        //       value: 'English',
        //       child: Text('English'),
        //     ),
        //     DropdownMenuItem(
        //       value: 'French',
        //       child: Text('French'),
        //     ),
        //     DropdownMenuItem(
        //       value: 'Spanish',
        //       child: Text('Spanish'),
        //     ),
        //   ],
        //   onChanged: (value) {},
        // ),
        AppSpacing.spacing_2.heightBox,
        Text('Lakert Scale *', style: context.textTheme.bodyLarge),
        AppSpacing.spacing_1.heightBox,
        BlocSelector<NewSurveyCubit, NewSurveyState, LikertScale?>(
          selector: (state) => state.survey.likertScale,
          bloc: cubit,
          builder: (context, value) {
            return DropdownButton(
              isExpanded: true,
              value: value,
              items: LikertScale.values.map(
                (e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e.getValue()),
                  );
                },
              ).toList(),
              onChanged: cubit.onSurveyLikertScaleChanged,
            );
          },
        )
      ],
    );
  }
}
