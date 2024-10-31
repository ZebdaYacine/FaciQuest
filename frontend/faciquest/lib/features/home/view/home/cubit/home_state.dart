part of 'home_cubit.dart';

class HomeState {
  const HomeState({
    this.status = Status.initial,
    this.surveys = const [],
  });
  final Status status;
  final List<SurveyEntity> surveys;

  HomeState copyWith({
    Status? status,
    List<SurveyEntity>? surveys,
  }) {
    return HomeState(
      status: status ?? this.status,
      surveys: surveys ?? this.surveys,
    );
  }
}
