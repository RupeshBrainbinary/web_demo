import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:web_demo/app_container.dart';
import 'package:web_demo/blocs/user/user_cubit.dart';
import 'package:web_demo/models/model_user.dart';
import 'package:web_demo/screens/home/home.dart';

class ReviewWebView extends StatefulWidget {
  final String? comment;
  final int? rate;

  ReviewWebView({this.comment, this.rate});

  @override
  State<ReviewWebView> createState() => _ReviewWebViewState();
}

class _ReviewWebViewState extends State<ReviewWebView> {
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() {}

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
              child: InAppWebView(
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
                    'https://www.thereviewclip.com/app/submitVideoReviewApp/${user.slug}?client_id=${user.id}&api=1&comment=${widget.comment}&rate=${widget.rate}',
                    //'https://www.thereviewclip.com/app/submitVideoReviewApp/test_73830?client_id=${user.id}&api=1&comment=${widget.comment}&rate=${widget.rate}',
                  ),
                ),
                onWebViewCreated: (controller) async {
                  Uri? uri = await controller.getUrl();
                  print("uri$uri");
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}
