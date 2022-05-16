import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_demo/blocs/signup/cubit.dart';

import 'bloc.dart';

class AppBloc {
  static final applicationCubit = ApplicationCubit();
  static final authenticateCubit = AuthenticationCubit();
  static final languageCubit = LanguageCubit();
  static final loginCubit = LoginCubit();
  static final signUpCubit = SignUpCubit();
  static final messageCubit = MessageCubit();
  static final searchCubit = SearchCubit();
  static final themeCubit = ThemeCubit();
  static final userCubit = UserCubit();
  static final categoryCubit = CategoryCubit();

  static final List<BlocProvider> providers = [
    BlocProvider<ApplicationCubit>(
      create: (context) => applicationCubit,
    ),
    BlocProvider<AuthenticationCubit>(
      create: (context) => authenticateCubit,
    ),
    BlocProvider<LanguageCubit>(
      create: (context) => languageCubit,
    ),
    BlocProvider<LoginCubit>(
      create: (context) => loginCubit,
    ),
    BlocProvider<SignUpCubit>(
      create: (context) => signUpCubit,
    ),
    BlocProvider<MessageCubit>(
      create: (context) => messageCubit,
    ),
    BlocProvider<SearchCubit>(
      create: (context) => searchCubit,
    ),
    BlocProvider<ThemeCubit>(
      create: (context) => themeCubit,
    ),
    BlocProvider<UserCubit>(
      create: (context) => userCubit,
    ),
    BlocProvider<CategoryCubit>(
      create: (context) => categoryCubit,
    ),
  ];

  static void dispose() {
    applicationCubit.close();
    authenticateCubit.close();
    languageCubit.close();
    loginCubit.close();
    signUpCubit.close();
    messageCubit.close();
    searchCubit.close();
    themeCubit.close();
    userCubit.close();
    categoryCubit.close();
  }

  ///Singleton factory
  static final AppBloc _instance = AppBloc._internal();

  factory AppBloc() {
    return _instance;
  }

  AppBloc._internal();
}
