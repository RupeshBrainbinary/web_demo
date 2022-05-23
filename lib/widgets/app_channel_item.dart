import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web_demo/api/api.dart';
import 'package:web_demo/configs/preferences.dart';
import 'package:web_demo/models/model.dart';
import 'package:web_demo/models/model_channel.dart';
import 'package:web_demo/utils/preferences.dart';

class AppChannelItem extends StatefulWidget {
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

  //final bool? subscribe;

  @override
  State<AppChannelItem> createState() => _AppChannelItemState();
}

class _AppChannelItemState extends State<AppChannelItem> {
  final currency = String.fromCharCode(0x24);

  bool isShow = false;

  @override
  Widget build(BuildContext context) {
    Widget dummyContainer = Container(width: 160.0);
    if (null != widget.item) {
      switch (widget.type) {

        ///Mode View Small
        case ProductViewType.gird:
          return Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: InkWell(
              onTap: widget.onPressed,
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(widget.item!.avatar),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.item!.channelName,
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        fontWeight: FontWeight.bold, fontFamily: "ProximaNova"),
                  ),
                  const SizedBox(
                    height: 4,
                    width: 12,
                  ),
                  Text(
                    '${widget.item!.subscribers} Subscribers',
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
                    '${widget.item!.videoCount} Videos',
                    style: Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(fontFamily: "ProximaNova"),
                  ),
                  const SizedBox(
                    height: 4,
                    width: 12,
                  ),
                  ElevatedButton(style: ElevatedButton.styleFrom(
                    primary:  subscribedList
                        .where((element) =>
                    element.slug == widget.item!.slug)
                        .isNotEmpty? Colors.grey:Colors.blue, // Background color
                  ),
                      onPressed: widget.onSubscribe != null
                          ? widget.onSubscribe
                          : () async {
                              final result = await Api.subscribe({
                                "id": UtilPreferences.getString(
                                    Preferences.clientId),
                                "reviewer": widget.item!.id.toString(),
                                "xhr": "1"
                              });
                              print(result);
                              print(jsonDecode(result));
                              var jsonResp = jsonDecode(result);
                              if (jsonResp['status'] == 1) {
                                await Api.getSubscribedList();
                                isShow = true;
                              } else {
                                isShow = false;
                              }
                              setState(() {});
                          /*    Fluttertoast.showToast(
                                  msg: "Subscribed successfully", // message
                                  toastLength: Toast.LENGTH_SHORT, // length
                                  gravity: ToastGravity.BOTTOM_LEFT, // location
                                  timeInSecForIosWeb: 1 // duration
                                  );*/
                            },
                      child: Text(
                        subscribedList
                                .where((element) =>
                                    element.slug == widget.item!.slug)
                                .isNotEmpty
                            ? 'Subscribed'
                            : 'Subscribe',
                        style: Theme.of(context).textTheme.button!.copyWith(
                            fontFamily: "ProximaNova", color: Colors.white),
                      )),
                ],
              ),
            ),
          );
        case ProductViewType.small:
          return ListTile(
            onTap: widget.onPressed,
            leading: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: CachedNetworkImageProvider(widget.item!.avatar),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(
              widget.item!.channelName,
              style: Theme.of(context).textTheme.button!.copyWith(
                  fontFamily: "ProximaNova", fontWeight: FontWeight.w900),
            ),
            subtitle: widget.subTitleIn2Line == true
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.item!.videoCount} Videos",
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(fontFamily: "ProximaNova"),
                      ),
                      Text(
                        "${widget.item!.subscribers} Subscribers",
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(fontFamily: "ProximaNova"),
                      ),
                    ],
                  )
                : Text(
                    "${widget.item!.videoCount} Videos   |   ${widget.item!.subscribers} Subscribers",
                    style: Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(fontFamily: "ProximaNova"),
                  ),
            trailing: ElevatedButton(
                onPressed: widget.onSubscribe != null
                    ? widget.onSubscribe
                    : () async {
                        final result = await Api.subscribe({
                          "id": UtilPreferences.getString(Preferences.clientId),
                          "reviewer": widget.item!.id.toString(),
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
                     /*   Fluttertoast.showToast(
                            msg: "Subscribed successfully", // message
                            toastLength: Toast.LENGTH_SHORT, // length
                            gravity: ToastGravity.BOTTOM_LEFT, // location
                            timeInSecForIosWeb: 1 // duration
                            );*/
                      },
                child: Text(
                  subscribedList
                      .where((element) =>
                  element.slug == widget.item!.slug)
                      .isNotEmpty ? 'Subscribed' : 'Subscribe',
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
