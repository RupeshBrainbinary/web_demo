import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:web_demo/models/model.dart';
import 'package:web_demo/utils/translate.dart';
import 'package:web_demo/widgets/widget.dart';

class AppReviewItem extends StatelessWidget {
  AppReviewItem({
    Key? key,
    this.item,
    this.onPressed,
    required this.type,
  }) : super(key: key);

  final ReviewModel? item;
  final ProductViewType type;
  final VoidCallback? onPressed;
  final currency = String.fromCharCode(0x24);

  @override
  Widget build(BuildContext context) {
    switch (type) {

      ///Mode View Small
      case ProductViewType.small:
        if (item == null) {
          return AppPlaceholder(
            child: Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  width: 80,
                  height: 80,
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 10,
                        width: 180,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 10,
                        width: 150,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 10,
                        width: 100,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(item!.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item!.clientName,
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(fontWeight: FontWeight.bold,fontFamily: "ProximaNova"),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item!.comment,overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(fontWeight: FontWeight.bold,fontFamily: "ProximaNova"),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          AppTag(
                            "${item!.rate}",
                            type: TagType.rate,
                            onPressed: null,
                          ),
                          const SizedBox(width: 4),
                          RatingBar.builder(
                            initialRating: item!.rate,
                            minRating: 1,
                            allowHalfRating: true,
                            unratedColor: Colors.amber.withAlpha(100),
                            itemCount: 5,
                            itemSize: 14.0,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            ignoreGestures: true,
                            onRatingUpdate: (double value) {},
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            height: 15,
                            width: 1.5,
                            color: Theme.of(context).textTheme.caption!.color,
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width /4,
                            child: Text(
                              item!.channelName,overflow: TextOverflow.ellipsis,maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(fontWeight: FontWeight.bold,fontFamily: "ProximaNova"),
                            ),
                          ),
                        ],
                      ),
                      /*Text(
                        '144k Subscribers',
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),*/
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // children: <Widget>[
                        //   AppTag(
                        //     "${item!.rate}",
                        //     type: TagType.rate,
                        //   ),
                        //   const SizedBox(width: 4),
                        //   RatingBar.builder(
                        //     initialRating: item!.rate,
                        //     minRating: 1,
                        //     allowHalfRating: true,
                        //     unratedColor: Colors.amber.withAlpha(100),
                        //     itemCount: 5,
                        //     itemSize: 14.0,
                        //     itemBuilder: (context, _) => const Icon(
                        //       Icons.star,
                        //       color: Colors.amber,
                        //     ),
                        //     ignoreGestures: true,
                        //     onRatingUpdate: (double value) {},
                        //   )
                        // ],
                      ),
                    ],
                  ),
                ),
              ),
              /*Row(
                children: [
                  const SizedBox(
                    height: 4,
                    width: 12,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Fluttertoast.showToast(
                            msg: "${item!.clientName} Subscribed successfully",
                            // message
                            toastLength: Toast.LENGTH_SHORT,
                            // length
                            gravity: ToastGravity.BOTTOM_LEFT,
                            // location
                            timeInSecForIosWeb: 1 // duration
                            );
                      },
                      child: const Text('Subscribe')),
                ],
              ),*/
            ],
          ),
        );

      ///Mode View Gird
      case ProductViewType.gird:
        if (item == null) {
          return AppPlaceholder(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 120,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 10,
                  width: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 4),
                Container(
                  height: 10,
                  width: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 20,
                  width: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 10,
                  width: 80,
                  color: Colors.white,
                ),
              ],
            ),
          );
        }

        return InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(item!.image),
                    fit: BoxFit.cover,
                  ),
                ),
                // child: Column(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: <Widget>[
                //     // Row(children: [status]),
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.end,
                //       children: <Widget>[
                //         Padding(
                //           padding: const EdgeInsets.all(4),
                //           child: Icon(
                //             item!.favorite
                //                 ? Icons.favorite
                //                 : Icons.favorite_border,
                //             color: Colors.white,
                //           ),
                //         )
                //       ],
                //     )
                //   ],
                // ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item!.clientName,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item!.comment,maxLines: 1,overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(fontWeight: FontWeight.bold,fontFamily: "ProximaNova"),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        AppTag(
                          "${item!.rate}",
                          type: TagType.rate,
                        ),
                        const SizedBox(width: 4),
                        RatingBar.builder(
                          initialRating: item!.rate,
                          minRating: 1,
                          allowHalfRating: true,
                          unratedColor: Colors.amber.withAlpha(100),
                          itemCount: 5,
                          itemSize: 14.0,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          ignoreGestures: true,
                          onRatingUpdate: (double value) {},
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item?.channelName ?? "",
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(fontWeight: FontWeight.bold,fontFamily: "ProximaNova"),
                    ),
                  ],
                ),
              )
            ],
          ),
        );

      ///Mode View List
      case ProductViewType.list:
        if (item == null) {
          return AppPlaceholder(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 120,
                  height: 140,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 10,
                          width: 80,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 10,
                          width: 100,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 20,
                          width: 80,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 10,
                          width: 100,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 10,
                          width: 80,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              width: 18,
                              height: 18,
                              color: Colors.white,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }

        return InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 120,
                height: 140,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(item!.image),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // children: [
                  //   status,
                  // ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item!.clientName,
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(fontWeight: FontWeight.bold,fontFamily: "ProximaNova"),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item!.comment,
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              fontWeight: FontWeight.bold,
                            fontFamily: "ProximaNova"
                            ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          AppTag(
                            "${item!.rate}",
                            type: TagType.rate,
                          ),
                          const SizedBox(width: 4),
                          RatingBar.builder(
                            initialRating: item!.rate,
                            minRating: 1,
                            allowHalfRating: true,
                            unratedColor: Colors.amber.withAlpha(100),
                            itemCount: 5,
                            itemSize: 14.0,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            ignoreGestures: true,
                            onRatingUpdate: (double value) {},
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Row(
                      //   children: <Widget>[
                      //     Icon(
                      //       Icons.location_on,
                      //       size: 12,
                      //       color: Theme.of(context).primaryColor,
                      //     ),
                      //     const SizedBox(width: 4),
                      //     Expanded(
                      //       child: Text(
                      //         item!.address,
                      //         maxLines: 1,
                      //         style: Theme.of(context).textTheme.caption,
                      //       ),
                      //     )
                      //   ],
                      // ),
                      const SizedBox(height: 8),
                      Text(
                        item!.channelName,
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(fontWeight: FontWeight.bold,fontFamily: "ProximaNova"),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );

      ///Mode View Block
      case ProductViewType.block:
        if (item == null) {
          return AppPlaceholder(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 200,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 10,
                        width: 150,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 10,
                        width: 200,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 10,
                        width: 150,
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
                )
              ],
            ),
          );
        }

        return InkWell(
          onTap: onPressed,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(item!.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const <Widget>[
                        /*Icon(
                        item!.favorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.white,
                      )*/
                        Text(""),
                      ],
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${item!.clientName} - ${item!.clientLocation}",
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(fontWeight: FontWeight.bold,fontFamily: "ProximaNova"),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item!.comment,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(fontWeight: FontWeight.bold,fontFamily: "ProximaNova"),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        AppTag(
                          "${item!.rate}",
                          type: TagType.rate,
                        ),
                        const SizedBox(width: 4),
                        RatingBar.builder(
                          initialRating: item!.rate,
                          minRating: 1,
                          allowHalfRating: true,
                          unratedColor: Colors.amber.withAlpha(100),
                          itemCount: 5,
                          itemSize: 14.0,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          ignoreGestures: true,
                          onRatingUpdate: (double value) {},
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item!.channelName,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(fontWeight: FontWeight.bold,fontFamily: "ProximaNova"),
                    ),
                  ],
                ),
              )
            ],
          ),
        );

      ///Case View Card large
      case ProductViewType.cardLarge:
        if (item == null) {
          return AppPlaceholder(
            child: Container(
              height: 210,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }

        return InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Container(
            height: 210,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: CachedNetworkImageProvider(item!.image),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item!.clientName,
                            maxLines: 1,
                           /* style:
                                TextStyle(color: Colors.black.withOpacity(0.5)),*/
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                  fontFamily: "ProximaNova"),
                          ),
                          Text(
                            // '$currency${item!.price}',
                            '',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.location_on,
                                  size: 12,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    item!.clientLocation,
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(color: Colors.white,fontFamily: "ProximaNova"),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 14,
                              ),
                              // const SizedBox(width: 4),
                              // Text(
                              //   '${item!.rate}',
                              //   maxLines: 1,
                              //   style: Theme.of(context)
                              //       .textTheme
                              //       .caption!
                              //       .copyWith(color: Colors.white),
                              // ),
                              const SizedBox(width: 4),
                              Text(
                                Translate.of(context).translate('rating'),
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: Colors.white,fontFamily: "ProximaNova"),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

      ///Case View Card small
      case ProductViewType.cardSmall:
        if (item == null) {
          return AppPlaceholder(
            child: Container(
              width: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }

        return SizedBox(
          width: 100,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onPressed,
            child: Card(
              elevation: 2,
              margin: const EdgeInsets.all(0),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(item!.image),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    item!.clientName,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        fontFamily: "ProximaNova"
                        ),
                  ),
                ),
              ),
            ),
          ),
        );

      default:
        return Container(width: 160.0);
    }
  }
}
