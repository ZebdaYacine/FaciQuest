// ignore_for_file: strict_raw_type

import 'package:faciquest/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// bloc observer for the hole app any bloc event or error or change
/// will be cached here
class MyBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    logInfo(
      'BlocObserver:onEvent(bloc:${bloc.runtimeType}'
      ',event:${event.runtimeType})',
    );
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    logInfo(
      'BlocObserver:onError(bloc:${bloc.runtimeType},error:$error,'
      ' stackTrace:$stackTrace)',
    );

    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    //logInfo('BlocObserver:onChange(bloc:${bloc.runtimeType},change:$change)');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    // logInfo('BlocObserver:onTransition(bloc:${bloc.runtimeType}'
    //     ',transition:$transition)');
  }
}
