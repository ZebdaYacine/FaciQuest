import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'manage_my_surveys_state.dart';

class ManageMySurveysCubit extends Cubit<ManageMySurveysState> {
  ManageMySurveysCubit(this.repository) : super(ManageMySurveysState());
  final SurveyRepository repository;

  void onSearchChanged(String value) {
    emit(state.copyWith(searchQuery: value));
  }

  fetchSurveys() {
    emit(state.copyWith(status: Status.showLoading));
    repository
        .fetchMySurveys()
        .then(
          (surveys) =>
              emit(state.copyWith(status: Status.success, surveys: surveys)),
        )
        .catchError(
          (error) => emit(
              state.copyWith(status: Status.failure, msg: error.toString())),
        );
  }
}
