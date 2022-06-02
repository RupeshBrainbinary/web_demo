import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_demo/api/api.dart';
import 'package:web_demo/app_container.dart';
import 'package:web_demo/blocs/bloc.dart';
import 'package:web_demo/blocs/deeplink_bloc.dart';
import 'package:web_demo/configs/config.dart';
import 'package:web_demo/models/model_review.dart';
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
  String? deepLinkUrl;

  @override
  void initState() {
    super.initState();
    deepLinkInt();
    AppBloc.applicationCubit.onSetup();
  }

  Future<void> deepLinkInt() async {
    Uri? uri = await getInitialUri();
    if (uri != null) {
      deepLinkUrl = uri.path;
    }
    DeepLinkBloc _bloc = DeepLinkBloc();
    _bloc.state.listen((event) {
      changePage(event);
    });
  }

  void changePage(String url) {
    try {
      /*String linkPid = url.split("app.reviewclip.com/").last;
      String page = linkPid.split('/').first;
      if (page == 'review') {*/
      if (true) {
        ReviewModel model = ReviewModel.fromJson({
          "me": "",
          "id": 16694,
          "v": 31,
          "l": 0,
          "un": "Searching Samayal",
          "loc": "India",
          "cn": "Hotel Kannappa",
          "climg": "https://www.thereviewclip.com/images/logo-ph.jpg",
          "cl": "Coimbatore",
          "st": 1,
          "cd": "22nd April - 2022",
          "img":
              "https://reviewclip-test.s3.ap-south-1.amazonaws.com/e1d8ecb33a738216aca3952dff7d4f58.jpg",
          "video":
              "https://reviewclip-test.s3.amazonaws.com/e1d8ecb33a738216aca3952dff7d4f58.mp4",
          "rt": 4,
          "vsl": "brTDGSB8",
          "cmt": "Authentic Dishes I Fish Fingers Must Try",
          "psl": "hotel_kannappa",
          "em": 1
        });
        navigatorKey.currentState!.push(MaterialPageRoute(
            builder: (context) => ProductDetailRealEstate(review: model)));
      }
    } on PlatformException {}
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
                              if (deepLinkUrl != null) {
                                Future.delayed(Duration(milliseconds: 50), () {
                                  changePage(deepLinkUrl!);
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
