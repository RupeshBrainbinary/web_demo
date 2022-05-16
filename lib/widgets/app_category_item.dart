import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:web_demo/models/model.dart';
import 'package:web_demo/widgets/widget.dart';

enum CategoryType { full, icon }

class AppCategory extends StatelessWidget {
  const AppCategory({
    Key? key,
    this.type = CategoryType.full,
    this.item,
    this.onPressed,
  }) : super(key: key);

  final CategoryType type;
  final CategoryModel? item;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case CategoryType.full:
        if (item == null) {
          return AppPlaceholder(
            child: Container(
              height: 120,
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
          );
        }

        return GestureDetector(
          onTap: onPressed,
          child: Container(
            height: 120,
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(item!.image),
                fit: BoxFit.cover,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: item!.color,
                      ),
                      child: SizedBox(
                        height: 18,
                        width: 18,
                        child: SvgPicture.network(
                          item!.icon,
                          color: Colors.white,
                          placeholderBuilder: (BuildContext context) =>
                              const CircularProgressIndicator(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item!.title,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  fontWeight: FontWeight.bold,fontFamily: "ProximaNova"
                          ),
                        ),
                        Text(
                          '${item!.count} videos',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontFamily: "ProximaNova"),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        );

      case CategoryType.icon:
        if (item == null) {
          return AppPlaceholder(
            child: Container(
              height: 120,
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
          );
        }

        return InkWell(
          onTap: onPressed,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  color: item!.color,
                ),
                child: SizedBox(
                  height: 32,
                  width: 32,
                  child: SvgPicture.network(
                    item!.icon,
                    color: Colors.white,
                    placeholderBuilder: (BuildContext context) =>
                        const CircularProgressIndicator(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item!.title,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontWeight: FontWeight.bold,fontFamily: "ProximaNova"),
                  ),
                  Text(
                    '${item!.count} videos',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontFamily: "ProximaNova"),
                  ),
                ],
              )
            ],
          ),
        );

      default:
        return Container();
    }
  }
}
