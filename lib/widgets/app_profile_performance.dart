import 'package:flutter/material.dart';
import 'package:web_demo/models/model.dart';
import 'package:web_demo/models/reviewer_profile_model.dart';
import 'package:web_demo/utils/utils.dart';
import 'package:web_demo/widgets/widget.dart';

class AppProfilePerformance extends StatelessWidget {
  final UserModel? user;
  final String? subscribers;
  final String? totalvideos;
  final String? replys;


  const AppProfilePerformance(this.subscribers,this.replys,this.totalvideos ,{Key? key, this.user} )
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [1, 2, 3].map((item) {
          return AppPlaceholder(
            child: Column(
              children: <Widget>[
                Container(
                  width: 50,
                  height: 10,
                  color: Colors.white,
                ),
                const SizedBox(height: 4),
                Container(
                  width: 50,
                  height: 10,
                  color: Colors.white,
                ),
              ],
            ),
          );
        }).toList(),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: <Widget>[
            Text(
              subscribers.toString(),
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  fontWeight: FontWeight.bold, fontFamily: "ProximaNova"),
            ),
            Text(
              Translate.of(context).translate('Subscribers'),
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(fontFamily: "ProximaNova"),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            Text(
          totalvideos.toString(),
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  fontWeight: FontWeight.bold, fontFamily: "ProximaNova"),
            ),
            Text(
              Translate.of(context).translate('Review Clips'),
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(fontFamily: "ProximaNova"),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            Text(
              replys.toString(),
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  fontWeight: FontWeight.bold, fontFamily: "ProximaNova"),
            ),
            Text(
              Translate.of(context).translate('Replays'),
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(fontFamily: "ProximaNova"),
            ),
          ],
        ),
      ],
    );
  }
}
