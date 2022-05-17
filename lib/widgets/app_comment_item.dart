import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:web_demo/api/api.dart';
import 'package:web_demo/models/comment_model.dart';
import 'package:web_demo/models/model_user.dart';
import 'package:web_demo/widgets/widget.dart';

class AppCommentItem extends StatelessWidget {
  final Comment? item;
  final CommentRes? reviewPage;


  const AppCommentItem({Key? key, this.item,this.reviewPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      return AppPlaceholder(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              height: 10,
                              width: 150,
                              color: Colors.white,
                            ),
                            Container(
                              height: 10,
                              width: 50,
                              color: Colors.white,
                            )
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 10,
                          width: 50,
                          color: Colors.white,
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 4),
              Container(
                height: 10,
                width: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Container(
                height: 10,
                color: Colors.white,
              ),
              const SizedBox(height: 4),
              Container(
                height: 10,
                color: Colors.white,
              ),
              const SizedBox(height: 4),
              Container(
                height: 10,
                color: Colors.white,
              ),
              const SizedBox(height: 4),
              Container(
                height: 10,
                color: Colors.white,
              ),
              const SizedBox(height: 4),
              Container(
                height: 10,
                color: Colors.white,
              )
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: FutureBuilder<UserModel>(
        future: Api.getReviewerDetail(int.parse(item!.clientId ?? '0')),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const SizedBox();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image:  CachedNetworkImageProvider(snap.data!.avatar),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                snap.data!.name,
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            item!.createdDate == null
                                ? SizedBox()
                                : Text(
                                    DateFormat('MMM dd, yyyy')
                                        .format(item!.createdDate!),
                                    style: Theme.of(context).textTheme.caption,
                                  )
                          ],
                        ),
                        const SizedBox(height: 4),
                        /*RatingBar.builder(
                          initialRating: 0,
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
                        )*/
                      ],
                    ),
                  )
                ],
              ),
           /*   const SizedBox(height: 4),
              Text(
               " item!.videoId.toString()",
                maxLines: 1,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(fontWeight: FontWeight.bold),
              ),*/
              const SizedBox(height: 8),
              Text(
                item!.content ?? '',
                maxLines: 5,
                style: Theme.of(context).textTheme.bodyText1,
              )
            ],
          );
        },
      ),
    );
  }
}
