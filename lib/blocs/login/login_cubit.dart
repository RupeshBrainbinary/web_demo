import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:web_demo/blocs/app_bloc.dart';
import 'package:web_demo/blocs/bloc.dart';
import 'package:web_demo/configs/preferences.dart';
import 'package:web_demo/models/model_user.dart';
import 'package:web_demo/repository/repository.dart';
import 'package:web_demo/utils/preferences.dart';
import 'package:web_demo/widgets/common_toast.dart';

enum LoginState {
  init,
  loading,
  success,
  fail,
}

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState.init);

  Future<UserModel?> onLogin({
    required String username,
    required String password,
    required BuildContext context,
  }) async {
    ///Notify
    emit(LoginState.loading);

    ///login via repository
    final result = await UserRepository.login(
      username: username,
      password: password,
    );

    if (result != null) {
      ///Begin start Auth flow
      await UtilPreferences.setString(
        Preferences.clientId,
        result.id.toString(),
      );
      await AppBloc.authenticateCubit.onSave(result);

      ///Notify

      emit(LoginState.success);

      return result;
    } else {
      ///Notify
      emit(LoginState.fail);
      CommonToast().toats(context, "signInError");
      //return result;
    }
  }

  void onLogout() async {
    ///Begin start auth flow
    emit(LoginState.init);
    UtilPreferences.setString(Preferences.clientId, '');
    AppBloc.authenticateCubit.onClear();
  }
}
