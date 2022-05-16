import 'package:bloc/bloc.dart';
import 'package:web_demo/blocs/app_bloc.dart';
import 'package:web_demo/blocs/bloc.dart';
import 'package:web_demo/configs/preferences.dart';
import 'package:web_demo/repository/repository.dart';
import 'package:web_demo/utils/preferences.dart';

enum LoginState {
  init,
  loading,
  success,
  fail,
}

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState.init);

  void onLogin({
    required String username,
    required String password,
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
      await AppBloc.authenticateCubit.onSave(result);
      await UtilPreferences.setString(
        Preferences.clientId,
        result.id.toString(),
      );
      ///Notify
      emit(LoginState.success);
    } else {
      ///Notify
      emit(LoginState.fail);
    }
  }

  void onLogout() async {
    ///Begin start auth flow
    emit(LoginState.init);
    AppBloc.authenticateCubit.onClear();
  }
}
