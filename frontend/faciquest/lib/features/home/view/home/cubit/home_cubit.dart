import 'dart:async';

import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.repository)
      : super(const HomeState(
          status: Status.showLoading,
        )) {
    subscription = Stream.periodic(const Duration(seconds: 30)).listen((event) {
      fetchSurveys();
    });
  }

  StreamSubscription? subscription;

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }

  final SurveyRepository repository;

  void fetchSurveys() async {
    repository.getSurveys().listen(
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
