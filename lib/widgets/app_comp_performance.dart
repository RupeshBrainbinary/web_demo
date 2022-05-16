import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web_demo/models/comapny_model.dart';
import 'package:web_demo/models/model.dart';
import 'package:web_demo/utils/utils.dart';
import 'package:web_demo/widgets/widget.dart';

class AppCompanyPerformance extends StatelessWidget {
  final CompanyModel? model;

  const AppCompanyPerformance({
    Key? key,
    this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (model == null) {
      return Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [1, 2].map((item) {
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
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: <Widget>[
            Text(
              model!.profileStats!.totalVideos.toString(),
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              Translate.of(context).translate('Review Clips'),
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
        const SizedBox(width: 10),
        Column(
          children: <Widget>[
            Text(
              model!.profileStats!.replays.toString(),
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 64),
            Text(
              Translate.of(context).translate('Replays'),
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ],
    );
  }
}
