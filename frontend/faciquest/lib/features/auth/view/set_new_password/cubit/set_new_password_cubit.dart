import 'package:equatable/equatable.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'set_new_password_state.dart';

class SetNewPasswordCubit extends Cubit<SetNewPasswordState> {
  SetNewPasswordCubit(this.authRepository) : super(SetNewPasswordState());
  final AuthRepository authRepository;

  void setPassword(String password) {
    emit(state.copyWith(password: password));
  }

  void setCPassword(String cPassword) {
    emit(state.copyWith(cPassword: cPassword));
  }

  Future<void> submit() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: Status.showLoading));
    try {
      getIt<AuthBloc>().add(RefreshRoute(true));
      await authRepository.setNewPassword(state.password!);
      emit(state.copyWith(status: Status.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: Status.failure,
          msg: e.toString(),
        ),
      );
    }
  }
}
