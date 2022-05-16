import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web_demo/app.dart';
import 'package:web_demo/utils/utils.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    UtilLogger.log('BLOC ONCHANGE', change);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    UtilLogger.log('BLOC EVENT', event);
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    UtilLogger.log('BLOC ERROR', error);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    UtilLogger.log('BLOC TRANSITION', transition);
    super.onTransition(bloc, transition);
  }
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyC3JpJBWIo4VrlOzNnGyag_RrI3IIwixnI",
          authDomain: "listar-flux-ui-kit.firebaseapp.com",
          databaseURL: "https://listar-flux-ui-kit.firebaseio.com",
          projectId: "listar-flux-ui-kit",
          storageBucket: "listar-flux-ui-kit.appspot.com",
          messagingSenderId: "362839000336",
          appId: "1:362839000336:web:7bff8da8f238df56880cbb",
          //measurementId: "G-YGS7ZW7NVH",
      ));

  BlocOverrides.runZoned(
    () => runApp(const App()),
    blocObserver: AppBlocObserver(),
  );
}
