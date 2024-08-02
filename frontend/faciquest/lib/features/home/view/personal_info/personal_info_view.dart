import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalInfoView extends StatelessWidget {
  const PersonalInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PersonalInfoCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Personal Info'),
        ),
        body: Column(
          children: [
            const Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: _PersonalInfoForm(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {},
                child: const Center(child: Text('Save')),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _PersonalInfoForm extends StatefulWidget {
  const _PersonalInfoForm();

  @override
  State<_PersonalInfoForm> createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends State<_PersonalInfoForm>
    with BuildFormMixin {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PersonalInfoCubit>();
    return SingleChildScrollView(
      child: Column(
        children: [
          CircleAvatar(
            radius: 80,
            child: Text(
              'YG',
              style: context.textTheme.displayLarge,
            ),
          ),
          buildInputForm('Username', onChange: cubit.onUsernameChanged),
          buildInputForm('First Name', onChange: cubit.onFirstNameChanged),
          buildInputForm('Last Name', onChange: cubit.onLastNameChanged),
          buildInputForm('Email', onChange: cubit.onEmailChanged),
          buildInputForm('Phone', onChange: cubit.onPhoneChanged),
        ],
      ),
    );
  }
}
