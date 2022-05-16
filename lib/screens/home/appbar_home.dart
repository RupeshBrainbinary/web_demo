import 'package:flutter/material.dart';
import 'package:web_demo/models/model.dart';
import 'package:web_demo/utils/utils.dart';
import 'package:web_demo/widgets/widget.dart';
import 'package:web_demo/widgets/app_placeholder.dart';

class AppBarHome extends SliverPersistentHeaderDelegate {
  final double maxHeight;
  final double minHeight;
  final List<CountryModel>? country;
  final CountryModel? countrySelected;
  final VoidCallback onLocation;
  final VoidCallback onSearch;

  AppBarHome({
    required this.maxHeight,
    required this.minHeight,
    this.country,
    this.countrySelected,
    required this.onLocation,
    required this.onSearch,
  });

  ///Build action show modal
  Widget _buildAction(BuildContext context) {
    if (country == null) {
      return AppPlaceholder(
        child: Column(
          children: [
            Text(
              Translate.of(context).translate('loading'),
              style: Theme.of(context).textTheme.subtitle1!.copyWith(fontFamily: "ProximaNova"),
            ),
            Row(
              children: [
                Text(
                  Translate.of(context).translate('loading'),
                  style: Theme.of(context).textTheme.caption!.copyWith(fontFamily: "ProximaNova"),
                ),
                 Icon(
                  Icons.arrow_drop_down,
                  size: 14,
                  color: Theme.of(context).iconTheme.color,
                )
              ],
            )
          ],
        ),
      );
    }

    return InkWell(
      onTap: onLocation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            countrySelected!.title,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(fontFamily: "ProximaNova"),
          ),
          Row(
            children: [
              Text(
                Translate.of(context).translate('select_country'),
                style: Theme.of(context).textTheme.caption!.copyWith(fontFamily: "ProximaNova"),
              ),
              Icon(
                Icons.arrow_drop_down,
                size: 16,
                color:Theme.of(context).iconTheme.color,
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    double marginSearch = 16 + shrinkOffset;
    if (marginSearch >= 135) {
      marginSearch = 135;
    }
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          color: Theme.of(context).backgroundColor,
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Image.asset(
                      //   'assets/images/topbar_logo.png',
                      //   // 'assets/images/intro.png',
                      //   fit: BoxFit.cover,
                      //   // height: 35.0,
                      //   // width: 155.0,
                      // ),
                      Text(
                        "ReviewClip",
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(fontWeight: FontWeight.bold,fontFamily: "ProximaNova"),
                      ),
                      _buildAction(context),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        SafeArea(
          top: false,
          bottom: false,
          child: Container(
            margin: EdgeInsets.only(
              bottom: 8,
              top: 8,
              left: 16,
              right: marginSearch,
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).cardColor,
              ),
              child: IntrinsicHeight(
                child: InkWell(
                  onTap: onSearch,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          Translate.of(context).translate(
                            'Search Business Reviews, Reviewers & more',
                          ),
                          style: Theme.of(context).textTheme.caption!.copyWith(fontFamily: "ProximaNova"),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: VerticalDivider(),
                      ),
                      Icon(
                        Icons.search,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
