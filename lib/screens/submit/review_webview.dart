import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_demo/app_container.dart';
import 'package:web_demo/blocs/user/user_cubit.dart';
import 'package:web_demo/configs/config.dart';
import 'package:web_demo/models/model_user.dart';
import 'package:web_demo/screens/home/home.dart';
import 'package:web_demo/utils/preferences.dart';

class ReviewWebView extends StatefulWidget {
  final String? comment;
  final String? slug;
  final int? rate;

  ReviewWebView({this.comment, this.rate, this.slug});

  @override
  State<ReviewWebView> createState() => _ReviewWebViewState();
}

class _ReviewWebViewState extends State<ReviewWebView> {

  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {

    _loadData();
    super.initState();
  }

  Future<void> _loadData() async {
    await Permission.camera.request();
    flutterWebViewPlugin.launch(
      'https://www.thereviewclip.com/app/submitVideoReviewApp/${widget.slug}?client_id=${UtilPreferences.getString(Preferences.clientId)}&api=1&comment=${widget.comment}&rate=${widget.rate}',
      rect: Rect.fromLTWH(
          0.0, 0.0, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
      userAgent: 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36',
      invalidUrlRegex:
      r'^(https).+(twitter)',
    );
    flutterWebViewPlugin.onUrlChanged.listen((String uri) {
      print("===> $uri");
      if (uri.toString().contains("success=1")) {
        final snackBar = SnackBar(
          content: Center(
            child: Text(
              "Thanks for submitting your Video Review. We are processing your video. It will get published in few minutes.",
            ),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        flutterWebViewPlugin.close();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AppContainer()), (route) => false);
      } else {
        if (uri.toString().contains("success=0")) {
          final snackBar = SnackBar(
            content: Center(
              child: Text(
                "Review not Recorded Successfully please try again later",
              ),
            ),
          );
          flutterWebViewPlugin.close();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pop(context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<UserCubit, UserModel?>(builder: (context, user) {
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: CircularProgressIndicator(),
              /*child: InAppWebView(
                onLoadStop: (controller, uri) async {
                  Uri? uri = await controller.getUrl();
                  print("url2 $uri");
                  if (uri.toString().contains("success=1")) {
                    final snackBar = SnackBar(
                      content: Text(
                        "Review Recorded Successfully",
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AppContainer()), (route) => false);
                  } else {
                    if (uri.toString().contains("success=0")) {
                      final snackBar = SnackBar(
                        content: Text(
                          "Review not Recorded Successfully please try again later",
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.pop(context);
                    }
                  }
                },
                initialUrlRequest: URLRequest(
                  url: Uri.parse(
                    'https://www.thereviewclip.com/app/submitVideoReviewApp/${widget.slug}?client_id=${user.id}&api=1&comment=${widget.comment}&rate=${widget.rate}',
                    //'https://www.thereviewclip.com/app/submitVideoReviewApp/test_73830?client_id=${user.id}&api=1&comment=${widget.comment}&rate=${widget.rate}',
                  ),
                ),
                onWebViewCreated: (controller) async {
                  Uri? uri = await controller.getUrl();
                  print("uri$uri");
                },
              ),*/
            ),
          );
        }),
      ),
    );
  }
}
