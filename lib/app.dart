import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:web_demo/app_container.dart';
import 'package:web_demo/blocs/bloc.dart';
import 'package:web_demo/configs/config.dart';
import 'package:web_demo/screens/screen.dart';
import 'package:web_demo/screens/submit/review_webview.dart';
import 'package:web_demo/utils/utils.dart';
import 'package:showcaseview/showcaseview.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    AppBloc.applicationCubit.onSetup();
  }

  @override
  void dispose() {
    AppBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBloc.providers,
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (context, lang) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, theme) {
              return MaterialApp(
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                // theme: ThemeData(
                //   colorScheme: ColorScheme.light(
                //     primary: Color(0xFFffe5634d),
                //     secondary:  Color(0xFFff4a91a4),
                //
                //
                //     background: const Color.fromRGBO(249, 249, 249, 1),
                //   ),
                //     fontFamily: "ProximaNova",
                //   hoverColor: Colors.white,
                //   highlightColor: Colors.white,
                //   backgroundColor: Color.fromRGBO(249, 249, 249, 1),
                //   primaryColor: Color(0xFFffe5634d)
                //     ),
                theme: theme.lightTheme,
                darkTheme: theme.darkTheme,
                onGenerateRoute: Routes.generateRoute,
                locale: lang,
                localizationsDelegates: const [
                  Translate.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: AppLanguage.supportLanguage,
                home: ShowCaseWidget(
                  blurValue: 1,
                  builder: Builder(builder: (context) {
                    return Scaffold(
                      body: BlocListener<MessageCubit, String?>(
                        listener: (context, message) {
                          if (message != null) {
                            final snackBar = SnackBar(
                              content: Text(
                                Translate.of(context).translate(message),
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        child: BlocBuilder<ApplicationCubit, ApplicationState>(
                          builder: (context, application) {
                            //return ReviewWebView();

                            if (application == ApplicationState.completed) {
                              if (UtilPreferences.getString(
                                      Preferences.clientId) ==
                                  null) {
                                return const SignIn(from: '');
                              }
                              return const AppContainer();
                            }
                            if (application == ApplicationState.intro) {
                              return const Intro();
                            }
                            return const SplashScreen();
                          },
                        ),
                      ),
                    );
                  }),
                  autoPlayDelay: const Duration(seconds: 3),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
