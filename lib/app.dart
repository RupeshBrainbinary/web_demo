import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_demo/api/api.dart';
import 'package:web_demo/app_container.dart';
import 'package:web_demo/blocs/bloc.dart';
import 'package:web_demo/configs/config.dart';
import 'package:web_demo/screens/product_detail_real_estate/product_detail_real_estate.dart';
import 'package:web_demo/screens/screen.dart';
import 'package:web_demo/utils/utils.dart';
import 'package:web_demo/widgets/app_button.dart';

double height = 0;
double width = 0;

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class _AppState extends State<App> {
  String? deepLinkPath;

  @override
  void initState() {
    super.initState();
    deepLinkInt();
    AppBloc.applicationCubit.onSetup();
  }

  Future<void> deepLinkInt() async {
    Uri? uri = await getInitialUri();
    if (uri != null) {
      deepLinkPath = uri.path;
    }
    /*DeepLinkBloc _bloc = DeepLinkBloc();
    _bloc.state.listen((event) {
      changePage(event);
    });*/
    uriLinkStream.listen((event) {
      if (event != null) {
        changePage(event.path);
      }
    });
  }

  void changePage(String path) {
    List<String> pathList = path.split('/');
    String page = pathList[1];
    if (page == 'review') {
      String videoSlug = pathList.last;
      if (videoSlug.isNotEmpty) {
        navigatorKey.currentState!.push(MaterialPageRoute(
            builder: (context) => ProductDetailRealEstate(slug: videoSlug)));
      }
    } else if (page == 'reviewer_profile') {
      String profileSlug = pathList.last;
      if (profileSlug.isNotEmpty) {
        navigatorKey.currentState!.push(MaterialPageRoute(
            builder: (context) => ProfileReviewer(slug: profileSlug)));
      }
    } else if (page == 'profile') {
      String profileSlug = pathList.last;
      if (profileSlug.isNotEmpty) {
        navigatorKey.currentState!.push(MaterialPageRoute(
            builder: (context) => ProfileCompany(slug: profileSlug)));
      }
    }
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
                theme: theme.darkTheme,
                darkTheme: theme.darkTheme,
                onGenerateRoute: Routes.generateRoute,
                locale: lang,
                initialRoute: Routes.appContainer,
                // initialRoute: '/',
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
                            height = MediaQuery.of(context).size.height;
                            width = MediaQuery.of(context).size.width;
                            /*return ReviewWebView(
                             rate: 3,
                             comment: 'test',
                             slug: 'test_73830',
                            );*/

                            if (application == ApplicationState.completed) {
                              if (UtilPreferences.getString(
                                          Preferences.clientId) ==
                                      null ||
                                  UtilPreferences.getString(
                                          Preferences.clientId) ==
                                      '') {
                                return SignIn(from: 'intro');
                              }
                              if (deepLinkPath != null) {
                                Future.delayed(Duration(milliseconds: 50), () {
                                  changePage(deepLinkPath!);
                                  deepLinkPath = null;
                                });
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

bool updateLoaded = false;

Future<void> checkForUpdate(BuildContext context) async {
  updateLoaded = true;
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  String appName = packageInfo.buildNumber;
  Map<String, dynamic> res = await Api.getCommonData();
  if (res['status'] == 200) {
    if (res['data']['version'] == packageInfo.version) {
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(res['data']['Title'].toString()),
        content: Text(
            // "${res['data']['content']} from ${packageInfo.version} to ${res['data']['version']}"),
            "${res['data']['content']}"),
        actions: [
          res['data']['force_update'] == 0
              ? AppButton(
                  "Maybe Later",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  type: ButtonType.text,
                )
              : SizedBox(),
          AppButton(
            "Update",
            onPressed: () async {
              await launchUrl(
                  Uri.parse(res['data']['playstore_link'].toString()));
            },
            type: ButtonType.text,
          ),
        ],
      ),
    );
  }
}
