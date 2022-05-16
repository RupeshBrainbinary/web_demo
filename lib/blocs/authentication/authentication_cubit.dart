import 'package:bloc/bloc.dart';
import 'package:web_demo/blocs/bloc.dart';
import 'package:web_demo/models/model.dart';
import 'package:web_demo/repository/repository.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationState.loading);

  Future<void> onCheck() async {
    ///Notify
    emit(AuthenticationState.loading);

    ///Event load user
    UserModel? user = await AppBloc.userCubit.onLoadUser();

    if (user != null) {
      ///Save user
      await AppBloc.userCubit.onSaveUser(user);

      ///Valid token server
      final result = await UserRepository.validateToken();

      if (result) {
        ///Fetch user
        await AppBloc.userCubit.onFetchUser();

        ///Notify
        emit(AuthenticationState.success);
      } else {
        ///Logout
        onClear();
      }
    } else {
      ///Notify
      emit(AuthenticationState.fail);
    }
  }

  Future<void> onSave(UserModel user) async {
    ///Notify
    emit(AuthenticationState.loading);

    ///Event Save user
    await AppBloc.userCubit.onSaveUser(user);

    /// Notify
    emit(AuthenticationState.success);
  }

  void onClear() {
    /// Notify
    emit(AuthenticationState.fail);

    ///Delete user
    AppBloc.userCubit.onDeleteUser();
  }
}
