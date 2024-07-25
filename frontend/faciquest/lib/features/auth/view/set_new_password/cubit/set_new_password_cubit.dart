import 'package:equatable/equatable.dart';
import 'package:faciquest/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'set_new_password_state.dart';

class SetNewPasswordCubit extends Cubit<SetNewPasswordState> {
  SetNewPasswordCubit() : super(SetNewPasswordState());

  void setPassword(String password) {
    emit(state.copyWith(password: password));
  }

  void setCPassword(String cPassword) {
    emit(state.copyWith(cPassword: cPassword));
  }

  void submit() {}
}
