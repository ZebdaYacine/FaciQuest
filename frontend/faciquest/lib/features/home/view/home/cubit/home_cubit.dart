import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.repository) : super(const HomeState());
  final SurveyRepository repository;

  void fetchSurveys() async {
    emit(state.copyWith(status: Status.showLoading));
    await Future.delayed(
      const Duration(seconds: 1),
    );
    repository.getSurveys().then(
          (surveys) => emit(
            state.copyWith(
              surveys: surveys,
              status: Status.success,
            ),
          ),
          onError: (error) => emit(
            state.copyWith(
              status: Status.failure,
            ),
          ),
        );
  }
}
