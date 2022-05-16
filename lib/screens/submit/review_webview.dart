import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:web_demo/blocs/user/user_cubit.dart';
import 'package:web_demo/models/model_user.dart';

class ReviewWebView extends StatefulWidget {
  const ReviewWebView({Key? key}) : super(key: key);

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
          return Center(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: Uri.parse(
                 'www.thereviewclip.com/app/submitVideoReviewApp/test_73830?client_id=${user.id}',
                ),
              ),
              onWebViewCreated: (controller) async {
                Uri? uri = await controller.getUrl();
                print(uri);
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
          );
        }),
      ),
    );
  }
}
