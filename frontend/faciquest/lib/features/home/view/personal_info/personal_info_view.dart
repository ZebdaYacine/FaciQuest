import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
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
    final user = getIt<AuthBloc>().state.user;
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
          AppSpacing.spacing_2.heightBox,
          GenericInputField(
            label: 'Username',
            onChanged: cubit.onUsernameChanged,
            initialValue: user?.username ?? '',
          ),
          AppSpacing.spacing_1.heightBox,
          Row(
            children: [
              Expanded(
                child: GenericInputField(
                  label: 'First Name',
                  onChanged: cubit.onFirstNameChanged,
                  initialValue: user?.firstName ?? '',
                ),
              ),
              8.widthBox,
              Expanded(
                child: GenericInputField(
                  label: 'Last Name',
                  onChanged: cubit.onLastNameChanged,
                  initialValue: user?.lastName ?? '',
                ),
              ),
            ],
          ),
          AppSpacing.spacing_1.heightBox,
          GenericInputField(
            label: 'Email',
            onChanged: cubit.onEmailChanged,
            initialValue: user?.email ?? '',
          ),
          AppSpacing.spacing_1.heightBox,
          GenericInputField(
            label: 'Phone',
            onChanged: cubit.onPhoneChanged,
            initialValue: user?.phone ?? '',
          ),
          AppSpacing.spacing_1.heightBox,
          GenericInputField(
            label: 'Date of Birth',
            readOnly: true,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                cubit.onBirthDateChanged(date);
              }
            },
            hintText: 'tap to select date',
            initialValue: (user?.birthDate != null)
                ? DateFormat('dd/MM/yyyy').format(user!.birthDate!)
                : '',
          ),
        ],
      ),
    );
  }
}
