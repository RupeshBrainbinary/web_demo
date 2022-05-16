import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:web_demo/models/model.dart';
import 'package:web_demo/models/model_channel.dart';

class AppChannelItem extends StatelessWidget {
  AppChannelItem({
    Key? key,
    this.item,
    this.onPressed,
    this.onSubscribe,
    this.subTitleIn2Line,
    required this.type,
  }) : super(key: key);

  final ChannelModel? item;
  final ProductViewType type;
  final VoidCallback? onPressed;
  final VoidCallback? onSubscribe;
  final bool? subTitleIn2Line;
  final currency = String.fromCharCode(0x24);

  @override
  Widget build(BuildContext context) {
    Widget dummyContainer = Container(width: 160.0);
    if (null != item) {
      switch (type) {

        ///Mode View Small
        case ProductViewType.gird:
          return Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: InkWell(
              onTap: onPressed,
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(item!.avatar),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item!.channelName,
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        fontWeight: FontWeight.bold, fontFamily: "ProximaNova"),
                  ),
                  const SizedBox(
                    height: 4,
                    width: 12,
                  ),
                  Text(
                    '${item!.subscribers} Subscribers',
                    style: Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(fontFamily: "ProximaNova"),
                  ),
                  const SizedBox(
                    height: 4,
                    width: 12,
                  ),
                  Text(
                    '${item!.videoCount} Videos',
                    style: Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(fontFamily: "ProximaNova"),
                  ),
                  const SizedBox(
                    height: 4,
                    width: 12,
                  ),
                  ElevatedButton(

                      onPressed: onSubscribe,
                      child: Text(
                        'Subscribe',
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(fontFamily: "ProximaNova",color:Colors.white),
                      )),
                ],
              ),
            ),
          );
        case ProductViewType.small:
          return ListTile(
            onTap: onPressed,
            leading: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: CachedNetworkImageProvider(item!.avatar),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(
              item!.channelName,
              style: Theme.of(context)
                  .textTheme
                  .button!
                  .copyWith(fontFamily: "ProximaNova",fontWeight: FontWeight.w900),
            ),
            subtitle: subTitleIn2Line == true
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${item!.videoCount} Videos",
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(fontFamily: "ProximaNova"),
                      ),
                      Text(
                        "${item!.subscribers} Subscribers",
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(fontFamily: "ProximaNova"),
                      ),
                    ],
                  )
                : Text(
                    "${item!.videoCount} Videos   |   ${item!.subscribers} Subscribers",
                    style: Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(fontFamily: "ProximaNova"),
                  ),
            trailing: ElevatedButton(
                onPressed: onSubscribe,
                child: Text(
                  'Subscribe',
                  style: Theme.of(context)
                      .textTheme
                      .button!
                      .copyWith(fontFamily: "ProximaNova"),
                )),
          );

        default:
          return dummyContainer;
      }
    }
    return dummyContainer;
  }
}
