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
      create: (context) => PersonalInfoCubit(getIt<AuthRepository>()),
      child: BlocListener<PersonalInfoCubit, PersonalInfoState>(
        listener: (context, state) {
          if (state.status == Status.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'personal_info.profile_updated_success'.tr()),
                backgroundColor: context.colorScheme.primary,
              ),
            );
          } else if (state.status == Status.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'personal_info.profile_update_failed'.tr()),
                backgroundColor: context.colorScheme.error,
              ),
            );
          }
        },
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
            actions: [
              BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
                builder: (context, state) {
                  if (state.isEditing) {
                    return Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            context.read<PersonalInfoCubit>().cancelEdit();
                          },
                          icon: const Icon(Icons.close),
                          tooltip: 'personal_info.tooltips.cancel'.tr(),
                        ),
                        IconButton(
                          onPressed: state.isValid
                              ? () {
                                  context.read<PersonalInfoCubit>().saveChanges();
                                }
                              : null,
                          icon: const Icon(Icons.check),
                          tooltip: 'personal_info.tooltips.save'.tr(),
                        ),
                      ],
                    );
                  } else {
                    return IconButton(
                      onPressed: () {
                        context.read<PersonalInfoCubit>().toggleEditMode();
                      },
                      icon: const Icon(Icons.edit),
                      tooltip: 'personal_info.tooltips.edit'.tr(),
                    );
                  }
                },
              ),
            ],
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
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: _PersonalInfoForm(),
            ),
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

class _PersonalInfoFormState extends State<_PersonalInfoForm> with BuildFormMixin {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
      builder: (context, state) {
        final cubit = context.read<PersonalInfoCubit>();
        final user = state.user;
        final isEditing = state.isEditing;

        return SingleChildScrollView(
          child: Column(
            children: [
              // Basic Information Section
              _buildSectionHeader(context, 'personal_info.sections.basic_information'.tr()),
              AppSpacing.spacing_2.heightBox,

              GenericInputField(
                label: 'personal_info.fields.username'.tr(),
                onChanged: isEditing ? cubit.onUsernameChanged : null,
                initialValue: user.username,
                prefix: const Icon(Icons.person_outline_rounded),
                readOnly: !isEditing,
              ),
              AppSpacing.spacing_2.heightBox,

              Row(
                children: [
                  Expanded(
                    child: GenericInputField(
                      label: 'personal_info.fields.first_name'.tr(),
                      onChanged: isEditing ? cubit.onFirstNameChanged : null,
                      initialValue: user.firstName,
                      prefix: const Icon(Icons.badge_outlined),
                      readOnly: !isEditing,
                    ),
                  ),
                  16.widthBox,
                  Expanded(
                    child: GenericInputField(
                      label: 'personal_info.fields.last_name'.tr(),
                      onChanged: isEditing ? cubit.onLastNameChanged : null,
                      initialValue: user.lastName,
                      prefix: const Icon(Icons.badge_outlined),
                      readOnly: !isEditing,
                    ),
                  ),
                ],
              ),
              AppSpacing.spacing_2.heightBox,

              GenericInputField(
                label: 'personal_info.fields.email'.tr(),
                onChanged: isEditing ? cubit.onEmailChanged : null,
                initialValue: user.email,
                prefix: const Icon(Icons.email_outlined),
                readOnly: !isEditing,
                errorMessage: state.emailError,
                keyboardType: TextInputType.emailAddress,
              ),
              AppSpacing.spacing_2.heightBox,

              GenericInputField(
                label: 'personal_info.fields.phone'.tr(),
                onChanged: isEditing ? cubit.onPhoneChanged : null,
                initialValue: user.phone,
                prefix: const Icon(Icons.phone_outlined),
                readOnly: !isEditing,
                errorMessage: state.phoneError,
                keyboardType: TextInputType.phone,
              ),
              AppSpacing.spacing_2.heightBox,

              GenericInputField(
                label: 'personal_info.fields.birth_date'.tr(),
                readOnly: true,
                onTap: isEditing
                    ? () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: user.birthDate ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
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
                      }
                    : null,
                prefix: const Icon(Icons.calendar_today_outlined),
                hintText: 'personal_info.fields.tap_to_select_date'.tr(),
                initialValue: user.birthDate != null ? DateFormat('dd/MM/yyyy').format(user.birthDate!) : '',
              ),
              AppSpacing.spacing_3.heightBox,

              // Personal Details Section
              _buildSectionHeader(context, 'personal_info.sections.personal_details'.tr()),
              AppSpacing.spacing_2.heightBox,

              GenericInputField(
                label: 'personal_info.fields.birth_place'.tr(),
                onChanged: isEditing ? cubit.onBirthPlaceChanged : null,
                initialValue: user.birthPlace ?? '',
                prefix: const Icon(Icons.place_outlined),
                readOnly: !isEditing,
              ),
              AppSpacing.spacing_2.heightBox,

              Row(
                children: [
                  Expanded(
                    child: GenericInputField(
                      label: 'personal_info.fields.country'.tr(),
                      onChanged: isEditing ? cubit.onCountryChanged : null,
                      initialValue: user.country ?? '',
                      prefix: const Icon(Icons.flag_outlined),
                      readOnly: !isEditing,
                    ),
                  ),
                  16.widthBox,
                  Expanded(
                    child: GenericInputField(
                      label: 'personal_info.fields.municipal'.tr(),
                      onChanged: isEditing ? cubit.onMunicipalChanged : null,
                      initialValue: user.municipal ?? '',
                      prefix: const Icon(Icons.location_city_outlined),
                      readOnly: !isEditing,
                    ),
                  ),
                ],
              ),
              AppSpacing.spacing_3.heightBox,

              // Professional Information Section
              _buildSectionHeader(context, 'personal_info.sections.professional_information'.tr()),
              AppSpacing.spacing_2.heightBox,

              GenericInputField(
                label: 'personal_info.fields.education'.tr(),
                onChanged: isEditing ? cubit.onEducationChanged : null,
                initialValue: user.education ?? '',
                prefix: const Icon(Icons.school_outlined),
                readOnly: !isEditing,
              ),
              AppSpacing.spacing_2.heightBox,

              GenericInputField(
                label: 'personal_info.fields.work_at'.tr(),
                onChanged: isEditing ? cubit.onWorkerAtChanged : null,
                initialValue: user.workerAt ?? '',
                prefix: const Icon(Icons.work_outline),
                readOnly: !isEditing,
              ),
              AppSpacing.spacing_2.heightBox,

              GenericInputField(
                label: 'personal_info.fields.institution'.tr(),
                onChanged: isEditing ? cubit.onInstitutionChanged : null,
                initialValue: user.institution ?? '',
                prefix: const Icon(Icons.business_outlined),
                readOnly: !isEditing,
              ),
              AppSpacing.spacing_2.heightBox,

              GenericInputField(
                label: 'personal_info.fields.social_status'.tr(),
                onChanged: isEditing ? cubit.onSocialStatusChanged : null,
                initialValue: user.socialStatus ?? '',
                prefix: const Icon(Icons.people_outline),
                readOnly: !isEditing,
              ),
              AppSpacing.spacing_3.heightBox,

              // Save Button (only show when editing)
              if (isEditing) ...[
                if (state.status == Status.showLoading)
                  const CircularProgressIndicator()
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.isValid && state.hasUnsavedChanges
                          ? () {
                              cubit.saveChanges();
                            }
                          : null,
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
                  ),
                AppSpacing.spacing_2.heightBox,
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      children: [
        Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Divider(
            color: context.colorScheme.primary.withOpacity(0.3),
          ),
        ),
      ],
    );
  }
}
