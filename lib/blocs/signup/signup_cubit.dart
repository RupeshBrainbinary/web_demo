import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:web_demo/blocs/app_bloc.dart';
import 'package:web_demo/blocs/bloc.dart';
import 'package:web_demo/configs/preferences.dart';
import 'package:web_demo/repository/repository.dart';
import 'package:web_demo/utils/preferences.dart';

enum SignUpState {
  init,
  loading,
  success,
  fail,
}

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpState.init);

  Future<bool> onSignup({
    required String username,
    required String countryName,
    required String mobileNo,
    required String email,
    required String password,
    required String conPassword,
  }) async {
    ///Notify
    emit(SignUpState.loading);

    ///login via repository
    final result = await UserRepository.signUp(
      username: username,
      password: password,
      email: email,
      conPassword: conPassword,
      countryName: countryName,
      mobileNo: mobileNo
    );

    if (result != null) {
      ///Begin start Auth flow
      await UtilPreferences.setString(
        Preferences.clientId,
        result.id.toString(),
      );
      await AppBloc.authenticateCubit.onSave(result);

      ///Notify
      emit(SignUpState.success);
      return true;
    } else {
      ///Notify
      emit(SignUpState.fail);
      return false;
    }
  }
}
