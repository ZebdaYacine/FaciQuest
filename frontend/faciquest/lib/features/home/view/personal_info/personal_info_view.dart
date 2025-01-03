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
          title: Text(
            'personal_info.title'.tr(),
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: context.colorScheme.surface,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                context.colorScheme.surface,
                context.colorScheme.surface.withOpacity(0.95),
              ],
            ),
          ),
          child: Column(
            children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: _PersonalInfoForm(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'personal_info.save_changes'.tr(),
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onPrimary,
                    ),
                  ),
                ),
              )
            ],
          ),
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
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: context.colorScheme.primary.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 80,
              backgroundColor: context.colorScheme.primaryContainer,
              child: Text(
                'YG',
                style: context.textTheme.displayLarge?.copyWith(
                  color: context.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          AppSpacing.spacing_3.heightBox,
          GenericInputField(
            label: 'personal_info.fields.username'.tr(),
            onChanged: cubit.onUsernameChanged,
            initialValue: user?.username ?? '',
            prefix: const Icon(Icons.person_outline_rounded),
          ),
          AppSpacing.spacing_2.heightBox,
          Row(
            children: [
              Expanded(
                child: GenericInputField(
                  label: 'personal_info.fields.first_name'.tr(),
                  onChanged: cubit.onFirstNameChanged,
                  initialValue: user?.firstName ?? '',
                  prefix: const Icon(Icons.badge_outlined),
                ),
              ),
              16.widthBox,
              Expanded(
                child: GenericInputField(
                  label: 'personal_info.fields.last_name'.tr(),
                  onChanged: cubit.onLastNameChanged,
                  initialValue: user?.lastName ?? '',
                  prefix: const Icon(Icons.badge_outlined),
                ),
              ),
            ],
          ),
          AppSpacing.spacing_2.heightBox,
          GenericInputField(
            label: 'personal_info.fields.email'.tr(),
            onChanged: cubit.onEmailChanged,
            initialValue: user?.email ?? '',
            prefix: const Icon(Icons.email_outlined),
          ),
          AppSpacing.spacing_2.heightBox,
          GenericInputField(
            label: 'personal_info.fields.phone'.tr(),
            onChanged: cubit.onPhoneChanged,
            initialValue: user?.phone ?? '',
            prefix: const Icon(Icons.phone_outlined),
          ),
          AppSpacing.spacing_2.heightBox,
          GenericInputField(
            label: 'personal_info.fields.birth_date'.tr(),
            readOnly: true,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: context.colorScheme.primary,
                        onPrimary: context.colorScheme.onPrimary,
                        surface: context.colorScheme.surface,
                        onSurface: context.colorScheme.onSurface,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (date != null) {
                cubit.onBirthDateChanged(date);
              }
            },
            prefix: const Icon(Icons.calendar_today_outlined),
            hintText: 'personal_info.fields.tap_to_select_date'.tr(),
            initialValue: (user?.birthDate != null)
                ? DateFormat('dd/MM/yyyy').format(user!.birthDate!)
                : '',
          ),
        ],
      ),
    );
  }
}
