
import 'package:flutter_bloc/flutter_bloc.dart';


part 'personal_info_state.dart';

class PersonalInfoCubit extends Cubit<PersonalInfoState> {
  PersonalInfoCubit() : super(PersonalInfoInitial());

  void onUsernameChanged(String value) {}

  void onFirstNameChanged(String value) {}

  void onLastNameChanged(String value) {}

  void onEmailChanged(String value) {}

  void onPhoneChanged(String value) {}
}
