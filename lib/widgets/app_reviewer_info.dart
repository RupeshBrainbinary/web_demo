import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web_demo/api/api.dart';
import 'package:web_demo/configs/preferences.dart';
import 'package:web_demo/models/model.dart';
import 'package:web_demo/utils/utils.dart';
import 'package:web_demo/widgets/widget.dart';

enum AppReviewerType { basic, information }

class AppReviewerInfo extends StatefulWidget {
  final UserModel? user;
  final VoidCallback? onPressed;
  final AppReviewerType type;
  final String image;
  final String name;
  final String ch;
  final String slug;

  const AppReviewerInfo({
    Key? key,
    this.user,
    this.onPressed,
    this.type = AppReviewerType.basic,
    required this.image,
    required this.name,
    required this.ch,
    required this.slug,
  }) : super(key: key);

  @override
  State<AppReviewerInfo> createState() => _AppReviewerInfoState();
}

class _AppReviewerInfoState extends State<AppReviewerInfo> {
  bool isShow = false;

  @override
  Widget build(BuildContext context) {
    if (widget.user == null) {
      switch (widget.type) {
        case AppReviewerType.information:
          return AppPlaceholder(
            child: Row(
              children: <Widget>[
                Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 10,
                        width: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 10,
                        width: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 10,
                        width: 150,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        default:
          return AppPlaceholder(
            child: Row(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 10,
                      width: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 10,
                      width: 150,
                      color: Colors.white,
                    ),
                  ],
                )
              ],
            ),
          );
      }
    }

    switch (widget.type) {
      case AppReviewerType.information:
        return InkWell(
          onTap: widget.onPressed,
          child: Row(
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(widget.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                    ),
                    // child: Text(
                    //   "${user!.rate}",
                    //   style: const TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 8,
                    //   ),
                    // ),
                  )
                ],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.name,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(fontFamily: "ProximaNova"),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.ch,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(fontFamily: "ProximaNova"),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.slug,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(fontFamily: "ProximaNova"),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const SizedBox(
                    height: 4,
                    width: 12,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final result = await Api.subscribe({
                          "id": UtilPreferences.getString(Preferences.clientId),
                          "reviewer": widget.user!.id,
                          "xhr": "1"
                        });
                        print(result);
                        print(jsonDecode(result));
                        var jsonResp = jsonDecode(result);
                        if (jsonResp['status'] == 1) {
                          isShow = true;
                          await Api.getSubscribedList();
                        } else {
                          isShow = false;
                        }
                        setState(() {});
                        Fluttertoast.showToast(
                            msg: "Subscribed successfully", // message
                            toastLength: Toast.LENGTH_SHORT, // length
                            gravity: ToastGravity.BOTTOM_LEFT, // location
                            timeInSecForIosWeb: 1 // duration
                            );
                      },
                      child: Text( subscribedList
                          .where((element) =>
                      element.slug == widget.user!.slug)
                          .isNotEmpty ? 'Subscribed' : 'Subscribe',
                          style: Theme.of(context)
                              .textTheme
                              .button!
                              .copyWith(fontFamily: "ProximaNova"))),
                ],
              ),
              // RotatedBox(
              //   quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
              //   child: const Icon(
              //     Icons.keyboard_arrow_right,
              //   ),
              // ),
            ],
          ),
        );
      default:
        return Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                    widget.user!.avatar,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.user!.name,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      fontWeight: FontWeight.bold, fontFamily: "ProximaNova"),
                ),
                Text(
                  widget.user!.chanel,
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontFamily: "ProximaNova"),
                )
              ],
            )
          ],
        );
    }
  }
}
