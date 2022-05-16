import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:web_demo/blocs/user/user_cubit.dart';
import 'package:web_demo/models/model_user.dart';
import 'package:web_demo/screens/home/home.dart';
import 'package:web_demo/utils/translate.dart';

class ReviewWebView extends StatefulWidget {
  final String? comment;
  ReviewWebView({this.comment});

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
                onLoadStop: (controller,uri)async{

                  Uri? uri = await controller.getUrl();
                  print("url2 $uri");
                  if(uri.toString().contains("success=1")){

                    final snackBar = SnackBar(
                      content: Text(
                        "Review Recorded Successfully",

                      ),
                    );
                    ScaffoldMessenger.of(context)
                        .showSnackBar(snackBar);

                    Navigator.push(context, MaterialPageRoute(builder: (_)=>Home()));
                  }else{
                    if(uri.toString().contains("success=0")) {
                      final snackBar = SnackBar(
                        content: Text(
                          "Review not Recorded Successfully please try again later",

                        ),

                      );
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBar);
                      Navigator.pop(context);
                    }
                  }
                },

                initialUrlRequest: URLRequest(
                  url: Uri.parse(
                   'https://www.thereviewclip.com/app/submitVideoReviewApp/test_73830?client_id=${user.id}&api=1&comment=${widget.comment}&rate=4',
                  ),
                ),
                onWebViewCreated: (controller) async {
                  Uri? uri = await controller.getUrl();
                  print("uri$uri");
                },

              ),
              /*child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: Uri.parse(
                    'https://www.thereviewclip.com/app/submitVideoReviewApp/test_73830?client_id=96&success=1',
                    //'https://www.thereviewclip.com/app/submitVideoReviewApp/test_73830?client_id=${user.id}&success=1',
                  ),
                ),
                onWebViewCreated: (controller) async {
                  Uri? uri = await controller.getUrl();
                  print(uri?.data);
                },
              ),*/
            ),
          );
        }),
      ),
    );
  }
}
