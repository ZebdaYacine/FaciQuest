import 'dart:ui';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state_views.dart';
part 'home_survey_card.dart';
part 'home_header.dart';
part 'home_survey_section.dart';
part 'home_survey_list.dart';
part 'home_new_survey_fab.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(getIt<SurveyRepository>()),
      child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.colorScheme.surface,
                  context.colorScheme.surfaceContainerLowest,
                  context.colorScheme.surface.withValues(alpha: 0.98),
                ],
              ),
            ),
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<HomeCubit>().fetchSurveys();
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  const HomeHeaderSliver(),
                  const HomeSurveySectionHeader(),
                  const HomeSurveyListSliver(),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 32),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: const HomeNewSurveyFab()),
    );
  }
}
