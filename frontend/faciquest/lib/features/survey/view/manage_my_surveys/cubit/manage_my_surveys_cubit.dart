import 'dart:async';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'manage_my_surveys_state.dart';

class ManageMySurveysCubit extends Cubit<ManageMySurveysState> {
  ManageMySurveysCubit(this.repository)
      : super(ManageMySurveysState(
          status: Status.showLoading,
        ));
  final SurveyRepository repository;
  Timer? _debounceTimer;

  void onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      emit(state.copyWith(searchQuery: value));
    });
  }

  void clearSearch() {
    emit(state.copyWith(searchQuery: ''));
  }

  void updateSortOption(SortOption option) {
    if (state.sortOption == option) {
      emit(state.copyWith(isAscending: !state.isAscending));
    } else {
      emit(state.copyWith(sortOption: option, isAscending: false));
    }
  }

  void updateFilter(FilterOption filter) {
    emit(state.copyWith(selectedFilter: filter));
  }

  Future<void> fetchSurveys() async {
    emit(state.copyWith(status: Status.showLoading));
    try {
      final surveys = await repository.fetchMySurveys();
      emit(state.copyWith(status: Status.success, surveys: surveys));
    } catch (e) {
      emit(state.copyWith(
        status: Status.failure,
        msg: e.toString(),
      ));
    }
  }

  Future<void> refreshSurveys() async {
    try {
      final surveys = await repository.fetchMySurveys();
      emit(state.copyWith(surveys: surveys));
    } catch (e) {
      emit(state.copyWith(
        status: Status.failure,
        msg: e.toString(),
      ));
    }
  }

  void deleteSurvey(String surveyId) {
    repository.deleteSurvey(surveyId);
    fetchSurveys();
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
